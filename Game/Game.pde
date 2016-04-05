final int screenWidth = 1000;
final int screenHeight = 600;
final float depth = 500;

Box box;
Ball ball;
Mover mover;
GameState state;
ArrayList<Cylinder> savedCylinder;

void settings() {
  size(screenWidth, screenHeight, P3D);
}

void setup() {
  box = new Box();
  ball = new Ball(new PVector(0, 0, 0), 10);
  mover = new Mover(ball);
  state = GameState.STANDARD;
  savedCylinder = new ArrayList<Cylinder>();
}


void draw() {
  background(255, 255, 255);
  camera();
  translate(width/2., height/2., 0);
  
  if (state == GameState.STANDARD) {
    ambientLight(160, 160, 160, 0, -1, 0);
    directionalLight(85, 85, 100, -1, 1, -1);
    lightFalloff(1.0, 0.001, 0.0);
    perspective();
    rotateX(rx);
    rotateZ(rz);    
    
    mover.update(savedCylinder);
    mover.checkEdges(box);
  }
  else {
    ortho();
    rotateX(-PI/2);
  }
  drawAxis();
  noStroke();  
  pushMatrix();
    translate(0, -box.height/2, 0);
    for (Cylinder c : savedCylinder) c.display();
    ball.display();
  popMatrix();
  box.display();
  
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == SHIFT) {
      state = GameState.SHIFTMODE;
    }
  }
}

void keyReleased() {
  if (key == CODED) {
    if (keyCode == SHIFT) {
      state = GameState.STANDARD;
    }
  }
}

float speed = 1;
final float MIN_SPEED = 0.5, MAX_SPEED = 2;
void mouseWheel(MouseEvent event) {
  if (state==GameState.STANDARD) {
    speed -= event.getCount()/5.;
    speed = constrain(speed, MIN_SPEED, MAX_SPEED);
  }
}

float rz = 0, rx = 0;
final float MIN_ANGLE = -PI/3, MAX_ANGLE = PI/3;
void mouseDragged() {
  if (state == GameState.STANDARD) {
    float dz = speed / frameRate;
    float dx = speed / frameRate;
    if (mouseX > pmouseX)      rz += dz;
    else if (mouseX < pmouseX) rz -= dz;
    if (mouseY < pmouseY)      rx += dx;
    else if (mouseY > pmouseY) rx -= dx;
    rx = constrain(rx, MIN_ANGLE, MAX_ANGLE);
    rz = constrain(rz, MIN_ANGLE, MAX_ANGLE);
  }
}

void mouseClicked() {
  if (state == GameState.SHIFTMODE) {
    PVector pos = new PVector(mouseX - width/2., 0, mouseY - height/2.);
    if (pos.x >= -box.width/2  && pos.x <= box.width/2 &&
        pos.z >= -box.length/2 && pos.z <= box.length/2)
      savedCylinder.add(new Cylinder(15, 20, 40, pos));
  }
}
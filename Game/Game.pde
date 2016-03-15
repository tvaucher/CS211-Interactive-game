int screenWidth = 1000;
int screenHeight = 500;
float depth = 500;
MyBox myBox;
Mover mover;

void settings() {
  size(screenWidth, screenHeight, P3D);
  //fullScreen(P3D);
}

void setup() {
  myBox = new MyBox();
  mover = new Mover();
}


void draw() {
  camera(width/2, height/2, depth, width/2, height/2, 0, 0, 1, 0);
  lights();

  background(255, 255, 255);
  translate(screenWidth/2, screenHeight/2, 0);
  rotateX(rx);
  rotateZ(rz);
  strokeWeight(3);

  drawAxis();
  myBox.display();
  mover.update();
  mover.checkEdges(myBox);
  mover.display(15,myBox.height);
}

float speed = 1;
final float MIN_SPEED = 0.05f, MAX_SPEED = 2;
void mouseWheel(MouseEvent event) {
  speed -= event.getCount()/3.0;
  speed = between(speed, MIN_SPEED, MAX_SPEED);
}

float rz = 0, rx = 0;
final float MIN_ANGLE = -PI/3, MAX_ANGLE = PI/3;
void mouseDragged() {
  double dz = speed*0.05;
  double dx = speed*0.05;
  if (mouseX > pmouseX)      rz += dz;
  else if (mouseX < pmouseX) rz -= dz;
  if (mouseY < pmouseY)      rx += dx;
  else if (mouseY > pmouseY) rx -= dx;
  rx = between(rx, MIN_ANGLE, MAX_ANGLE);
  rz = between(rz, MIN_ANGLE, MAX_ANGLE);
}
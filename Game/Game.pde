// Screen constants
final int screenWidth = 1000;
final int screenHeight = 600;

// Global objects necessary for the game
Box box; //the plate
Ball ball;
Mover mover;
GameState state;
ArrayList<Cylinder> savedCylinder;

/**
 * @brief Processing method to create the settings of the window
 */
void settings() {
  size(screenWidth, screenHeight, P3D);
}

/**
 * @brief Processing method to set up the global necessary objects of the game
 */
void setup() {
  box = new Box();
  ball = new Ball(10, new PVector(0, 0, 0));
  mover = new Mover(ball);
  state = GameState.STANDARD;
  savedCylinder = new ArrayList<Cylinder>();
}

/**
 * @brief Processing method to draw the scene
 */
void draw() {
  background(255, 255, 255);
  camera();
  translate(width/2., height/2., 0);
  
  if (state == GameState.STANDARD) {
    // Set up lights for 3D scene
    ambientLight(160, 160, 160, 0, -1, 0);
    directionalLight(85, 85, 100, -1, 1, -1);
    lightFalloff(1.0, 0.001, 0.0);
    
    // Set up rotation for drawing the 3D scene
    perspective();
    rotateX(rx);
    rotateZ(rz);    
    drawAxis();
    
    // Mover logic
    mover.update();
    mover.checkEdges(savedCylinder, box); 
  }
  else {
    // Set up for 2D stopped Scene
    ortho();
    rotateX(-PI/2);
  }
  noStroke();
  pushMatrix();
    translate(0, -box.height/2, 0);
    for (Cylinder c : savedCylinder) c.display();
    ball.display();
  popMatrix();
  box.display();
}

/**
 * @brief Processing method to start the SHIFT mode if shift is held
 */
void keyPressed() {
  if (key == CODED) {
    if (keyCode == SHIFT) {
      state = GameState.SHIFTMODE;
    }
  }
}

/**
 * @brief Processing method to return to STANDARD mode if shift is released
 */
void keyReleased() {
  if (key == CODED) {
    if (keyCode == SHIFT) {
      state = GameState.STANDARD;
    }
  }
}

/**
 * @brief Moving speed manager using mouse wheel
 */
float speed = 1;
final float MIN_SPEED = 0.5, MAX_SPEED = 2;
void mouseWheel(MouseEvent event) {
  if (state==GameState.STANDARD) {
    speed -= event.getCount()/5.;
    speed = constrain(speed, MIN_SPEED, MAX_SPEED);
  }
}

/**
 * @brief Orientation manager, on axes x and z
 */
float rz = 0, rx = 0;
final float MIN_ANGLE = -PI/3, MAX_ANGLE = PI/3;
final float DIVISOR = 40;
void mouseDragged() {
  if (state == GameState.STANDARD) {
    float dz = speed / DIVISOR;
    float dx = speed / DIVISOR;
    if (mouseX > pmouseX)      rz += dz;
    else if (mouseX < pmouseX) rz -= dz;
    if (mouseY < pmouseY)      rx += dx;
    else if (mouseY > pmouseY) rx -= dx;
    rx = constrain(rx, MIN_ANGLE, MAX_ANGLE);
    rz = constrain(rz, MIN_ANGLE, MAX_ANGLE);
  }
}

/**
 * @brief Processing method, if in shift mode, add a cylinder at clicked position if on plate
 */
void mouseClicked() {
  if (state == GameState.SHIFTMODE) {
    PVector pos = new PVector(mouseX - width/2., 0, mouseY - height/2.);
    if (pos.x >= -box.width/2  && pos.x <= box.width/2 &&
        pos.z >= -box.length/2 && pos.z <= box.length/2)
      savedCylinder.add(new Cylinder(15, 20, 40, pos));
  }
}
int screenWidth = 500;
int screenHeight = 500;


void settings() {
  size(screenWidth, screenHeight, P3D);
}
void setup() {
}
int boxWidth = 200;
int boxHeight = 20;
int boxLength = 200;
int radius = 20;

void draw() {

  background(255, 255, 255);
  translate(screenWidth/2, screenHeight/2, 0);
  rotateX(rx);
  rotateZ(rz);
  fill(150, 150, 150);

  //sphere

  gravityAndFriction();
  checkEdges();
  pushMatrix();
  translate(0, -(radius+boxHeight/2.0), 0);
  translate(BallLocation.x, BallLocation.y, BallLocation.z); //added code for gravity
  sphere(radius);
  popMatrix();

  //Box
  box(boxWidth, boxHeight, boxLength);
}

//****************************
//Code for edges

void checkEdges() {
  if (BallLocation.x > boxWidth/2.0) {
    BallLocation.x = boxWidth/2.0;
    velocity.x=-velocity.x;
  } else if (BallLocation.x < -boxWidth/2.0) {
    BallLocation.x = -boxWidth/2.0;
    velocity.x=-velocity.x;
  }
  if (BallLocation.z > boxLength/2.0) {
    BallLocation.z = boxLength/2.0;
    velocity.z=-velocity.z;
  } else if (BallLocation.z < -boxLength/2.0) {
    BallLocation.z = -boxLength/2.0;
    velocity.z=-velocity.z;
  }
}

//End edges
//*****************************

//****************************
//Code for gravity and bounce
PVector BallLocation = new PVector(0, 0, 0);
PVector velocity = new PVector(0, 0, 0);

void gravityAndFriction() {
  PVector gravityForce= new PVector(0, 0, 0);
  final float gravityConstant = 0.05;
  gravityForce.x = sin(rz) * gravityConstant;
  gravityForce.z = -sin(rx) * gravityConstant;


  float normalForce = 1;
  float mu = 0.01;
  float frictionMagnitude = normalForce * mu;
  PVector friction = velocity.copy();
  friction.mult(-1);
  friction.normalize();
  friction.mult(frictionMagnitude);

  velocity.add(gravityForce).add(friction);
  BallLocation.add(velocity);
}
//End Gravity and bounce
//*************************

float speed = 1;
float maxSpeed = 8;
float minSpeed = 0.05;
void mouseWheel(MouseEvent event) {
  speed -= event.getCount()/3.0;
  if (speed<=minSpeed) {
    speed=minSpeed;
  } else if (speed>=maxSpeed) {
    speed=maxSpeed;
  }
}


float rz = 0;
float rx = 0;
void mouseDragged() {
  double dz = speed*0.1;
  double dx = speed*0.1;
  if (mouseX>pmouseX) {
    if (rz+dz>PI/3) {
      rz=PI/3;
    } else {
      rz += dz;
    }
  } else if (mouseX<pmouseX) {
    if (rz-dz<-PI/3) {
      rz= -PI/3;
    } else {
      rz -= dz;
    }
  }
  if (mouseY<pmouseY) {
    if (rx+dx>PI/3) {
      rx=PI/3;
    } else {
      rx += dx;
    }
  } else if (mouseY>pmouseY) {
    if (rx-dx<-PI/3) {
      rx= -PI/3;
    } else {
      rx -= dx;
    }
  }
}
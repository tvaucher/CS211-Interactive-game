int screenWidth = 500;
int screenHeight = 500;

void settings() {
  size(screenWidth, screenHeight, P3D);
}
void setup() {
  
}
int boxWidth = 100;
int boxHeight = 20;
int boxLength = 100;
void draw() {
  background(255,255,255);
  translate(screenWidth/2, screenHeight/2, 0);
  rotateX(rx);
  rotateZ(rz);
  fill(150,150,150);
  box(boxWidth, boxHeight, boxLength);
}

float speed = 1;
float maxSpeed = 8;
float minSpeed = 0.05;
void mouseWheel(MouseEvent event) {
  speed -= event.getCount()/3.0;
  if(speed<=minSpeed){
    speed=minSpeed;
  }
  else if(speed>=maxSpeed){
    speed=maxSpeed;
  }
}


float rz = 0;
float rx = 0;
void mouseDragged() {
  double dz = speed*0.1;
  double dx = speed*0.1;
    if (mouseX<pmouseX) {
      if(rz+dz>PI/3){
        rz=PI/3;
      }
      else{
        rz += dz;
      }
    }
    else if (mouseX>pmouseX) {
      if(rz-dz<-PI/3){
        rz= -PI/3;
      }
      else{
        rz -= dz;
      }
    }
    if (mouseY>pmouseY) {
      if(rx+dx>PI/3){
        rx=PI/3;
      }
      else{
        rx += dx;
      }
    }
    else if (mouseY<pmouseY) {
      if(rx-dx<-PI/3){
        rx= -PI/3;
      }
      else{
        rx -= dx;
      }
    }
  
}
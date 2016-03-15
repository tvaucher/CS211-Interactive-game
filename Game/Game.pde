int screenWidth = 1000;
int screenHeight = 500;
float depth = 500;

void settings() {
  size(screenWidth, screenHeight, P3D);
}
void setup() {
  
}
int boxWidth = 200;
int boxHeight = 10;
int boxLength = 200;
void draw() {
  camera(width/2, height/2, depth, width/2, height/2, 0, 0, 1, 0);
  lights();
  
  background(255,255,255);
  translate(screenWidth/2, screenHeight/2, 0);
  rotateX(rx);
  rotateY(0/100.);
  rotateZ(rz);
  strokeWeight(3);
  textSize(20);
  
  stroke(255,0,0);
  fill(255,0,0);
  line(-200,0,0,200,0,0);
  text("X",200,1,1);
  
  stroke(0,255,0);
  fill(0,255,0);
  line(0,-200,0,0,200,0);
  text("Y",1,200,1);
  
  stroke(0,0,255);
  fill(0,0,255);
  line(0,0,-200,0,0,200);
  text("Z",1,1,200);
  
  fill(150,150,150);
  noStroke();
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
  double dz = speed*0.05;
  double dx = speed*0.05;
    if (mouseX>pmouseX) {
      if(rz+dz>PI/3){
        rz=PI/3;
      }
      else{
        rz += dz;
      }
    }
    else if (mouseX<pmouseX) {
      if(rz-dz<-PI/3){
        rz= -PI/3;
      }
      else{
        rz -= dz;
      }
    }
    if (mouseY<pmouseY) {
      if(rx+dx>PI/3){
        rx=PI/3;
      }
      else{
        rx += dx;
      }
    }
    else if (mouseY>pmouseY) {
      if(rx-dx<-PI/3){
        rx= -PI/3;
      }
      else{
        rx -= dx;
      }
    }
  
}
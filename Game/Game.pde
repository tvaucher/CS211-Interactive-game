//import java.util.List;

int screenWidth = 1000;
int screenHeight = 500;
float depth = 500;
MyBox myBox;
Mover mover;
GameState state;
ArrayList<Cylinder> savedCylinder = new ArrayList<Cylinder>();


void settings() {
  size(screenWidth, screenHeight, P3D);
  //fullScreen(P3D);
}

void setup() {
  myBox = new MyBox();
  mover = new Mover();
  state = GameState.RUNNING;
}


void draw() {
  camera(width/2, height/2, depth, width/2, height/2, 0, 0, 1, 0);
  lights();

  background(255, 255, 255);
  translate(screenWidth/2, screenHeight/2, 0);
  
  
  if(state== GameState.RUNNING){
    rotateX(rx);
    rotateZ(rz);
    mover.update();
    mover.checkEdges(myBox);
    
  }
 
  else{
    rotateX(-PI/2);
    
    
  }
  
  strokeWeight(3);
  drawAxis();
  myBox.display();
  mover.display(15,myBox.height);
  
  for(Cylinder c : savedCylinder){
    c.display();
  }
}

void mouseClicked(){
  if(state==GameState.STOPPED){
    savedCylinder.add(new Cylinder(50,50,40,new PVector(mouseX,0,mouseY)));
  }
}

void keyPressed(){
  if (key == CODED) {
    if (keyCode == SHIFT) {
      state = GameState.STOPPED;
    }
  } 
}
void keyReleased(){
   if (key == CODED) {
    if (keyCode == SHIFT) {
      state = GameState.RUNNING; 
    }
  }
}

float speed = 1;
final float MIN_SPEED = 0.05f, MAX_SPEED = 2;
void mouseWheel(MouseEvent event) {
  if(state==GameState.RUNNING){
    speed -= event.getCount()/3.0;
    speed = between(speed, MIN_SPEED, MAX_SPEED);
  }
}

float rz = 0, rx = 0;
final float MIN_ANGLE = -PI/3, MAX_ANGLE = PI/3;
void mouseDragged() {
  if(state==GameState.RUNNING){
    double dz = speed*0.05;
    double dx = speed*0.05;
    if (mouseX > pmouseX)      rz += dz;
    else if (mouseX < pmouseX) rz -= dz;
    if (mouseY < pmouseY)      rx += dx;
    else if (mouseY > pmouseY) rx -= dx;
    rx = between(rx, MIN_ANGLE, MAX_ANGLE);
    rz = between(rz, MIN_ANGLE, MAX_ANGLE);
  }
}
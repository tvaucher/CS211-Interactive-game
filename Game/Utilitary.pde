float between(float value, float lower, float upper) {
  if (value < lower) return lower;
  else if (value > upper) return upper;
  else return value;
}

int maVarici = 0;

void drawAxis() {
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
}
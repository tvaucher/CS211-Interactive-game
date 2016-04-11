/**
 *  @brief utulitary method to draw the three axis with legend and color 
 */
public void drawAxis() {
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
}

public void displayBackgroundDataVis() {
  backgroundDataVis.beginDraw();
  backgroundDataVis.background(255,240,190);
  backgroundDataVis.endDraw();
  image(backgroundDataVis, 0, screenHeight - backgroundDataVisHeight);
}
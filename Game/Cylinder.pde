class Cylinder {
  float cylinderBaseSize;
  float cylinderHeight;
  int cylinderResolution;
  PShape openCylinderBot;
  PShape openCylinderTop;
  PShape openCylinder;
  PShape cylinder;
  PVector position;

  Cylinder(float baseSize, float cylHeight, int resolution, PVector v) {
    cylinderBaseSize = baseSize;
    cylinderHeight = cylHeight;
    cylinderResolution= resolution;
    position = v.copy();
    initialize();
  }

  void display() {
    pushMatrix();
      rotateX(PI/2);
      translate(0, -15, 0);
      translate(-screenWidth/2 + position.x, -screenHeight/2 + position.y, position.z);
      shape(cylinder);
    popMatrix();
  }

  void initialize() {
    float angle;
    float[] x = new float[cylinderResolution + 1];
    float[] y = new float[cylinderResolution + 1];
    //get the x and y position on a circle for all the sides
    for (int i = 0; i < x.length; i++) {
      angle = (TWO_PI / cylinderResolution) * i;
      x[i] = sin(angle) * cylinderBaseSize;
      y[i] = cos(angle) * cylinderBaseSize;
    }



    openCylinder = createShape();
    openCylinder.beginShape(QUAD_STRIP);
    //draw the border of the cylinder
    for (int i = 0; i < x.length; i++) {
      openCylinder.vertex(x[i], y[i], 0);
      openCylinder.vertex(x[i], y[i], cylinderHeight);
    }
    openCylinder.endShape();

    //draw the bottom (triangle)
    openCylinderBot = createShape();
    openCylinderBot.beginShape(TRIANGLE_FAN);
    openCylinderBot.vertex(0, 0, 0);
    for (int i = 0; i < x.length; i++) {
      openCylinderBot.vertex(x[i], y[i], 0);
    }
    openCylinderBot.endShape();

    //draw the top (triangle)
    openCylinderTop = createShape();
    openCylinderTop.beginShape(TRIANGLE_FAN);
    openCylinderTop.vertex(0, 0, cylinderHeight);
    for (int i = 0; i < x.length; i++) {
      openCylinderTop.vertex(x[i], y[i], cylinderHeight);
    }
    openCylinderTop.endShape();

    cylinder = createShape(GROUP);
    cylinder.addChild(openCylinderTop);
    cylinder.addChild(openCylinder);
    cylinder.addChild(openCylinderBot);
    cylinder.setFill(color(255,0,0));
  }
}
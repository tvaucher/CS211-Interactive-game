class Cylinder {
  final float cylinderBaseSize;
  final float cylinderHeight;
  final int cylinderResolution;
  PShape openCylinderBot;
  PShape openCylinderTop;
  PShape openCylinder;
  PShape cylinder;
  final PVector position;

  Cylinder(float baseSize, float cylHeight, int resolution, PVector v) {
    cylinderBaseSize = baseSize;
    cylinderHeight = cylHeight;
    cylinderResolution = resolution;
    position = v.copy();
    initialize();
  }

  void display() {
    pushMatrix();
      translate(position.x, 0, position.y);
      shape(cylinder);
    popMatrix();
  }

  void initialize() {
    float angle;
    float[] x = new float[cylinderResolution + 1];
    float[] z = new float[cylinderResolution + 1];
    //get the x and z position on a circle for all the sides
    for (int i = 0; i < x.length; i++) {
      angle = (TWO_PI / cylinderResolution) * i;
      x[i] = sin(angle) * cylinderBaseSize;
      z[i] = cos(angle) * cylinderBaseSize;
    }

    openCylinder = createShape();
    openCylinder.beginShape(QUAD_STRIP);
    //draw the border of the cylinder
    for (int i = 0; i < x.length; i++) {
      openCylinder.vertex(x[i], 0, z[i]);
      openCylinder.vertex(x[i], -cylinderHeight, z[i]);
    }
    openCylinder.endShape();

    //draw the bottom (triangle)
    openCylinderBot = createShape();
    openCylinderBot.beginShape(TRIANGLE_FAN);
    openCylinderBot.vertex(0, 0, 0);
    for (int i = 0; i < x.length; i++) {
      openCylinderBot.vertex(x[i], 0, z[i]);
    }
    openCylinderBot.endShape();

    //draw the top (triangle)
    openCylinderTop = createShape();
    openCylinderTop.beginShape(TRIANGLE_FAN);
    openCylinderTop.vertex(0, -cylinderHeight, 0);
    for (int i = 0; i < x.length; i++) {
      openCylinderTop.vertex(x[i], -cylinderHeight, z[i]);
    }
    openCylinderTop.endShape();

    cylinder = createShape(GROUP);
    cylinder.addChild(openCylinderTop);
    cylinder.addChild(openCylinder);
    cylinder.addChild(openCylinderBot);
    cylinder.setFill(color(255,0,0));
  }
  
  void speak() {
    println("x : " + position.x + ", z : " + position.y);
  }
}
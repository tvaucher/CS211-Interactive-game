class Cylinder extends Shape {
  final float radius;
  final float cHeight;
  final int resolution;
  PShape openCylinderBot;
  PShape openCylinderTop;
  PShape openCylinder;
  PShape cylinder;

  Cylinder(float r, float h, int res, PVector p) {
    super(p);
    radius = r;
    cHeight = h;
    resolution = res;
    initialize();
  }

  void display() {
    pushMatrix();
      translate(position.x, 0, position.z);
      shape(cylinder);
    popMatrix();
  }

  void initialize() {
    float angle;
    float[] x = new float[resolution + 1];
    float[] z = new float[resolution + 1];
    //get the x and z position on a circle for all the sides
    for (int i = 0; i < x.length; i++) {
      angle = (TWO_PI / resolution) * i;
      x[i] = sin(angle) * radius;
      z[i] = cos(angle) * radius;
    }

    openCylinder = createShape();
    openCylinder.beginShape(QUAD_STRIP);
    //draw the border of the cylinder
    for (int i = 0; i < x.length; i++) {
      openCylinder.vertex(x[i], 0, z[i]);
      openCylinder.vertex(x[i], -cHeight, z[i]);
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
    openCylinderTop.vertex(0, -cHeight, 0);
    for (int i = 0; i < x.length; i++) {
      openCylinderTop.vertex(x[i], -cHeight, z[i]);
    }
    openCylinderTop.endShape();

    cylinder = createShape(GROUP);
    cylinder.addChild(openCylinderTop);
    cylinder.addChild(openCylinder);
    cylinder.addChild(openCylinderBot);
    cylinder.setFill(color(255,0,0));
  }
}
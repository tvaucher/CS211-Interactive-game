/**
 * @brief Cylinder class that extends abstract class Shape.
 * Responsible of creating a complete cylinder and store its position
 * 
 * @author Simon Haefeli (246663)
 * @author Timoté Vaucher (246532)
 */
public class Cylinder extends Shape {
  public final float radius;
  private final float cHeight;
  private final int resolution;
  private PShape openCylinderBot;
  private PShape openCylinderTop;
  private PShape openCylinder;
  private PShape cylinder;
  
  /**
   * @brief Constructs a cylinder with the given parameters
   * @param r   The cylinder radius
   * @param h   The cylinder height
   * @param res The cylinder resulution (approx of circle)
   * @param p   The cylinder position
   */
  public Cylinder(float r, float h, int res, PVector p) {
    super(p);
    radius = r;
    cHeight = h;
    resolution = res;
    initialize();
  }
  
  /**
   * @brief Implementation of Shape.display
   * Must translate first to position before drawing
   * Hypothesis on origin : on the plate on its center 
   */
  public void display() {
    pushMatrix();
      translate(position.x, 0, position.z);
      shape(cylinder);
    popMatrix();
  }
  
  /**
   * @brief Initializes the top/bottom circles and the open cylinder. 
   *        Creates a group to draw the parts together easily
   */
  private void initialize() {
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
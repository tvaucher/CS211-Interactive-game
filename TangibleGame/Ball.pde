/**
 * @brief Ball class that extends abstract class Shape.
 * 
 * @author Simon Haefeli (246663)
 * @author Timoté Vaucher (246532)
 */
public class Ball extends Shape {
  public final float radius;
  
  /**
   * @brief Creates the ball given its position and radius
   * @param r The radius of the ball
   * @param p The posiition of the ball
   */
  public Ball(float r, PVector p) {
    super(p);
    radius = r;
  }
  
  /**
   * @brief Implementation of Shape.display
   * Must translate first to position and add radius before drawing
   * Hypothesis on origin : on the plate on its center 
   */
  public void display() {
    pushMatrix();
      translate(0, -radius, 0); //move to center of the sphere plane
      translate(position.x, position.y, position.z);
      fill(0, 255, 0);
      sphere(radius);
    popMatrix();
  }
}
/**
 * @brief Super class of the shapes that provides core for other shapes
 *        => a shape has a position and can draw itself
 * @author Simon Haefeli (246663)
 * @author Timoté Vaucher (246532)
 */
public abstract class Shape {
  protected PVector position;
  
  /**
   * @brief Constructs a Shape based on its position
   * @param p The position of the center of the shape
   */
  public Shape(PVector p) {
    position = p.copy();
  }
  
  /**
   * @brief Abstract method to be implemented by sub classes. Draws the Shape
   */
  public abstract void display();
}
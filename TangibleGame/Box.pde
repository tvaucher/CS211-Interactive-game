/**
 * @brief Box class that extends abstract class Shape.
 * 
 * @author Simon Haefeli (246663)
 * @author Timoté Vaucher (246532)
 */
public class Box extends Shape {
  private float width;
  private float height;
  private float length;
  
  /**
   * @brief Creates the box given its dimensions.
   * 
   * @param width  The box width
   * @param height The box height
   * @param length The box length
   * @param p      The box position
   */
  public Box(int width, int height, int length, PVector p) {
    super(p);
    this.width = width;
    this.height = height;
    this.length = length;
  }
  
  /**
   * @brief Special constructor used to create the game plate
   */
  public Box() {
    this(350, 15, 350, new PVector(0, 0, 0));
  }
  
  /**
   * @brief Implementation of Shape.display
   */
  public void display() {
    // If we are below the board, it's slightly transparent to be able to see the game
    if (rx < 0) fill(200,200,200);
    else fill(200, 200, 200, 150);
    box(width, height, length);
  }
}
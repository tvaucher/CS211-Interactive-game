public class Box extends Shape {
  private float width;
  private float height;
  private float length;
  
  public Box(int width, int height, int length) {
    super(new PVector(0, 0, 0));
    this.width = width;
    this.height = height;
    this.length = length;
  }
  
  public Box() {
    this(350, 15, 350);
  }
  
  public void display() {
    fill(150);
    noStroke();
    box(width, height, length);
  }
}
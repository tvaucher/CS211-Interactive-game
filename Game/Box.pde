public class MyBox {
  private int width;
  private int height;
  private int length;
  
  public MyBox(int width, int height, int length) {
    this.width = width;
    this.height = height;
    this.length = length;
  }
  
  public MyBox() {
    this(200, 10, 200);
  }
  
  public void draw() {
    fill(150, 150, 150);
    noStroke();
    box(width, height, length);
  }
}
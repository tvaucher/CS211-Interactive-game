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
    this(300, 15, 300);
  }
  
  public void display() {
    fill(150, 150, 150);
    noStroke();
    box(width, height, length);
  }
}
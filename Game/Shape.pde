public abstract class Shape {
  protected PVector position;
  
  public Shape(PVector p) {
    position = p.copy();
  }
  
  public abstract void display();
}
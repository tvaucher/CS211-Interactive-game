public class Ball extends Shape {
  final float radius;
  
  public Ball(PVector p, float r) {
    super(p);
    radius = r;
  }
  
  public void display() {
    pushMatrix();
      translate(0, -radius, 0); //move to center of the sphere plane
      translate(position.x, position.y, position.z);
      fill(0, 255, 0);
      sphere(radius);
    popMatrix();
  }
}
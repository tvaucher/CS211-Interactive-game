public class TopView {
  private final int height;
  private final int width;
  private final int border;
  private final PGraphics view;
  private final float scalingFactor;
  private PVector oldPos;

  public TopView(int w, int h, int b, float box_width) {
    height = h;
    width = w;
    border = b;
    view = createGraphics(w, h, P2D);
    scalingFactor = w/box_width;
    oldPos = new PVector (-100, -100, -100);
    view.beginDraw();
    view.background(70, 90, 140);
    view.endDraw();
  }

  public void display(ArrayList<Cylinder> cylinders, Ball b) {
    view.beginDraw();
    //view.background(70, 90, 140);

    //The trail is drawn
    view.fill(60, 75, 110);
    view.ellipse(oldPos.x, oldPos.z, 
      b.radius*scalingFactor*2, b.radius*scalingFactor*2);

    //Cylinders are drawn
    view.noStroke();
    view.fill(255, 0, 0);
    for (Cylinder c : cylinders) {
      PVector modPositionCyl = boxToTopViewCoord(c.position, scalingFactor);
      view.ellipse(modPositionCyl.x, modPositionCyl.z, 
        c.radius*scalingFactor*2, c.radius*scalingFactor*2);
    }

    //The ball is drawn
    view.fill(0, 255, 0);
    PVector modPositionBall = boxToTopViewCoord(b.position, scalingFactor);
    view.ellipse(modPositionBall.x, modPositionBall.z, 
      b.radius*scalingFactor*2, b.radius*scalingFactor*2);
    oldPos = modPositionBall.copy();

    view.endDraw();

    image(view, border, border+screenHeight-backgroundDataVisHeight);
  }

  private PVector boxToTopViewCoord(PVector originalPos, float scalingFactor) {
    return new PVector((originalPos.x+(box.width/2))*scalingFactor, 
      originalPos.y, (originalPos.z +(box.length/2))*scalingFactor);
  }
}
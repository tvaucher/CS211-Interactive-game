public class ScoreView {
  private final int height;
  private final int width;
  //private final int border;
  private final PGraphics view;

  public ScoreView(int w, int h) {
    height = h;
    width = w;
    //border = b;
    view = createGraphics(w, h, P2D);
  }

  public void display(Mover m, ScoreManager s) {
    int left = 15;
    int top = 25;
    int weight = 15;
    int space = 25;
    view.beginDraw();

    //Draw Background and border
    view.background(0, 0);
    view.noFill();
    view.stroke(255);
    view.strokeWeight(4);
    view.rect(0, 0, width, height);

    //Draw Score
    view.stroke(0);
    view.fill(0);
    view.textSize(weight);
    view.text("Total Score:", left, top);
    view.text(s.currScore, left, top + weight);
    view.text("Velocity", left, top + weight + space);
    view.text(m.velocity.mag(), left, top + 2*weight + space);
    view.text("Last Score", left, top + 2*weight + 2*space);
    view.text(s.lastScore, left, top + 3*weight + 2*space);
    view.endDraw();
    image(view, border*2+topViewWidth, border+screenHeight-backgroundDataVisHeight);
  }
}
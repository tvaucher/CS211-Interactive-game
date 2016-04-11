import java.util.List;

public class BarChart {
  private final int height;
  private final int width;
  //private final int border;
  private final PGraphics view;
  
  private final float baseWidth = 5;
  private float factor;

  public BarChart(int w, int h) {
    height = h;
    width = w;
    //border = b;
    view = createGraphics(w, h, P2D);
    factor = 0.5;
  }
  
  public void display(ScoreManager s, HScrollbar h) {
    if (frameCount % 60 == 0) s.addStep();
    factor = h.getPos();
    view.beginDraw();

    //Draw Background and border
    view.background(255,250,200);
    
    //Draw Chart
    view.translate(0, height);
    view.fill(70, 90, 140);
    view.stroke(200);
    List<Float> steps = s.steps();
    for (int i = 0; i < steps.size(); ++i) {
      float v = steps.get(i);
      if (v > 0) {
        for (int j = 0; j < (int) Math.ceil(v / s.scaleScore() * subdivision()); ++j) {
          view.rect(width()*i, -baseWidth*j, width(), -baseWidth);
        }
      }
    }
    
    view.endDraw();
    image(view, border*3+topViewWidth+scoreWidth, border+screenHeight-backgroundDataVisHeight);
  }
  
  private float width() {
    return baseWidth * 2 * factor;
  }
  
  private int subdivision() {
     return (int) (this.height / baseWidth) - 1; 
  }
}
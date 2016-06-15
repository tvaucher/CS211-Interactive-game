import java.util.Collections;
import java.util.List;

public class ScoreManager {
  private float currScore;
  private float lastScore;
  private ArrayList<Float> steps;
  private float scaleScore;

  public ScoreManager() {
    currScore = 0;
    lastScore = 0;
    steps = new ArrayList<Float>();
    scaleScore = 25;
  }

  public void hitEvent(PVector v, Ratio ratio) {
    lastScore = ratio.value() * v.mag();
    currScore += lastScore;
  }

  public void addStep() {
    if (currScore > scaleScore) scaleScore = currScore;
    steps.add(currScore);
  }

  public List<Float> steps() {
    return Collections.unmodifiableList(new ArrayList<Float>(steps));
  }
  
  public float scaleScore() {
    return scaleScore; 
  }
}

public enum Ratio {
  WALL(-2), CYLINDER(5);
  
  private final int value;
  
  private Ratio(int v) {
    value = v;
  }
  
  public int value() {
    return value;
  }
}
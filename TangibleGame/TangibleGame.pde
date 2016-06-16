import processing.video.*;

// To the corrector's intention
final String FILENAME = "FullPathToTestVideo.mp4";

// Screen constants
final int screenWidth = 1000;
final int screenHeight = 800;
final int border = 10;
final int backgroundDataVisHeight = 150;
final int topViewHeight = backgroundDataVisHeight-2*border;
final int topViewWidth = topViewHeight;
final int scoreWidth = 120;
final int scoreHeight = topViewHeight;
final int barChartWidth = screenWidth - 4*border - topViewWidth - scoreWidth;
final int barChartHeight = backgroundDataVisHeight - 50;
final int hsWidth = barChartWidth;
final int hsHeight = backgroundDataVisHeight - 3 * border - barChartHeight;

// Global objects necessary for the game
Box box; //the plate
Ball ball;
Mover mover;
GameState state;
ArrayList<Cylinder> savedCylinder;
PGraphics backgroundDataVis;
TopView topView;
ScoreView scoreView;
ScoreManager scoreManager;
BarChart barChart;
HScrollbar hs;

// Image processsing one
ImageProcessing imgproc;

// Movie parameter
Movie cam;
//Capture cam; //Webcam

final int MOVIE_WIDTH = 640;
final int MOVIE_HEIGHT = 480;

/**
 * @brief Processing method to create the settings of the window
 */
void settings() {
  size(screenWidth, screenHeight, P3D);
}

/**
 * @brief Processing method to set up the global necessary objects of the game
 */
void setup() {
  box = new Box();
  ball = new Ball(10, new PVector(0, 0, 0));
  mover = new Mover(ball);
  state = GameState.STANDARD;
  savedCylinder = new ArrayList<Cylinder>();
  backgroundDataVis = createGraphics(screenWidth, backgroundDataVisHeight, P2D);
  topView = new TopView(topViewWidth, topViewHeight, border, box.width);
  scoreView = new ScoreView(scoreWidth, scoreHeight);
  scoreManager = new ScoreManager();
  barChart = new BarChart(barChartWidth, barChartHeight);
  hs = new HScrollbar(border*3+topViewWidth+scoreWidth, 2*border+screenHeight-backgroundDataVisHeight+barChartHeight, 
    hsWidth, hsHeight);

  imgproc = new ImageProcessing();
  cam = new Movie(this, FILENAME);
  cam.loop();
  //If you want to use the webcam
  /*String[] cameras = Capture.list();
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }
    cam = new Capture(this, cameras[0]);
    cam.start();
  }*/
}

/**
 * @brief Processing method to draw the scene
 */
void draw() {
  //If you want to use the webcam
  /* if (cam.available() == true) {
    cam.read();
  }*/
  background(255, 255, 255);
  imgproc.displayCam(cam.get());
  if (state == GameState.SHIFTMODE) drawPause();
  displayBackgroundDataVis();
  topView.display(savedCylinder, ball);
  scoreView.display(mover, scoreManager);
  hs.update();
  barChart.display(scoreManager, hs);
  hs.display();
  
  camera();
  translate(width/2., height/2., 0);

  if (state == GameState.STANDARD) {
    // Set up lights for 3D scene
    ambientLight(160, 160, 160, 0, -1, 0);
    directionalLight(85, 85, 100, -1, 1, -1);
    lightFalloff(1.0, 0.001, 0.0);

    // Set up rotation for drawing the 3D scene
    perspective();
    if ((frameCount & 1) == 0) setRotation();
    rotateX(rx);
    rotateZ(rz);    
    drawAxis();

    // Mover logic
    mover.update();
    mover.checkEdges(savedCylinder, box, scoreManager);
  } else {
    // Set up for 2D stopped Scene
    ortho();
    rotateX(-PI/2);
  }
  noStroke();
  pushMatrix();
  translate(0, -box.height/2, 0);
  for (Cylinder c : savedCylinder) c.display();
  ball.display();
  popMatrix();
  box.display();
}

/**
 * @brief Processing method to start the SHIFT mode if shift is held
 */
void keyPressed() {
  if (key == CODED) {
    if (keyCode == SHIFT) {
      state = GameState.SHIFTMODE;
      cam.pause();
    }
  }
}

/**
 * @brief Processing method to return to STANDARD mode if shift is released
 */
void keyReleased() {
  if (key == CODED) {
    if (keyCode == SHIFT) {
      state = GameState.STANDARD;
      cam.play();
    }
  }
}

/**
 * @brief Processing method, if in shift mode, add a cylinder at clicked position if on plate
 */
void mouseClicked() {
  if (state == GameState.SHIFTMODE) {
    PVector pos = new PVector(mouseX - width/2., 0, mouseY - height/2.);
    if (pos.x >= -box.width/2  && pos.x <= box.width/2 &&
      pos.z >= -box.length/2 && pos.z <= box.length/2)
      savedCylinder.add(new Cylinder(15, 20, 40, pos));
  }
}

// Called every time a new frame is available to read
void movieEvent(Movie m) {
  m.read();
}

/**
 * @brief Orientation manager, on axes x and z
 */
float rz = 0, rx = 0;
final float MIN_ANGLE = -PI/3, MAX_ANGLE = PI/3;
void setRotation() {
  PVector rotation = imgproc.rotation(cam.get());
  if (rotation != null) {
    rx = rotation.x; // According to week12 we should use r_x and r_y to tilt (and not r_z)
    rz = rotation.y;
    rx = constrain(rx, MIN_ANGLE, MAX_ANGLE);
    rz = constrain(rz, MIN_ANGLE, MAX_ANGLE);
  }
}
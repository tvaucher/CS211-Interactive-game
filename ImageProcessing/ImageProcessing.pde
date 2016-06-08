// To the corrector's intention :
// So you can easily change the filename
final String FILENAME = "board4.jpg";

// Main constants
final float[][] gaussianKernel = {
  {9, 12, 9}, 
  {12, 15, 12}, 
  {9, 12, 9}};
final float discretizationStepsPhi = 0.02f;
final float discretizationStepsR = 2.5f;
final int phiDim = (int) (Math.PI / discretizationStepsPhi);
TrigonometricAccelerator trigo;
Hough hough;

//Utilities for using the webcam
import processing.video.*;
Capture cam;
PImage img;



// Thresholding constants
int MIN_COLOR = 80, MAX_COLOR = 140;
int MIN_BRIGHT = 30, MAX_BRIGHT = 170;
int MIN_SATURATION = 75, MAX_SATURATION = 255;
int BINARY_THRESHOLD = 35;

// Hough
int NEIGHBOURHOOD = 20; // size of the region we search for a local maximum
int MIN_VOTE = 150;     // only search around lines with more that this amount of votes
// Area
int MIN_AREA = 70000, MAX_AREA = 350000;

// Main processing methods
void settings() {
  size(1600, 800); // Resize img and sobel : 640x480, hough transform : 480x480
                   // In order to fit on a 1920x1080 screen
  trigo = new TrigonometricAccelerator(phiDim, discretizationStepsR, discretizationStepsPhi);
}

void setup() {
  
//------BEGIN WEBCAM PART 1-------------
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
//------END WEBCAM PART 1-------------
  
  //-----BEGIN static part-------
  PImage boardImg = loadImage(FILENAME);
  boardImg.resize(640,480);
  drawAugmentedImage(boardImg);
  noLoop();
  //------END static part--------
}

//------BEGIN WEBCAM PART 2-------------
/*void draw() {
  if (cam.available() == true) {
    cam.read();
  }
   img = cam.get();
   drawAugmentedImage(img);
}*/
//------END WEBCAM PART 2-------------

void drawAugmentedImage(PImage boardImg){
  image(boardImg, 0, 0);
  PImage filtered = brightnessColorAndSaturationFilter(MIN_BRIGHT, MAX_BRIGHT, MIN_SATURATION, MAX_SATURATION, MIN_COLOR, MAX_COLOR, boardImg);
 
  PImage gaussian2 = convolute(gaussianKernel, filtered);
  
  PImage binaryFilter = binaryFilter(BINARY_THRESHOLD, gaussian2);

  PImage sobel = sobel(binaryFilter);

  hough = new Hough(sobel, 6);
  QuadGraph graph = new QuadGraph(hough.lines, boardImg.width, boardImg.height);
  graph.findCycles();
  
  graph.displayBestQuad(hough.lines, boardImg.width);
  
}
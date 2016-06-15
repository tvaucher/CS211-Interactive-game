// To the corrector's intention :
// So you can easily change the filename
import processing.video.*;
final String FILENAME = "FullPathToTheVideo";
Capture cam;

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
TwoDThreeD converter;

// Thresholding constants
int MIN_COLOR = 80, MAX_COLOR = 130;
int MIN_BRIGHT = 30, MAX_BRIGHT = 170;
int MIN_SATURATION = 75, MAX_SATURATION = 255;
int BINARY_THRESHOLD = 35;

// Hough
int NEIGHBOURHOOD = 20; // size of the region we search for a local maximum
int MIN_VOTE = 140;     // only search around lines with more that this amount of votes
// Area
int MIN_AREA = 15000, MAX_AREA = 150000;

// Main processing methods
void settings() {
  size(640, 480);
  trigo = new TrigonometricAccelerator(phiDim, discretizationStepsR, discretizationStepsPhi);
  converter = new TwoDThreeD(640, 480);
}

void setup() {
  String[] cameras = Capture.list();
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
  }
}

void draw() {
  if (cam.available() == true) {
    cam.read();
    println("read");
  }
    PImage boardImg = cam.get();
    image(boardImg, 0, 0);
  
    PImage colorFilter = colorFilter(MIN_COLOR, MAX_COLOR, boardImg); // Green : [80, 140]
    PImage brightnessFilter = brightnessFilter(MIN_BRIGHT, MAX_BRIGHT, colorFilter); //30 lowerbound board4 ||170 upper bound board2
    PImage saturationFilter = saturationFilter(MIN_SATURATION, MAX_SATURATION, brightnessFilter); // 65 lowerbound board4 || 255 upper bound forall
  
    PImage gaussian2 = convolute(gaussianKernel, saturationFilter);
    PImage binaryFilter = binaryFilter(BINARY_THRESHOLD, gaussian2);
  
    PImage sobel = sobel(binaryFilter);
  
    hough = new Hough(sobel, 6);
    QuadGraph graph = new QuadGraph(hough.lines, boardImg.width, boardImg.height);
    graph.findCycles();
  
    graph.displayBestQuad(hough.lines, boardImg.width);
    graph.displayRotation(hough.lines, converter);
}
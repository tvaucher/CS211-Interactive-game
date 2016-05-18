// To the corrector's intention :
// So you can easily change the filename
final String FILENAME = "board1.jpg";

// Main constants
final float[][] gaussianKernel = {
  {9, 12, 9}, 
  {12, 15, 12}, 
  {9, 12, 9}};
final float discretizationStepsPhi = 0.06f;
final float discretizationStepsR = 2.5f;
final int phiDim = (int) (Math.PI / discretizationStepsPhi);
TrigonometricAccelerator trigo;
Hough hough;

// Thresholding constants
int MIN_COLOR = 80, MAX_COLOR = 140;
int MIN_BRIGHT = 30, MAX_BRIGHT = 170;
int MIN_SATURATION = 75, MAX_SATURATION = 255;
int BINARY_THRESHOLD = 35;

// Hough
int NEIGHBOURHOOD = 10; // size of the region we search for a local maximum
int MIN_VOTE = 150;     // only search around lines with more that this amount of votes
// Area
int MIN_AREA = 70000, MAX_AREA = 350000;

// Main processing methods
void settings() {
  size(1760, 480); // Resize img and sobel : 640x480, hough transform : 480x480
                   // In order to fit on a 1920x1080 screen
  trigo = new TrigonometricAccelerator(phiDim, discretizationStepsR, discretizationStepsPhi);
}

void setup() {
  PImage boardImg = loadImage(FILENAME);
  boardImg.resize(640, 480);
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
  
  PImage houghImage = hough.getHoughImage();
  image(houghImage, 640, 0);
  image(sobel, 1120, 0);
  noLoop();
}
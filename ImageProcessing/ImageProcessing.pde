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
TrigonometricAccelerator trigoVal;
Hough hough;

// Main processing methods
void settings() {
  size(1760, 480); // Resize img and sobel : 640x480, hough transform : 480x480
}

void setup() {
  PImage boardImg = loadImage(FILENAME);
  boardImg.resize(640, 480);
  image(boardImg, 0, 0);
  
  PImage colorFilter = colorFilter(80, 140, boardImg); // Green : [80, 140]
  PImage brightnessFilter = brightnessFilter(30, 170, colorFilter); //30 lowerbound board4 ||170 upper bound board2
  PImage saturationFilter = saturationFilter(75, 255, brightnessFilter); // 65 lowerbound board4 || 255 upper bound forall

  PImage gaussian2 = convolute(gaussianKernel, saturationFilter);
  PImage binaryFilter = binaryFilter(35, gaussian2);

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
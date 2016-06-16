// Main constants
final float[][] gaussianKernel = {
  {9, 12, 9}, 
  {12, 15, 12}, 
  {9, 12, 9}};
final float discretizationStepsPhi = 0.02f;
final float discretizationStepsR = 2.5f;
final int phiDim = (int) (Math.PI / discretizationStepsPhi);
TrigonometricAccelerator trigo = new TrigonometricAccelerator(phiDim, discretizationStepsR, discretizationStepsPhi);
TwoDThreeD converter = new TwoDThreeD(MOVIE_WIDTH, MOVIE_HEIGHT);

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

public class ImageProcessing {
  public ImageProcessing() {
  }
  
  public PVector rotation(PImage boardImg) {
    PImage colorFilter = colorFilter(MIN_COLOR, MAX_COLOR, boardImg); // Green : [80, 140]
    PImage brightnessFilter = brightnessFilter(MIN_BRIGHT, MAX_BRIGHT, colorFilter); //30 lowerbound board4 ||170 upper bound board2
    PImage saturationFilter = saturationFilter(MIN_SATURATION, MAX_SATURATION, brightnessFilter); // 65 lowerbound board4 || 255 upper bound forall

    PImage gaussian2 = convolute(gaussianKernel, saturationFilter);
    PImage binaryFilter = binaryFilter(BINARY_THRESHOLD, gaussian2);

    PImage sobel = sobel(binaryFilter);

    Hough hough = new Hough(sobel, 6);
    QuadGraph graph = new QuadGraph(hough.lines, boardImg.width, boardImg.height);
    graph.findCycles();
    
    return graph.getRotation(hough.lines, converter);
  }
  
  public void displayCam(PImage img) {
    if (img.width != MOVIE_WIDTH && img.height != MOVIE_HEIGHT) {
      return;
    }
    img.resize(img.width/4, img.height/4);
    image(img, 0, 0);
  }
}
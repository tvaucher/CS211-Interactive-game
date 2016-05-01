

PImage img;
int threshold = 128;
PImage testImage;

float[][] kernel = { { 0, 0, 0 },
{ -1, 1, 0 },
{ 0, 0, 0 }};


float[][] kernel2 = { { 0, 0, 0 },
{ 0, 2, 0 },
{ 0, 0, 0 }};

float[][] gaussianKernel = {{9,12,9},
                        {12,15,12},
                        {9,12,9}};
                        

void settings() {
  size(800, 600);
}
void setup() {
  img = loadImage("board1.jpg");
  testImage = createImage(width,height,RGB);
  noLoop();
}
void draw() {
  /*positiveFilter();
  negativeFilter();
  image(result, 0, 0);*/
  //image(convolute(img,gaussianKernel),0,0);
  image(sobel(img),0,0); 
}

PImage sobel(PImage img) {
  float[][] hKernel = { { 0, 1, 0 },
                        { 0, 0, 0 },
                        { 0, -1, 0 } };
  float[][] vKernel = { { 0, 0, 0 },
                      { 1, 0, -1 },
                      { 0, 0, 0 } };
  PImage result = createImage(img.width, img.height, ALPHA);
  // clear the image
  for (int i = 0; i < img.width * img.height; i++) {
     result.pixels[i] = color(0);
  }
  float max=0;
  float[] buffer = new float[img.width * img.height];
  
  // *************************************
  for(int i=1 ; i<img.width-1;i++){
    for(int j=1;j<img.height-1;j++){
      int sum_h = 0;
      int sum_v = 0;
      
      for(int e = 0 ; e < 3; e++){
        for(int f = 0; f < 3 ; f++){
          sum_h += hKernel[e][f]*brightness(img.get(i-1+e,j-1+f));
          sum_v += vKernel[e][f]*brightness(img.get(i-1+e,j-1+f));
      
        }
      }
      float sum = sqrt(pow(sum_h,2)+pow(sum_v,2));
      if(sum>max){
        max=sum;
      }
      buffer[j*img.width+i] = sum;
    } 
  }
  // *************************************
  for (int y = 2; y < img.height - 2; y++) { // Skip top and bottom edges
    for (int x = 2; x < img.width - 2; x++) { // Skip left and right
      if (buffer[y * img.width + x] > (int)(max * 0.3f)) { // 30% of the max
        result.pixels[y * img.width + x] = color(255);
      } else {
        result.pixels[y * img.width + x] = color(0);
      }
    }
  }
  return result;
}
PImage convolute(PImage img , float[][] kernel) {


  int heightK = kernel.length;
  int widthK = kernel[0].length;
  // create a greyscale image (type: ALPHA) for output
  PImage result = createImage(img.width, img.height, ALPHA);
  
  int halfOfKernel = widthK/2;

  for(int i=1 ; i<img.width-1;i++){
    for(int j=1;j<img.height-1;j++){
      float valueNew = 0.0;
      float weight=0.0;
      for(int e = 0 ; e < heightK; e++){
        for(int f = 0; f <widthK ; f++){
          valueNew += kernel[e][f]*brightness(img.get(i-halfOfKernel+e,j-halfOfKernel+f));
          weight+=kernel[e][f];
        }
      }
      if(weight == 0){
        weight=1;
      }
      result.pixels[twoToOneCoord(i,j,img.width)] = color(valueNew/weight);
    } 
  }
  return result;
}
int twoToOneCoord(int x, int y, int width){
  return y*width+x;
}
void positiveFilter(){
  for(int i = 0; i < img.width * img.height; i++) {
    if(brightness(img.pixels[i])<threshold){
      testImage.pixels[i] = color(0);
    }
    else{
      testImage.pixels[i] = color(255);
    }
  }
}
void negativeFilter(){
  for(int i = 0; i < img.width * img.height; i++) {
    if(brightness(img.pixels[i])<threshold){
      testImage.pixels[i] = color(255);
    }
    else{
      testImage.pixels[i] = color(0);
    }
  }
}
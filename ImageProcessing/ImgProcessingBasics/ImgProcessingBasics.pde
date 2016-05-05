PImage img;

float[][] kernel = { { 0, 0, 0 },
{ -1, 0, 1 },
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
 //PImage img = createImage(width,height,RGB);
  img = loadImage("board1.jpg");
  
  //noLoop();
}
void draw() {

  PImage filtered3 = colorFilter(70,140, img);
  PImage filtered = brightnessFilter(30,147,filtered3);
  PImage filtered2 = saturationFilter(87,255,filtered);
  
  PImage gaussian1 = convolute(gaussianKernel,filtered2);
  PImage binaried = binaryFilter(70,14,gaussian1);
  PImage sobel1 = sobel(binaried);
  image(sobel1,0,0);
}

PImage sobel(PImage image) {
  float[][] hKernel = { { 0, 1, 0 },
                        { 0, 0, 0 },
                        { 0, -1, 0 } };
  float[][] vKernel = { { 0, 0, 0 },
                      { 1, 0, -1 },
                      { 0, 0, 0 } };
  loadPixels();
  PImage result = createImage(image.width, image.height, ALPHA);
  // clear the image
  for (int i = 0; i < image.width * image.height; i++) {
     result.pixels[i] = color(0);
  }
  float max=0;
  float[] buffer = new float[image.width * image.height];
  
  // *************************************
  for(int i=1 ; i<image.width-1;i++){
    for(int j=1;j<image.height-1;j++){
      int sum_h = 0;
      int sum_v = 0;
      
      for(int e = 0 ; e < 3; e++){
        for(int f = 0; f < 3 ; f++){
          sum_h += hKernel[e][f]*image.get(i-1+e,j-1+f);
          sum_v += vKernel[e][f]*image.get(i-1+e,j-1+f);
      
        }
      }
      if(sum_h>max) max=sum_h;
      if(sum_v>max) max=sum_v;
      
      float sum = sqrt(pow(sum_h,2)+pow(sum_v,2));
      
      buffer[j*image.width+i] = sum;
      if (buffer[j * image.width + i] > (int)(max * 0.3f)) { // 30% of the max
        result.pixels[j * image.width + i] = color(255);
      } else {
        result.pixels[j * image.width + i] = color(0);
      }
    } 
  }
  updatePixels();
  return result;
}

//with RGB.
PImage convolute(float[][] kernel, PImage image) {

  loadPixels();
  int heightK = kernel.length;
  int widthK = kernel[0].length;
  // create a greyscale image (type: ALPHA) for output
  PImage result = createImage(image.width, image.height, ALPHA);
  
  int halfOfKernel = widthK/2;

  for(int i=1 ; i<image.width-1;i++){
    for(int j=1;j<image.height-1;j++){
      //float valueNew = 0.0;
      float r = 0;
      float g = 0;
      float b = 0;
      float weight=0.0;
      for(int e = 0 ; e < heightK; e++){
        for(int f = 0; f <widthK ; f++){
          r+= kernel[e][f]*red((image.get(i-halfOfKernel+e,j-halfOfKernel+f)));
          g+= kernel[e][f]*green((image.get(i-halfOfKernel+e,j-halfOfKernel+f)));
          b+= kernel[e][f]*blue((image.get(i-halfOfKernel+e,j-halfOfKernel+f)));
          //valueNew += kernel[e][f]*image.get(i-halfOfKernel+e,j-halfOfKernel+f);
          weight+=kernel[e][f];
        }
      }
      if(weight == 0){
        weight=1;
      }
     // result.set(i,j,color(valueNew/weight)) ;
     result.set(i,j,color(r/weight, g/weight, b/weight));
    } 
  }
  updatePixels();
  return result;
}
PImage binaryFilter(int min, int max, PImage image){
  loadPixels();
  PImage result = createImage(image.width,image.height,RGB);
  for(int i = 0; i < image.width * image.height; i++) {
    if(hue(image.pixels[i])>min && hue(image.pixels[i])<max){
      result.pixels[i] = color(255);
    }
    else{
      result.pixels[i] = color(0);
    }
  }
  updatePixels();
  return result;
}

PImage brightnessFilter(int min, int max, PImage image){
  loadPixels();
  PImage result = createImage(image.width,image.height,RGB);
  for(int i = 0; i < image.width * image.height; i++) {
    if(brightness(image.pixels[i])>min && brightness(image.pixels[i])<max){
      result.pixels[i] = image.pixels[i];
    }
    else{
      result.pixels[i] = color(0);
    }
  }
  updatePixels();
  return result;
}
PImage saturationFilter(int min, int max, PImage image){
  loadPixels();
  PImage result = createImage(image.width,image.height,RGB);
  for(int i = 0; i < image.width * image.height; i++) {
    if(saturation(image.pixels[i])>min && saturation(image.pixels[i])<max){
      result.pixels[i] = image.pixels[i];
    }
    else{
      result.pixels[i] = color(0);
    }
  }
  updatePixels();
  return result;
}
PImage colorFilter(int min, int max, PImage image){
  loadPixels();
  PImage result = createImage(image.width,image.height,RGB);
  for(int i = 0; i < image.width * image.height; i++) {
    if(hue(image.pixels[i])>min && hue(image.pixels[i])<max){
      result.pixels[i] = image.pixels[i];
    }
    else{
      result.pixels[i] = color(0);
    }
  }
  updatePixels();
  return result;
}
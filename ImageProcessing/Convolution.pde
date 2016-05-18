PImage sobel(PImage image) {
  float[][] hKernel = { 
    { 0, 1, 0 }, 
    { 0, 0, 0 }, 
    { 0, -1, 0 } };

  float[][] vKernel = { 
    { 0, 0, 0 }, 
    { 1, 0, -1 }, 
    { 0, 0, 0 } };

  loadPixels();
  PImage result = createImage(image.width, image.height, ALPHA);
  // clear the image
  for (int i = 0; i < image.width * image.height; i++) {
    result.pixels[i] = color(0);
  }
  float max = 0;
  float[] buffer = new float[image.width * image.height];

  // *************************************
  for (int i=1; i<image.width-1; i++) {
    for (int j=1; j<image.height-1; j++) {
      float sum_h = 0;
      float sum_v = 0;

      for (int e = 0; e < 3; e++) {
        for (int f = 0; f < 3; f++) {
          float c = brightness(image.get(i-1+e, j-1+f));
          sum_h += hKernel[e][f]*c;
          sum_v += vKernel[e][f]*c;
        }
      }
      
      float sum = sum_h*sum_h + sum_v*sum_v; //store squared version to save compute time
      if (sum > max) max = sum;
      
      buffer[j*image.width+i] = sum;
    }
  }
  
  float threshold = max * 0.09f; // 0.3^2 30% of the max
  println(threshold + " " + max + " " + 255*255*2);
  for (int y = 1; y < image.height - 1; y++) { // Skip top and bottom edges
    for (int x = 1; x < image.width - 1; x++) { // Skip left and right
      if (buffer[y * image.width + x] >= threshold) { 
        result.pixels[y * image.width + x] = color(255);
      }
      else {
        result.pixels[y * image.width + x] = color(0);
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

  for (int i=1; i<image.width-1; i++) {
    for (int j=1; j<image.height-1; j++) {
      //float valueNew = 0.0;
      float r = 0;
      float g = 0;
      float b = 0;
      float weight=0.0;
      for (int e = 0; e < heightK; e++) {
        for (int f = 0; f <widthK; f++) {
          color c = image.get(i-halfOfKernel+e, j-halfOfKernel+f);
          r+= kernel[e][f]*red(c);
          g+= kernel[e][f]*green(c);
          b+= kernel[e][f]*blue(c);
          weight+=kernel[e][f];
        }
      }
      if (weight == 0) {
        weight=1;
      }
      result.set(i, j, color(r/weight, g/weight, b/weight));
    }
  }
  updatePixels();
  return result;
}
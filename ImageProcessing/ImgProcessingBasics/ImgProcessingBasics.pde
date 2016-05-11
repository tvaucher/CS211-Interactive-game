import processing.video.*;
import java.util.Collections;
Capture cam;
PImage img;
float[][] gaussianKernel = {{9, 12, 9}, 
  {12, 15, 12}, 
  {9, 12, 9}};
float discretizationStepsPhi = 0.06f;
float discretizationStepsR = 2.5f;
TrigonometricAccelerator trigoVal;



void settings() {
  size(800, 600);
}
void setup() {
  
  
  //img = loadImage("board4.jpg");
  
  //------FOR WEBCAM--------
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
   int phiDim = (int) (Math.PI / discretizationStepsPhi);
   trigoVal = new TrigonometricAccelerator(phiDim, 
                           discretizationStepsR,  discretizationStepsPhi);
}
void draw() {  
  //------------CAM----------
  if (cam.available() == true) {
   cam.read();
   }
  img = cam.get();
  PImage filtered3 = colorFilter(70, 140, img);
  PImage filtered = brightnessFilter(30, 147, filtered3);
  PImage filtered2 = saturationFilter(87, 255, filtered);

  PImage gaussian1 = convolute(gaussianKernel, filtered2);
  PImage binaried = binaryFilter(70, 140, gaussian1);
  PImage sobel1 = sobel(binaried);

  image(img, 0, 0);
  hough(sobel1, 4);
}

//-----HOUGH VERSION WEEK10-----
ArrayList<PVector> hough(PImage edgeImg, int nLines) {
  // dimensions of the accumulator
  int phiDim = (int) (Math.PI / discretizationStepsPhi);
  int rDim = (int) (((edgeImg.width + edgeImg.height) * 2 + 1) / discretizationStepsR);
  // our accumulator (with a 1 pix margin around)
  int[] accumulator = new int[(phiDim + 2) * (rDim + 2)];
  // Fill the accumulator: on edge points (ie, white pixels of the edge
  // image), store all possible (r, phi) pairs describing lines going
  // through the point.
  for (int y = 0; y < edgeImg.height; y++) {
    for (int x = 0; x < edgeImg.width; x++) {
      // Are we on an edge?
      if (brightness(edgeImg.pixels[y * edgeImg.width + x]) != 0) {
        for (int phiTab=0; phiTab< phiDim; phiTab++) {
          float phi = phiTab*discretizationStepsPhi;
          float r = (float)(Math.cos(phi)*x + y*Math.sin(phi));
          int rIndex = Math.round(r/discretizationStepsR);

          int myIndex = (rDim+2) + phiTab*(rDim+2) + 1 + rIndex + (rDim-1)/2; //maybe +2 instead of +1. 
          accumulator[myIndex] ++;
        }
      }
    }
  }

  //Continue code here
  ArrayList<Integer> bestCandidates = new ArrayList<Integer>();
  // size of the region we search for a local maximum
  int neighbourhood = 10;
  // only search around lines with more that this amount of votes
  // (to be adapted to your image)
  int minVotes = 200;
  for (int accR = 0; accR < rDim; accR++) {
    for (int accPhi = 0; accPhi < phiDim; accPhi++) {
      // compute current index in the accumulator
      int idx = (accPhi + 1) * (rDim + 2) + accR + 1;
      if (accumulator[idx] > minVotes) {
        boolean bestCandidate=true;
        // iterate over the neighbourhood
        for (int dPhi=-neighbourhood/2; dPhi < neighbourhood/2+1; dPhi++) {
          // check we are not outside the image
          if ( accPhi+dPhi < 0 || accPhi+dPhi >= phiDim) continue;
          for (int dR=-neighbourhood/2; dR < neighbourhood/2 +1; dR++) {
            // check we are not outside the image
            if (accR+dR < 0 || accR+dR >= rDim) continue;
            int neighbourIdx = (accPhi + dPhi + 1) * (rDim + 2) + accR + dR + 1;
            if (accumulator[idx] < accumulator[neighbourIdx]) {
              // the current idx is not a local maximum!
              bestCandidate=false;
              break;
            }
          }
          if (!bestCandidate) break;
        }
        if (bestCandidate) {
          // the current idx *is* a local maximum
          bestCandidates.add(idx);
        }
      }
    }
  }
  Collections.sort(bestCandidates, new HoughComparator(accumulator));

  ArrayList<PVector> pairs = new ArrayList<PVector>();
  for (int j = 0; j < Math.min(nLines, bestCandidates.size()); j++) {
    int idx = bestCandidates.get(j);
    // first, compute back the (r, phi) polar coordinates:
    int accPhi = (int) (idx / (rDim + 2)) - 1;
    int accR = idx - (accPhi + 1) * (rDim + 2) - 1;
    float r = (accR - (rDim - 1) * 0.5f) * discretizationStepsR;
    float phi = accPhi * discretizationStepsPhi;
    
    PVector vect = new PVector(r,phi);
    pairs.add(vect);
    
    
    // Cartesian equation of a line: y = ax + b
    // in polar, y = (-cos(phi)/sin(phi))x + (r/sin(phi))
    // => y = 0 : x = r / cos(phi)
    // => x = 0 : y = r / sin(phi)
    // compute the intersection of this line with the 4 borders of
    // the image
    int x0 = 0;
    int y0 = (int) (r / sin(phi));
    int x1 = (int) (r / cos(phi));
    int y1 = 0;
    int x2 = edgeImg.width;
    int y2 = (int) (-cos(phi) / sin(phi) * x2 + r / sin(phi));
    int y3 = edgeImg.width;
    int x3 = (int) (-(y3 - r / sin(phi)) * (sin(phi) / cos(phi)));
    // Finally, plot the lines
    stroke(204, 102, 0);
    if (y0 > 0) {
      if (x1 > 0)
        line(x0, y0, x1, y1);
      else if (y2 > 0)
        line(x0, y0, x2, y2);
      else
        line(x0, y0, x3, y3);
    } else {
      if (x1 > 0) {
        if (y2 > 0)
          line(x1, y1, x2, y2);
        else
          line(x1, y1, x3, y3);
      } else
        line(x2, y2, x3, y3);
    }
  }
  return getIntersections(pairs);
}

ArrayList<PVector> getIntersections(ArrayList<PVector> lines) {
  ArrayList<PVector> intersections = new ArrayList<PVector>();
  for (int i = 0; i < lines.size() - 1; i++) {
    PVector pair1 = lines.get(i);
    for (int j = i + 1; j < lines.size(); j++) {
      PVector pair2 = lines.get(j);
      // compute the intersection and add it to ’intersections’
      float r2 = pair2.x;
      float phi2 = pair2.y;
      float r1 = pair1.x;
      float phi1 = pair1.y;
      
      double d = Math.cos(phi2)*Math.sin(phi1) - Math.cos(phi1)*Math.sin(phi2);
      
      int x = (int)((r2*Math.sin(phi1) - r1*Math.sin(phi2))/d);
      int y = (int)((-r2*Math.cos(phi1) + r1*Math.cos(phi2))/d);
      // draw the intersection
      fill(255, 128, 0);
      ellipse(x, y, 10, 10);
    }
  }
  return intersections;
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
  for (int i=1; i<image.width-1; i++) {
    for (int j=1; j<image.height-1; j++) {
      int sum_h = 0;
      int sum_v = 0;

      for (int e = 0; e < 3; e++) {
        for (int f = 0; f < 3; f++) {
          sum_h += hKernel[e][f]*image.get(i-1+e, j-1+f);
          sum_v += vKernel[e][f]*image.get(i-1+e, j-1+f);
        }
      }
      if (sum_h>max) max=sum_h;
      if (sum_v>max) max=sum_v;

      float sum = sqrt(pow(sum_h, 2)+pow(sum_v, 2));

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

  for (int i=1; i<image.width-1; i++) {
    for (int j=1; j<image.height-1; j++) {
      //float valueNew = 0.0;
      float r = 0;
      float g = 0;
      float b = 0;
      float weight=0.0;
      for (int e = 0; e < heightK; e++) {
        for (int f = 0; f <widthK; f++) {
          r+= kernel[e][f]*red((image.get(i-halfOfKernel+e, j-halfOfKernel+f)));
          g+= kernel[e][f]*green((image.get(i-halfOfKernel+e, j-halfOfKernel+f)));
          b+= kernel[e][f]*blue((image.get(i-halfOfKernel+e, j-halfOfKernel+f)));
          //valueNew += kernel[e][f]*image.get(i-halfOfKernel+e,j-halfOfKernel+f);
          weight+=kernel[e][f];
        }
      }
      if (weight == 0) {
        weight=1;
      }
      // result.set(i,j,color(valueNew/weight)) ;
      result.set(i, j, color(r/weight, g/weight, b/weight));
    }
  }
  updatePixels();
  return result;
}
PImage binaryFilter(int min, int max, PImage image) {
  loadPixels();
  PImage result = createImage(image.width, image.height, RGB);
  for (int i = 0; i < image.width * image.height; i++) {
    if (hue(image.pixels[i])>min && hue(image.pixels[i])<max) {
      result.pixels[i] = color(255);
    } else {
      result.pixels[i] = color(0);
    }
  }
  updatePixels();
  return result;
}

PImage brightnessFilter(int min, int max, PImage image) {
  loadPixels();
  PImage result = createImage(image.width, image.height, RGB);
  for (int i = 0; i < image.width * image.height; i++) {
    if (brightness(image.pixels[i])>min && brightness(image.pixels[i])<max) {
      result.pixels[i] = image.pixels[i];
    } else {
      result.pixels[i] = color(0);
    }
  }
  updatePixels();
  return result;
}
PImage saturationFilter(int min, int max, PImage image) {
  loadPixels();
  PImage result = createImage(image.width, image.height, RGB);
  for (int i = 0; i < image.width * image.height; i++) {
    if (saturation(image.pixels[i])>min && saturation(image.pixels[i])<max) {
      result.pixels[i] = image.pixels[i];
    } else {
      result.pixels[i] = color(0);
    }
  }
  updatePixels();
  return result;
}
PImage colorFilter(int min, int max, PImage image) {
  loadPixels();
  PImage result = createImage(image.width, image.height, RGB);
  for (int i = 0; i < image.width * image.height; i++) {
    if (hue(image.pixels[i])>min && hue(image.pixels[i])<max) {
      result.pixels[i] = image.pixels[i];
    } else {
      result.pixels[i] = color(0);
    }
  }
  updatePixels();
  return result;
}
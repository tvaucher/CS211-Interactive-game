PImage binaryFilter(int threshold, PImage image) {
  loadPixels();
  PImage result = createImage(image.width, image.height, RGB);
  for (int i = 0; i < image.width * image.height; i++) {
    if (brightness(image.pixels[i]) >= threshold) {
      result.pixels[i] = color(255);
    } else {
      result.pixels[i] = color(0);
    }
  }
  updatePixels();
  return result;
}

PImage reverseBinaryFilter(int threshold, PImage image) {
  loadPixels();
  PImage result = createImage(image.width, image.height, RGB);
  for (int i = 0; i < image.width * image.height; i++) {
    if (brightness(image.pixels[i]) < threshold) {
      result.pixels[i] = color(255);
    } else {
      result.pixels[i] = color(0);
    }
  }
  updatePixels();
  return result;
}


PImage brightnessColorAndSaturationFilter(int minBright, int maxBright, int minSaturation, int maxSaturation, 
                                        int minColor, int maxColor, PImage image) {
  loadPixels();
  PImage result = createImage(image.width, image.height, RGB);
  for (int i = 0; i < image.width * image.height; i++) {
    if ((brightness(image.pixels[i]) >= minBright && brightness(image.pixels[i]) <= maxBright) && 
        (saturation(image.pixels[i]) >= minSaturation && saturation(image.pixels[i]) <= maxSaturation) &&
        (hue(image.pixels[i]) >= minColor && hue(image.pixels[i]) <= maxColor)){
        result.pixels[i] = image.pixels[i];
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
    if (brightness(image.pixels[i]) >= min && brightness(image.pixels[i]) <= max) {
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
    if (saturation(image.pixels[i]) >= min && saturation(image.pixels[i]) <= max) {
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
    if (hue(image.pixels[i]) >= min && hue(image.pixels[i]) <= max) {
      result.pixels[i] = image.pixels[i];
    } else {
      result.pixels[i] = color(0);
    }
  }
  updatePixels();
  return result;
}
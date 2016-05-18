public class Hough {
  final int phiDim;
  final int rDim;
  int[] accumulator;
  ArrayList<PVector> lines;

  Hough(PImage edgeImg, int nLines) {
    phiDim = (int) (Math.PI / discretizationStepsPhi);
    rDim = (int) (((edgeImg.width + edgeImg.height) * 2 + 1) / discretizationStepsR);
    // our accumulator (with a 1 pix margin around)
    accumulator = new int[(phiDim + 2) * (rDim + 2)];

    // Fill the accumulator: on edge points (ie, white pixels of the edge
    // image), store all possible (r, phi) pairs describing lines going
    // through the point.
    for (int y = 0; y < edgeImg.height; y++) {
      for (int x = 0; x < edgeImg.width; x++) {
        // Are we on an edge?
        if (brightness(edgeImg.pixels[y * edgeImg.width + x]) != 0) {
          for (int phiTab = 0; phiTab < phiDim; phiTab++) {
            float phi = phiTab * discretizationStepsPhi;
            float r = (float)(Math.cos(phi)*x + y*Math.sin(phi));
            int rIndex = Math.round(r/discretizationStepsR);

            int index = (phiTab + 1) * (rDim+2) + (rIndex + 1) + (rDim-1)/2;
            accumulator[index] ++;
          }
        }
      }
    }

    lines = getLines(edgeImg, nLines);
  }

  PImage getHoughImage() {
    PImage houghImg = createImage(rDim + 2, phiDim + 2, ALPHA);
    for (int i = 0; i < accumulator.length; i++) {
      houghImg.pixels[i] = color(min(255, accumulator[i]));
    }

    houghImg.resize(480, 480);
    houghImg.updatePixels();

    return houghImg;
  }

  private ArrayList<PVector> getLines(PImage edgeImg, int nLines) {
    ArrayList<Integer> bestCandidates = new ArrayList<Integer>();
    // size of the region we search for a local maximum
    int neighbourhood = 10;
    // only search around lines with more that this amount of votes
    // (to be adapted to your image)
    int minVotes = 150; //usually 200
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

      PVector vect = new PVector(r, phi);
      pairs.add(vect);
    }

    return pairs;
  }
}
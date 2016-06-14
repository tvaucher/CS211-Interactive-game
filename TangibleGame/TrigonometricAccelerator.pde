class TrigonometricAccelerator {
  float[] tabSin;
  float[] tabCos;
  public TrigonometricAccelerator(int phiDim, float discretizationStepsR, float discretizationStepsPhi) {
    tabSin = new float[phiDim];
    tabCos = new float[phiDim];
    float ang = 0;
    float inverseR = 1.f / discretizationStepsR;
    
    for (int accPhi = 0; accPhi < phiDim; ang += discretizationStepsPhi, accPhi++) {
      // we can also pre-multiply by (1/discretizationStepsR) since we need it in the Hough loop
      tabSin[accPhi] = (float) (Math.sin(ang) * inverseR);
      tabCos[accPhi] = (float) (Math.cos(ang) * inverseR);
    }
  }
  public float getCos(int phiIndex) {
    return tabCos[phiIndex];
  }
  public float getSin(int phiIndex) {
    return tabSin[phiIndex];
  }
}
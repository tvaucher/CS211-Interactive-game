class TrigonometricAccelerator{
  float[] tabSin;
  float[] tabCos;
  public TrigonometricAccelerator(int phiDim, float discretizationStepsR, float discretizationStepsPhi){
    tabSin = new float[phiDim];
    tabCos = new float[phiDim];
    float ang = 0;
    
    for (int accPhi = 0; accPhi < phiDim; ang += discretizationStepsPhi, accPhi++) {
      // we can also pre-multiply by (1/discretizationStepsR) since we need it in the Hough loop
      tabSin[accPhi] = (float) (Math.sin(ang));
      tabCos[accPhi] = (float) (Math.cos(ang));
    }
  }
  public float getCos(float phi){
    return tabCos[(int)(phi/discretizationStepsPhi)];
  }
  public float getSin(float phi){
    return tabSin[(int)(phi/discretizationStepsPhi)];
  }
}
  
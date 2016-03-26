class My2DPoint {
  float x;
  float y;
  My2DPoint(float x, float y) {
    this.x = x;
    this.y = y;
  }
}

class My3DPoint {
  float x;
  float y;
  float z;
  My3DPoint(float x, float y, float z) {
    this.x = x;
    this.y = y;
    this.z = z;
  }

  @Override
  public String toString() {
    return (x + ". " + y + ", " + z);
  }
}

My2DPoint projectPoint(My3DPoint eye, My3DPoint p) {
  float w  = (-p.z/eye.z + 1);
  float xP = (p.x - eye.x) / w;
  float yP = (p.y - eye.y) / w;
  return new My2DPoint(xP, yP);
}

My2DBox projectBox (My3DPoint eye, My3DBox box) {
  My2DPoint[] s = new My2DPoint[8];
  for (int i = 0; i < 8; ++i) {
    s[i] = projectPoint(eye, box.p[i]);
  }
  return new My2DBox(s);
}

class My2DBox {
  My2DPoint[] s;
  My2DBox(My2DPoint[] s) {
    this.s = s;
  }
  void render(boolean order) {
    strokeWeight(3);
    if (order) 
    print4to7();
    else print0to3();

    //SIDE
    stroke(0, 0, 255);
    betterLine(0, 4);
    betterLine(5, 1);    
    betterLine(7, 3);
    betterLine(2, 6);
    
    if (order) 
    print0to3();
    else print4to7();
  }

  private void betterLine(int from, int end) {
    line(s[from].x, s[from].y, s[end].x, s[end].y);
  }
  
  private void print0to3() {
    stroke(255, 0, 0);
    betterLine(0, 1);
    betterLine(0, 3);
    betterLine(2, 1);
    betterLine(2, 3);
    point((s[0].x + s[2].x)/2, (s[0].y + s[2].y)/2);
  }
  
  private void print4to7() {
    stroke(0, 255, 0);
    betterLine(5, 4);
    betterLine(7, 4);
    betterLine(5, 6);
    betterLine(7, 6);
    point((s[5].x + s[7].x)/2, (s[5].y + s[7].y)/2);
  }  
}

class My3DBox {
  My3DPoint[] p;
  My3DBox(My3DPoint origin, float dimX, float dimY, float dimZ) {
    float x = origin.x;
    float y = origin.y;
    float z = origin.z;
    this.p = new My3DPoint[]{new My3DPoint(x, y+dimY, z+dimZ), 
      new My3DPoint(x, y, z+dimZ), 
      new My3DPoint(x+dimX, y, z+dimZ), 
      new My3DPoint(x+dimX, y+dimY, z+dimZ), 
      new My3DPoint(x, y+dimY, z), 
      origin, 
      new My3DPoint(x+dimX, y, z), 
      new My3DPoint(x+dimX, y+dimY, z)
    };
  }
  My3DBox(My3DPoint[] p) {
    this.p = p;
  }
}
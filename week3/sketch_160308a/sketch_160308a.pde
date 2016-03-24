void settings() {
  size(800, 600, P2D);
}
void setup () {
}
float scaleCoeff = 1.0;
float angleX =0.0;
float angleY =0.0;


void draw() {
  background(255, 255, 255);
  My3DPoint eye = new My3DPoint(0, 0, -5000);
  My3DPoint origin = new My3DPoint(200, 200, 0);
  My3DBox input3DBox = new My3DBox(origin, 100, 150, 300);
  

  
    //rotateX
  float[][] rotateX = rotateXMatrix(angleX);
  input3DBox = transformBox(input3DBox,rotateX);
  projectBox(eye, input3DBox).render();
  
   //rotateY
  float[][] rotateY = rotateYMatrix(angleY);
  input3DBox = transformBox(input3DBox,rotateY);
  projectBox(eye, input3DBox).render();
  
  //scale
  float[][] scale = scaleMatrix(scaleCoeff,scaleCoeff,scaleCoeff);
  input3DBox = transformBox(input3DBox,scale);
  projectBox(eye, input3DBox).render();
  


}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == DOWN) {
      angleX+=0.1;
    } else if (keyCode == UP) {
      angleX-=0.1;
    }
    else if (keyCode == LEFT) {
      angleY+=0.1;
    } 
    else if (keyCode == RIGHT) {
      angleY-=0.1;
    } 
  } 
    
}

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
}
My2DPoint projectPoint(My3DPoint eye, My3DPoint p) {
  float normalize = 1/(-p.z/eye.z + 1);
  return new My2DPoint(normalize*(p.x-eye.x), normalize*(p.y-eye.y));
}

My2DBox projectBox (My3DPoint eye, My3DBox box) {
  My2DPoint [] projectedPoints = new My2DPoint[8];
  for(int i=0;i<8;i++){
    projectedPoints[i]=projectPoint(eye, box.p[i]);
  }
  return new My2DBox(projectedPoints);
}

class My2DBox {
  My2DPoint[] s;
  My2DBox(My2DPoint[] s) {
    this.s = s;
  }
  void render(){
    line(s[0].x,s[0].y,s[1].x,s[1].y);
    line(s[0].x,s[0].y,s[3].x,s[3].y);
    line(s[0].x,s[0].y,s[4].x,s[4].y);
    line(s[1].x,s[1].y,s[2].x,s[2].y);
    line(s[1].x,s[1].y,s[5].x,s[5].y);
    line(s[2].x,s[2].y,s[3].x,s[3].y);
    line(s[2].x,s[2].y,s[6].x,s[6].y);
    line(s[3].x,s[3].y,s[7].x,s[7].y);
    line(s[4].x,s[4].y,s[5].x,s[5].y);
    line(s[4].x,s[4].y,s[7].x,s[7].y);
    line(s[5].x,s[5].y,s[6].x,s[6].y);
    line(s[6].x,s[6].y,s[7].x,s[7].y);
  }
}

class My3DBox {
  My3DPoint[] p;
  My3DBox(My3DPoint origin, float dimX, float dimY, float dimZ){
    float x = origin.x;
    float y = origin.y;
    float z = origin.z;
    this.p = new My3DPoint[]{
      new My3DPoint(x,y+dimY,z+dimZ),
      new My3DPoint(x,y,z+dimZ),
      new My3DPoint(x+dimX,y,z+dimZ),
      new My3DPoint(x+dimX,y+dimY,z+dimZ),
      new My3DPoint(x,y+dimY,z),
      origin,
      new My3DPoint(x+dimX,y,z),
      new My3DPoint(x+dimX,y+dimY,z)
    };
  }
  My3DBox(My3DPoint[] p) {
    this.p = p;
  }
}
float[] homogeneous3DPoint (My3DPoint p) {
  float[] result = {p.x, p.y, p.z , 1};
  return result;
}
float[][] rotateXMatrix(float angle) {
  return(new float[][] {{1, 0 , 0 , 0},
                      {0, cos(angle), sin(angle) , 0},
                      {0, -sin(angle) , cos(angle) , 0},
                      {0, 0 , 0 , 1}});
}
float[][] rotateYMatrix(float angle) {
  return(new float[][] {{cos(angle), 0, -sin(angle) , 0},
                        {0, 1 , 0 , 0},
                        {sin(angle), 0  , cos(angle) , 0},
                        {0, 0 , 0 , 1}});
}
float[][] rotateZMatrix(float angle) {
  return(new float[][] {{cos(angle), sin(angle) , 0 , 0},
                        {-sin(angle) , cos(angle)  , 0, 0},
                        {0, 0 , 1 , 0},
                        {0, 0 , 0 , 1}});
}
float[][] scaleMatrix(float x, float y, float z) {
  return(new float[][] {{x, 0 , 0 , 0},
                        {0, y , 0, 0},
                        {0, 0 , z , 0},
                        {0, 0 , 0 , 1}});
}
float[][] translationMatrix(float x, float y, float z) {
  return(new float[][] {{1, 0 , 0 , x},
                        {0 , 1  , 0, y},
                        {0, 0 , 1 , z},
                        {0, 0 , 0 , 1}});
}
float[] matrixProduct(float[][] a, float[] b) {
  float[] resultVector = new float[4];
  for(int i=0;i<4;i++){
    for(int j=0;j<4;j++){
      resultVector[i]+= a[i][j]*b[j];
    }
  }
  return resultVector;
}

My3DBox transformBox(My3DBox box, float[][] transformMatrix) {
  My3DPoint[] transformedPoints = new My3DPoint[8];
  for(int i=0;i<8;i++){
    My3DPoint pointOfBox = box.p[i];
    float[] transPoint =  matrixProduct(transformMatrix,homogeneous3DPoint(pointOfBox));
    transformedPoints[i] = euclidian3DPoint(transPoint);
  }
  return new My3DBox(transformedPoints);
}

My3DPoint euclidian3DPoint (float[] a) {
  My3DPoint result = new My3DPoint(a[0]/a[3], a[1]/a[3], a[2]/a[3]);
  return result;
}
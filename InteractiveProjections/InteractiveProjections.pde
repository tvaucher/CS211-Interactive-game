My3DPoint eye;
My3DPoint origin;
My3DBox input3DBox;

final float w = 100, h = 150, d = 200;
void settings() {
  size(1000, 1000, P2D);
}

void setup () {
  eye = new My3DPoint(0, 0, -5000);
  origin = new My3DPoint(-w/2, -h/2, -d/2);
}

void draw() {
  background(255, 255, 255);
  input3DBox = new My3DBox(origin, w, h, d);

  float[][][] transforms = {rotateXMatrix(rx), 
                            rotateYMatrix(ry),
                            scaleMatrix(scale, scale, scale), 
                            translationMatrix(width/2., height/2., 0) };
  for (float[][] t : transforms) {
    input3DBox = transformBox(input3DBox, t);
  } 
  projectBox(eye, input3DBox).render(input3DBox.p[0].z >= input3DBox.p[4].z);
}

float rx, ry, scale = 1;
final float delta = PI/16;

void keyPressed() {
  if (key == CODED) {
    switch(keyCode) {
    case DOWN : rx += delta; break;
    case UP   : rx -= delta; break;
    case LEFT : ry += delta; break;
    case RIGHT: ry -= delta; break;
    default   :
    }
    
    if (rx <= -TWO_PI || rx >= TWO_PI) rx = 0;
    if (ry <= -TWO_PI || ry >= TWO_PI) ry = 0;
  } //<>//
}

void mouseWheel(MouseEvent event) {
  scale -= event.getCount() * 2. / frameRate;
  if (scale < 0.1) scale = 0.1;
}
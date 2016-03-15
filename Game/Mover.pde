class Mover {
  private final float gravityConstant = 0.05;
  private final float normalForce = 1;
  private final float mu = 0.01;
  private final float frictionMagnitude = normalForce * mu;

  private PVector BallLocation;
  private PVector velocity;
  private PVector gravityForce;

  Mover() {
    BallLocation = new PVector(0, 0, 0);
    velocity = new PVector(0, 0, 0);
    gravityForce = new PVector(0, 0, 0);
  }

  void update() {
    gravityForce.x = sin(rz) * gravityConstant;
    gravityForce.z = -sin(rx) * gravityConstant;

    PVector friction = velocity.copy();
    friction.mult(-1);
    friction.normalize();
    friction.mult(frictionMagnitude);

    velocity.add(gravityForce).add(friction);
    BallLocation.add(velocity);
  }

  void checkEdges(MyBox m) {
    if (BallLocation.x > m.width/2.0) {
      BallLocation.x = m.width/2.0;
      velocity.x=-velocity.x;
    } else if (BallLocation.x < -m.width/2.0) {
      BallLocation.x = -m.width/2.0;
      velocity.x=-velocity.x;
    }
    if (BallLocation.z > m.length/2.0) {
      BallLocation.z = m.length/2.0;
      velocity.z=-velocity.z;
    } else if (BallLocation.z < -m.length/2.0) {
      BallLocation.z = -m.length/2.0;
      velocity.z=-velocity.z;
    }
  }

  void display(int radius, int height) {
    pushMatrix();
    translate(0, -(radius+height/2.0), 0);
    translate(BallLocation.x, BallLocation.y, BallLocation.z); //added code for gravity
    fill(150);
    sphere(radius);
    popMatrix();
  }
}
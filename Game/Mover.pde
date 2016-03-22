class Mover {
  private final float gravityConstant = 0.05;
  private final float normalForce = 1;
  private final float mu = 0.01;
  private final float frictionMagnitude = normalForce * mu;
  private final float collisionCoef = 0.7;

  private PVector location;
  private PVector velocity;
  private PVector gravityForce;
  private final float radius;

  Mover(float r) {
    location = new PVector(0, 0, 0);
    velocity = new PVector(0, 0, 0);
    gravityForce = new PVector(0, 0, 0);
    radius = r;
  }

  void update() {
    gravityForce.x = sin(rz) * gravityConstant;
    gravityForce.z = -sin(rx) * gravityConstant;

    PVector friction = velocity.copy();
    friction.mult(-1);
    friction.normalize();
    friction.mult(frictionMagnitude);

    velocity.add(gravityForce).add(friction);
    location.add(velocity);
  }

  void checkEdges(Box m) {
    if (location.x > m.width/2.0) {
      location.x = m.width/2.0;
      velocity.x = -velocity.x * collisionCoef;
    } 
    else if (location.x < -m.width/2.0) {
      location.x = -m.width/2.0;
      velocity.x = -velocity.x * collisionCoef;
    }
    if (location.z > m.length/2.0) {
      location.z = m.length/2.0;
      velocity.z = -velocity.z * collisionCoef;
    } 
    else if (location.z < -m.length/2.0) {
      location.z = -m.length/2.0;
      velocity.z = -velocity.z * collisionCoef;
    }
  }

  void display() {
    pushMatrix();
      translate(0, -radius, 0);
      translate(location.x, location.y, location.z); //added code for gravity
      fill(0, 255, 0);
      sphere(radius);
    popMatrix();
  }
}
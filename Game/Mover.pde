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

  //Add parameter to function update
  void update(ArrayList<Cylinder> cylArray) {
    gravityForce.x = sin(rz) * gravityConstant;
    gravityForce.z = -sin(rx) * gravityConstant;
    
    //******************************
    //Here change velocity if collision
    checkCylindersCollision(cylArray);
    
    PVector friction = velocity.copy();
    friction.mult(-1);
    friction.normalize();
    friction.mult(frictionMagnitude);

    velocity.add(gravityForce).add(friction);
    location.add(velocity);
  }
  
  //New method
  void checkCylindersCollision(ArrayList<Cylinder> cylArray) {

    for (Cylinder c : cylArray) {
      if (inOrBorderCylinder(c)) {
        //normal vector where it touches the cylinder
        PVector normal = new PVector(location.x - c.position.x, 
          location.y - c.position.y,
          location.z - c.position.z).normalize();

        //Calculate velocity after collision (formula of the template)
        velocity = velocity.sub(normal.mult(2*(velocity.dot(normal))));
      }
    }
  }


  //tells if the ball touchs the cylinder (the smaller or equal sign is
  //because the position is a float and could never be equal)
  boolean inOrBorderCylinder(Cylinder cyl) { 
    return location.dist(cyl.position) <= cyl.cylinderBaseSize + radius;
  }

  void checkEdges(Box m) {
    if (location.x > m.width/2.0) {
      location.x = m.width/2.0;
      velocity.x = -velocity.x * collisionCoef;
    } else if (location.x < -m.width/2.0) {
      location.x = -m.width/2.0;
      velocity.x = -velocity.x * collisionCoef;
    }
    if (location.z > m.length/2.0) {
      location.z = m.length/2.0;
      velocity.z = -velocity.z * collisionCoef;
    } else if (location.z < -m.length/2.0) {
      location.z = -m.length/2.0;
      velocity.z = -velocity.z * collisionCoef;
    }
  }

  void display() {
    pushMatrix();
      translate(0, -radius, 0); //move to center of the sphere plane
      translate(location.x, location.y, location.z); //added code for gravity
      fill(0, 255, 0);
      sphere(radius);
    popMatrix();
  }
}
class Mover {
  private final float gravityConstant = 0.06;
  private final float normalForce = 1;
  private final float mu = 0.015;
  private final float frictionMagnitude = normalForce * mu;
  private final float collisionCoef = 0.7;
  
  private PVector velocity;
  private PVector gravityForce;
  private Ball ball;
  
  Mover(Ball b) {
    velocity = new PVector(0, 0, 0);
    gravityForce = new PVector(0, 0, 0);
    ball = b;
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
    ball.position.add(velocity);
  }

  public void checkEdges(ArrayList<Cylinder> cylArray, Box m) {
    checkCylindersCollision(cylArray);

    if (ball.position.x > m.width/2.0) {
      ball.position.x = m.width/2.0;
      velocity.x = -velocity.x * collisionCoef;
    } else if (ball.position.x < -m.width/2.0) {
      ball.position.x = -m.width/2.0;
      velocity.x = -velocity.x * collisionCoef;
    }
    if (ball.position.z > m.length/2.0) {
      ball.position.z = m.length/2.0;
      velocity.z = -velocity.z * collisionCoef;
    } else if (ball.position.z < -m.length/2.0) {
      ball.position.z = -m.length/2.0;
      velocity.z = -velocity.z * collisionCoef;
    }
  }

  private void checkCylindersCollision(ArrayList<Cylinder> cylArray) {
    for (Cylinder c : cylArray) {
      if (inOrBorderCylinder(c)) {
        //normal vector where it touches the cylinder
        PVector normal = PVector.sub(ball.position, c.position).normalize();

        //Calculate velocity after collision (formula of the template)
        velocity = velocity.sub(PVector.mult(normal, 2*(velocity.dot(normal))));
        ball.position = PVector.add(c.position, normal.mult(ball.radius + c.radius));
      }
    }
  }

  private boolean inOrBorderCylinder(Cylinder cyl) {
    //tells if the ball touchs the cylinder (the smaller or equal sign is
    //because the position is a float and could never be equal)
    return ball.position.dist(cyl.position) <= cyl.radius + ball.radius;
  }
}
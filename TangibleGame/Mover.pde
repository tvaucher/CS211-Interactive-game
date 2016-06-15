/**
 * @brief Mover class which is responsible of moving a given ball based on 
 *        Newtonian physics and collision objects 
 * @author Simon Haefeli (246663)
 * @author Timoté Vaucher (246532)
 */
public class Mover {
  private final float gravityConstant = 0.15;
  private final float normalForce = 1;
  private final float mu = 0.015;
  private final float frictionMagnitude = normalForce * mu;
  private final float collisionCoef = 0.7;

  private PVector velocity;
  private PVector gravityForce;
  private Ball ball;

  /**
   * @brief Constructs a mover and attach a given ball to it.
   * @param b The ball that will be updated by the mover
   */
  public Mover(Ball b) {
    velocity = new PVector(0, 0, 0); //Default velocitiy
    gravityForce = new PVector(0, 0, 0); //Default gravity force
    ball = b;
  }

  /**
   * @brief Updates the ball location according to physics (gravity)
   */
  public void update() {
    gravityForce.x = sin(rz) * gravityConstant;
    gravityForce.z = -sin(rx) * gravityConstant;

    PVector friction = velocity.copy();
    friction.mult(-1);
    friction.normalize();
    friction.mult(frictionMagnitude);

    velocity.add(gravityForce).add(friction);
    ball.position.add(velocity);
  }

  /**
   * @brief Checks the collision between the ball and the cylinders and the plate border
   * @param cylArray The list of cylinders on the plate
   * @param m The plate object
   */
  public void checkEdges(ArrayList<Cylinder> cylArray, Box m, ScoreManager s) {
    checkCylindersCollision(cylArray, s);
    
    if (ball.position.x > m.width/2.0) {
      ball.position.x = m.width/2.0;
      s.hitEvent(velocity.copy(), Ratio.WALL);
      velocity.x = -velocity.x * collisionCoef;
    } else if (ball.position.x < -m.width/2.0) {
      ball.position.x = -m.width/2.0;
      s.hitEvent(velocity.copy(), Ratio.WALL);
      velocity.x = -velocity.x * collisionCoef;
    }
    if (ball.position.z > m.length/2.0) {
      ball.position.z = m.length/2.0;
      s.hitEvent(velocity.copy(), Ratio.WALL);
      velocity.z = -velocity.z * collisionCoef;
    } else if (ball.position.z < -m.length/2.0) {
      ball.position.z = -m.length/2.0;
      s.hitEvent(velocity.copy(), Ratio.WALL);
      velocity.z = -velocity.z * collisionCoef;
    }
  }

  /**
   * @brief Helper method to check the collision with the cylinders
   * @param cylArray The list of cylinders on the plate
   */
  private void checkCylindersCollision(ArrayList<Cylinder> cylArray, ScoreManager s) {
    for (Cylinder c : cylArray) {
      if (inOrBorderCylinder(c)) {
        //normal vector where it touches the cylinder
        PVector normal = PVector.sub(ball.position, c.position).normalize();
        
        s.hitEvent(velocity.copy(), Ratio.CYLINDER);
        //Calculate velocity after collision (formula of the template)
        velocity = velocity.sub(PVector.mult(normal, 2*(velocity.dot(normal))));
        ball.position = PVector.add(c.position, normal.mult(ball.radius + c.radius));
      }
    }
  }

  /**
   * @brief Helper method to check if the ball collides with a cylinder
   * @param cyl A cylinder
   * @return wheter there is a collision (aka distance <= sum of radius)
   */
  private boolean inOrBorderCylinder(Cylinder cyl) {
    //tells if the ball touchs the cylinder (the smaller or equal sign is
    //because the position is a float and could never be equal)
    return ball.position.dist(cyl.position) <= cyl.radius + ball.radius;
  }
}
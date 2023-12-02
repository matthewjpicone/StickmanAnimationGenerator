/**
 * Stickman Animation Code
 *
 * This code file contains the implementation of the Stickman Animation project.
 * It defines the animation logic for the stickman figure, including its movement
 * and frame saving capabilities.
 *
 * @author Matthew Picone
 * @version 1.0.6
 * @since 30/05/2023
 */

Stickman stickman;  // Instance of the Stickman class.
int groundLevel;    // The ground level position.
int frameCount = 0; // Counter for the number of frames rendered.

/**
 * Sets up the initial environment properties such as screen size and frame rate
 * and initializes the stickman object.
 */
void setup() {
  size(200, 200);             // Set the size of the window.
  groundLevel = height - 20;  // Calculate the ground level.
  frameRate(30);              // Set the number of frames per second.
  smooth();                   // Enable smooth graphics.
  stickman = new Stickman(30);// Initialize the stickman object.
}

/**
 * Draws the stickman in each frame. It also handles frame counting and saving frames as images.
 */
void draw() {
  background(0);                 // Set background color.
  translate(width / 2, groundLevel); // Set translation to the middle of the ground.
  fill(0, 255, 0);               // Set fill color for shapes.
  stroke(0, 255, 0);             // Set stroke color for shapes.
  
  stickman.animate();            // Call the stickman's animate method.
  frameCount++;                  // Increment frame count.
  if (frameCount < 120) {        // Save first 120 frames as images.
    saveFrame("WalkingFrames/sticky-######.png");
  }
}

/**
 * Represents a stickman figure with animating capabilities.
 */
class Stickman {
  static final int MAX_ANGLE = 360;             // Constant for the maximum angle for animation.
  static final int STROKE_WEIGHT = 18;          // Constant defining the stroke weight for drawing.
  static final float WALK_CYCLE_MULTIPLIER = 8; // Multiplier for walk cycle animation.
  static final float FRONT_FOOT_OFFSET = 12;    // Offset angle for the front foot during animation.
  static final float BACK_FOOT_OFFSET = -12;    // Offset angle for the back foot during animation.
  static final float WAIST_ANGLE_OFFSET = 82;   // Offset angle for the waist during animation.
  static final float WAIST_MULTIPLIER = 16;     // Multiplier for waist movement.
  static final float HEAD_SIZE = 20;            // Constant for the size of the head.
  static final float BODY_LENGTH = 1.7;         // Constant for the length of the body.
  static final float LIMB_LENGTH = 1.15;        // Constant for the length of limbs.
  static final float FOOT_ANGLE_OFFSET = 25;    // Offset for the foot angle during animation.

  int animationStart; // Random starting point for animation.
  float time;         // Current time for calculating animation steps.
  float kneeAngle;    // Current angle of the knee.
  float frontFootAngle; // Current angle of the front foot.
  float backFootAngle;  // Current angle of the back foot.
  float waistAngle;     // Current angle of the waist.
  float unitSize;       // Size unit for drawing the stickman.
  Knee[] knees;         // Array to hold the two knees of the stickman.
  Foot[] feet;          // Array to hold the two feet of the stickman.
  Elbow[] elbows;       // Array to hold the two elbows of the stickman.
  Hand[] hands;         // Array to hold the two hands of the stickman.

  /**
   * Constructor for the Stickman class.
   * @param unit The size unit for the stickman.
   */
  Stickman(float unit) {
    animationStart = int(random(MAX_ANGLE));  // Initialize the starting animation angle.
    unitSize = unit;                          // Set the size unit.
    knees = new Knee[2];                      // Initialize knee array.
    feet = new Foot[2];                       // Initialize foot array.
    elbows = new Elbow[2];                    // Initialize elbow array.
    hands = new Hand[2];                      // Initialize hand array.
    
    // Create and assign limb objects.
    for (int i = 0; i < 2; i++) {
      knees[i] = new Knee(i);
      feet[i] = new Foot(i);
      elbows[i] = new Elbow(i);
      hands[i] = new Hand(i);
    }
  }

  /**
   * Animates the stickman by updating and drawing its components in each frame.
   */
  void animate() {
    strokeWeight(STROKE_WEIGHT);              // Set the stroke weight for drawing.
    time = (frameCount + animationStart) % MAX_ANGLE; // Update the time.
    
    // Calculate the angles for different parts of the stickman based on the current time.
    kneeAngle = sin(radians(time * WALK_CYCLE_MULTIPLIER));
    frontFootAngle = sin(radians((time + FRONT_FOOT_OFFSET) * WALK_CYCLE_MULTIPLIER));
    backFootAngle = sin(radians((time + BACK_FOOT_OFFSET) * WALK_CYCLE_MULTIPLIER));
    waistAngle = sin(radians((time + WAIST_ANGLE_OFFSET) * WAIST_MULTIPLIER));

    // Start drawing the stickman.
    pushMatrix();                             // Save the current transformation matrix.
    translate(0, waistAngle * 2);             // Apply translation for waist movement.
    pushMatrix();                             // Save the current transformation matrix.
    translate(0, -unitSize * 4.5);            // Apply translation for drawing the head.
    ellipse(0, 0, unitSize, unitSize);        // Draw the head of the stickman.
    translate(0, unitSize * 0.5);             // Move down to draw the body.

    // Draw arms and body.
    for (Elbow elbow : elbows) {
      elbow.move();   // Update and draw each elbow.
    }
    line(0, 0, 0, unitSize * BODY_LENGTH);    // Draw the body.
    translate(0, unitSize * BODY_LENGTH);     // Move down to draw the legs.

    // Draw legs.
    for (Knee knee : knees) {
      knee.move();    // Update and draw each knee.
    }
    popMatrix();                              // Restore the previous transformation matrix.
    popMatrix();                              // Restore the original transformation matrix.
  }

  /**
   * Represents a knee of the stickman.
   */
  class Knee {
    int id;       // Identifier for the knee.
    int direction;// Direction of the knee movement.

    /**
     * Constructor for the Knee class.
     * @param index The index of the knee (0 for left, 1 for right).
     */
    Knee(int index) {
      id = index;
      direction = (index == 0) ? 1 : -1; // Set the direction based on knee index.
    }

    /**
     * Moves the knee by calculating its current angle and drawing it.
     */
    void move() {
      float angle = direction * radians(30 * kneeAngle); // Calculate the knee angle.
      pushMatrix();   // Save the current transformation matrix.
      rotate(angle);  // Apply rotation based on the calculated angle.
      line(0, 0, 0, unitSize * LIMB_LENGTH); // Draw the knee.
      translate(0, unitSize * LIMB_LENGTH);  // Move down to position for the foot.
      feet[id].move(); // Move the corresponding foot.
      popMatrix();     // Restore the previous transformation matrix.
    }
  }
/**
 * Represents a foot of the stickman.
 */
class Foot {
  float angle;    // The current angle of the foot.
  int direction;  // The direction of the foot movement (1 for left, -1 for right).

  /**
   * Constructor for the Foot class.
   * @param index The index of the foot (0 for left, 1 for right).
   */
  Foot(int index) {
    direction = (index == 0) ? 1 : -1; // Set the direction based on the foot index.
  }

  /**
   * Moves the foot by calculating its current angle and drawing it.
   */
  void move() {
    angle = (direction == -1) ? radians(30 * frontFootAngle + FOOT_ANGLE_OFFSET) : radians(30 * backFootAngle + FOOT_ANGLE_OFFSET);
    pushMatrix();
    rotate(angle);                // Rotate the foot based on the calculated angle.
    line(0, 0, 0, unitSize * LIMB_LENGTH); // Draw the foot.
    popMatrix();
  }
}

/**
 * Represents an elbow of the stickman.
 */
class Elbow {
  int id;         // Identifier for the elbow.
  int direction;  // Direction of the elbow movement (1 for left, -1 for right).

  /**
   * Constructor for the Elbow class.
   * @param index The index of the elbow (0 for left, 1 for right).
   */
  Elbow(int index) {
    id = index;
    direction = (index == 0) ? 1 : -1; // Set the direction based on the elbow index.
  }

  /**
   * Moves the elbow by calculating its current angle and drawing it.
   */
  void move() {
    float angle = -direction * radians(30 * kneeAngle); // Calculate the elbow angle.
    pushMatrix();
    rotate(angle);                // Rotate the elbow based on the calculated angle.
    line(0, 0, 0, unitSize * LIMB_LENGTH); // Draw the elbow.
    translate(0, unitSize * LIMB_LENGTH);  // Move down to position for the hand.
    hands[id].move();             // Move the corresponding hand.
    popMatrix();
  }
}

/**
 * Represents a hand of the stickman.
 */
class Hand {
  float angle;    // The current angle of the hand.
  int direction;  // The direction of the hand movement (1 for left, -1 for right).

  /**
   * Constructor for the Hand class.
   * @param index The index of the hand (0 for left, 1 for right).
   */
  Hand(int index) {
    direction = (index == 0) ? 1 : -1; // Set the direction based on the hand index.
  }

  /**
   * Moves the hand by calculating its current angle and drawing it.
   */
  void move() {
    angle = (direction == -1) ? -radians(30 * frontFootAngle + FOOT_ANGLE_OFFSET) : -radians(30 * backFootAngle + FOOT_ANGLE_OFFSET);
    pushMatrix();
    rotate(angle);                // Rotate the hand based on the calculated angle.
    line(0, 0, 0, unitSize * LIMB_LENGTH); // Draw the hand.
    popMatrix();
  }
}
}

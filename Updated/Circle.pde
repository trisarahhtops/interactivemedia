class Circle {
  float x, y;
  float diameter;
  float speedX, speedY;
  color c;
  float hoverDiameter; // Diameter when hovered over
  float animationSpeed; // Animation speed for the circle
  float minRotationSpeed;
  float maxRotationSpeed;
  boolean clicked = false;
  float angle = 0;
  PVector targetPosition;
  float movementSpeed = 1.0;

  Circle(float x, float y, float diameter, float speedX, float speedY, color c, float animationSpeed) {
    this.x = x;
    this.y = y;
    this.diameter = diameter;
    this.speedX = speedX;
    this.speedY = speedY;
    this.c = c;
    this.hoverDiameter = diameter * 1.2; // Increase diameter when hovered
    this.animationSpeed = animationSpeed; // Assign animation speed
    this.minRotationSpeed = -0.01;
    this.maxRotationSpeed = 0.01;
    
    targetPosition = new PVector(x,y);
  }

  void move() {
    if (!clicked) {
      PVector direction = PVector.sub(targetPosition, new PVector(x, y));
      direction.normalize();
      direction.mult(movementSpeed);
      x += direction.x;
      y += direction.y;

      float proximity = 2.0;
      if (PVector.dist(targetPosition, new PVector(x, y)) < proximity) {
        targetPosition.x = random(width);
        targetPosition.y = random(height);
      }
    }
  }
  
  void cancelClick() {
    clicked = false;
  }

  boolean isMouseOver() {
    return dist(mouseX, mouseY, x, y) < diameter / 2;
  }

  void display() {
    fill(c);
    ellipse(x, y, diameter, diameter);
  }

  void updateRotation(float angleChange) {
    // Update the angle of rotation
    angle += angleChange;
    angle %= TWO_PI; // Keep the angle within the range [0, 2*PI]
  }

  void rotate(float angleChange) {
    // Apply rotation to the circle
    this.angle += angleChange;
    this.angle %= TWO_PI; // Keep the angle within the range [0, 2*PI]
  }

  void enlarge() {
    float targetDiameter = hoverDiameter;
    if (diameter < targetDiameter) {
      diameter += animationSpeed;
      diameter = min(diameter, targetDiameter);
    }
  }

  void shrink() {
    float targetDiameter = hoverDiameter;
    if (diameter > targetDiameter) {
      diameter -= animationSpeed;
      diameter = max(diameter, targetDiameter);
    }
  }
  
  void applyEffect() {
    clicked = !clicked;
  }
  
  boolean isClicked() {
    return clicked;
  }
}

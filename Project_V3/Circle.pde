class Circle {
  float x, y;
  float diameter;
  float speedX, speedY;
  color c;
  float hoverDiameter; // Diameter when hovered over
  float animationSpeed; // Animation speed for the circle

  Circle(float x, float y, float diameter, float speedX, float speedY, color c, float animationSpeed) {
    this.x = x;
    this.y = y;
    this.diameter = diameter;
    this.speedX = speedX;
    this.speedY = speedY;
    this.c = c;
    this.hoverDiameter = diameter * 1.2; // Increase diameter when hovered
    this.animationSpeed = animationSpeed; // Assign animation speed
  }

  void move() {
    x += speedX;
    y += speedY;

    if (x > width || x < 0) {
      speedX *= -1;
    }
    if (y > height || y < 0) {
      speedY *= -1;
    }
  }

  void display() {
    fill(c);
    ellipse(x, y, diameter, diameter);
  }

  void rotate(float angle) {
    // Apply rotation to the circle
    this.speedX += angle;
    this.speedY += angle;
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
    // Your code for applying an effect to the circle
  }
}

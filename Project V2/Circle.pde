class Circle {
  float x, y;
  float diameter;
  float speedX, speedY;
  color c;
  float hoverDiameter; // Diameter when hovered over

  Circle(float x, float y, float diameter, float speedX, float speedY, color c) {
    this.x = x;
    this.y = y;
    this.diameter = diameter;
    this.speedX = speedX;
    this.speedY = speedY;
    this.c = c;
    this.hoverDiameter = diameter * 1.2; // Increase diameter when hovered
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
    diameter = hoverDiameter;
  }

  void shrink() {
    diameter *= 0.95; // Shrink gradually when not hovered
    diameter = constrain(diameter, 20, hoverDiameter); // Limit minimum size
  }
}

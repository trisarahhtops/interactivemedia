class Circle {
  float x, y;
  float diameter;
  float speedX, speedY;
  color c;
  
  Circle(float x, float y, float diameter, float speedX, float speedY, color c) {
    this.x = x;
    this.y = y;
    this.diameter = diameter;
    this.speedX = speedX;
    this.speedY = speedY;
    this.c = c;
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
  
  void applyEffect(){
    this.c = color(random(255), random(255), random(255), 150);
  }
}

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
    // Adjust the motion based on humidity data
    if (index < xy.getRowCount()) {
      int humidity = xy.getInt(index, 1);
      float humidityFactor = map(humidity, 0, 100, 0.5, 2.0); // Adjust this mapping as needed
      speedX *= humidityFactor;
      speedY *= humidityFactor;
      index++;
    }
    
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

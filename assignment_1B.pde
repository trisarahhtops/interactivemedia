PImage backgroundImage;
Table xy;
int index = 0;
int numCircles = 100;//This control how many Circles are
Circle[] circles = new Circle[numCircles];
// These are global variables
float minDeform = -20;
float maxDeform = 20;
float minRotationSpeed = -0.01;
float maxRotationSpeed = 0.01;

void setup() {
  size(800, 600);
  
  // Load background image
  backgroundImage = loadImage("background.jpeg"); // add background image
  if (backgroundImage != null) {
    backgroundImage.resize(width, height);
    println("Background image loaded and resized.");
  } else {
    println("Error loading background image.");
  }
  
  // Load CSV data
  xy = loadTable("http://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2020-08-15T19%3A06%3A09&rToDate=2020-08-17T19%3A06%3A09&rFamily=wasp&rSensor=ES_B_06_418_7BED&rSubSensor=HUMA", "csv");
  
  // Initialize circles
  for (int i = 0; i < numCircles; i++) {
    float x = random(width);
    float y = random(height);
    float diameter = random(20, 100);
    float speedX = random(-2, 2);
    float speedY = random(-2, 2);
    color c = color(random(255), random(255), random(255), 150);
    
    circles[i] = new Circle(x, y, diameter, speedX, speedY, c);
  }
}

void draw() {
  // Draw background
  if (backgroundImage != null) {
    image(backgroundImage, 0, 0);
  } else {
    background(0);
  }
  
  // Draw circles
  for (int i = 0; i < numCircles; i++) {
    circles[i].move();
    
    // Apply rotation based on circle's position
    float rotationAmount = map(circles[i].x, 0, width, minRotationSpeed, maxRotationSpeed);
    circles[i].rotate(rotationAmount);
    
    circles[i].display();
  }
  
  // Display CSV data
  if (index < xy.getRowCount()) {
    int yValue = xy.getInt(index, 1);
    fill(255);
    text("Humidity: " + yValue, 10, 20);
    index++;
  }
}

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
}

PImage backgroundImage;
Table xy;
Table rainfallData; // Table for rainfall data
int index = 0;
int numCircles = 100;
Circle[] circles = new Circle[numCircles];
float minDeform = -20;
float maxDeform = 20;
float minRotationSpeed = -0.01;
float maxRotationSpeed = 0.01;
int selectedCircleIndex = -1;
boolean mouseHovering = false;

void setup() {
  size(800, 600);

  // Load background image
  backgroundImage = loadImage("background.jpeg");
  if (backgroundImage != null) {
    backgroundImage.resize(width, height);
    println("Background image loaded and resized.");
  } else {
    println("Error loading background image.");
  }

  // Load CSV data
  xy = loadTable("http://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2020-08-15T19%3A06%3A09&rToDate=2020-08-17T19%3A06%3A09&rFamily=wasp&rSensor=ES_B_06_418_7BED&rSubSensor=HUMA", "csv");
  
  // Load rainfall data
  rainfallData = loadTable("rainfall_data.csv", "header");

  for (int i = 0; i < numCircles; i++) {
    float x = random(width);
    float y = random(height);
    float diameter = random(20, 100);
    float speedX = random(-2, 2);
    float speedY = random(-2, 2);
    color c = color(random(255), random(255), random(255), 150);
    
    // Assign a unique animation speed to each circle
    float circleAnimationSpeed = random(0.005, 0.02);

    circles[i] = new Circle(x, y, diameter, speedX, speedY, c, circleAnimationSpeed);
  }
}

void draw() {
  if (backgroundImage != null) {
    image(backgroundImage, 0, 0);
  } else {
    background(0);
  }

  for (int i = 0; i < numCircles; i++) {
    boolean isMouseOverCircle = dist(mouseX, mouseY, circles[i].x, circles[i].y) < circles[i].diameter / 2;

    if (isMouseOverCircle) {
      circles[i].enlarge();
      mouseHovering = true;
    } else {
      circles[i].shrink();
    }

    if (!mouseHovering || selectedCircleIndex == i) {
      circles[i].move();
    }

    float rotationAmount = map(circles[i].x, 0, width, minRotationSpeed, maxRotationSpeed);
    circles[i].rotate(rotationAmount);

    circles[i].display();

    if (isMouseOverCircle) {
      selectedCircleIndex = i;
    }
  }

  if (index < xy.getRowCount()) {
    int yValue = xy.getInt(index, 1);
    fill(255);
    text("Humidity: " + yValue, 10, 20);
    index++;
  }

  if (selectedCircleIndex >= 0) {
    Circle selectedCircle = circles[selectedCircleIndex];
    fill(0);
    ellipse(selectedCircle.x, selectedCircle.y, selectedCircle.diameter, selectedCircle.diameter);
    fill(255);
    textSize(16);

    float textX = selectedCircle.x - textWidth("Information") / 2;
    float textY = selectedCircle.y + selectedCircle.diameter / 2 + 20;

    text("Information", textX, textY);

    // Display exact time and rainfall level from the Excel data
    String time = rainfallData.getString(selectedCircleIndex, "Time");
    float rainfall = rainfallData.getFloat(selectedCircleIndex, "Rainfall");
    text("Time: " + time, textX, textY + 30);
    text("Rainfall: " + rainfall, textX, textY + 50);
  }
}

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
}

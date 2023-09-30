import ddf.minim.*;
Minim minim;
AudioPlayer soundEffects;

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
boolean[] circleClicked = new boolean[numCircles]; // Keep track of which circles are clicked

void setup() {
  size(1500, 1000);

  minim = new Minim(this);
  soundEffects = minim.loadFile("Mario-coin-sound.wav");
  
  // Load background image
  backgroundImage = loadImage("background.png");
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
    circleClicked[i] = false; // Initialize all circles as not clicked
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
    } else {
      circles[i].shrink();
    }

    if (mousePressed && isMouseOverCircle) {
      // Toggle the clicked state of the circle
      circleClicked[i] = !circleClicked[i];
      circles[i].applyEffect();
      soundEffects.play();
      soundEffects.loop(1);
    }

    // Move the circle if it's not clicked
    if (!circleClicked[i]) {
      circles[i].move();
    }

    float rotationAmount = map(circles[i].x, 0, width, minRotationSpeed, maxRotationSpeed);
    circles[i].rotate(rotationAmount);

    circles[i].display();
  }

  if (index < xy.getRowCount()) {
    int yValue = xy.getInt(index, 1);
    fill(255);
    text("Humidity: " + yValue, 10, 20);
    index++;
  }

  for (int i = 0; i < numCircles; i++) {
    if (circleClicked[i]) {
      Circle selectedCircle = circles[i];
      fill(0);
      ellipse(selectedCircle.x, selectedCircle.y, selectedCircle.diameter, selectedCircle.diameter);
      fill(255);
      textSize(16);

      float textX = selectedCircle.x - textWidth("Information") / 2;
      float textY = selectedCircle.y + selectedCircle.diameter / 2 + 20;

      text("Information", textX, textY);

      // Display exact time and rainfall level from the Excel data
      String time = rainfallData.getString(i, "Time");
      float rainfall = rainfallData.getFloat(i, "Rainfall");
      text("Time: " + time, textX, textY + 30);
      text("Rainfall: " + rainfall, textX, textY + 50);
    }
  }
}

void stop() {
  minim.stop();
  super.stop();
}

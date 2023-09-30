import ddf.minim.*;
Minim minim;
AudioPlayer soundEffects;

PImage backgroundImage;
Table xy;
int index = 0;
int numCircles = 100; // This controls how many circles are
Circle[] circles = new Circle[numCircles];
// These are global variables
float minDeform = -20;
float maxDeform = 20;
float minRotationSpeed = -0.01;
float maxRotationSpeed = 0.01;
int selectedCircleIndex = -1;
boolean mouseHovering = false; // Flag to track if the mouse is hovering over any circle

void setup() {
  size(800, 600);
  
  minim = new Minim(this);
  soundEffects = minim.loadFile("Mario-coin-sound.wav");

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

  // Initialize circles with random initial sizes
  for (int i = 0; i < numCircles; i++) {
    float x = random(width);
    float y = random(height);
    float diameter = random(20, 100); // Random initial size
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

  // Draw circles and check for hover events
  for (int i = 0; i < numCircles; i++) {
    // Check if the mouse is over the current circle
    boolean isMouseOverCircle = dist(mouseX, mouseY, circles[i].x, circles[i].y) < circles[i].diameter / 2;
    
    // Enlarge the circle if it's hovered over and set the mouseHovering flag
    if (isMouseOverCircle) {
      circles[i].enlarge();
      mouseHovering = true;
    } else {
      circles[i].shrink(); // Shrink the circle when not hovered over
    }
    
    // Update the circle's movement based on the mouseHovering flag
    if (!mouseHovering || selectedCircleIndex == i) {
      circles[i].move();
    }

    // Apply rotation based on circle's position
    float rotationAmount = map(circles[i].x, 0, width, minRotationSpeed, maxRotationSpeed);
    circles[i].rotate(rotationAmount);

    circles[i].display();

    if (isMouseOverCircle) {
      selectedCircleIndex = i; // Store the index of the selected circle
    }
  }

  // Display CSV data
  if (index < xy.getRowCount()) {
    int yValue = xy.getInt(index, 1);
    fill(255);
    text("Humidity: " + yValue, 10, 20);
    index++;
  }

  // Display information for the selected circle
  if (selectedCircleIndex >= 0) {
    Circle selectedCircle = circles[selectedCircleIndex];
    fill(0);
    ellipse(selectedCircle.x, selectedCircle.y, selectedCircle.diameter, selectedCircle.diameter);
    fill(255);
    textSize(16);

    // Center the information text relative to the circle
    float textX = selectedCircle.x - textWidth("Information") / 2;
    float textY = selectedCircle.y + selectedCircle.diameter / 2 + 20;

    text("Information", textX, textY);
    // Add more information as needed
    
    if (mousePressed) {
      for (int i = 0; i < numCircles; i++){
        Circle circle = circles[i];
        float d = dist(mouseX, mouseY, circle.x, circle.y);
        if (d < circle.diameter/ 2){
          selectedCircle = circle;
        
          //Call and play sound effect function
          
          soundEffects.play();
          //soundEffects.rewind();
          soundEffects.loop(1);
          break;
        }
      }
    }
  }
}

void stop() {
  minim.stop();
  super.stop();
}

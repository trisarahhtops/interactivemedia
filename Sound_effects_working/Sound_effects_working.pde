import ddf.minim.*;
Minim minim;
AudioPlayer soundEffects;

PImage backgroundImage;
Table xy;
int index = 0;
int numCircles = 100;//This control how many Circles are
Circle[] circles = new Circle[numCircles];
Circle selectedCircle = null;
// These are global variables
float minDeform = -20;
float maxDeform = 20;
float minRotationSpeed = -0.01;
float maxRotationSpeed = 0.01;

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
  } 
  else {
    background(0);
  }
  
  // Draw circles
  for (int i = 0; i < numCircles; i++) 
  {
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
    if (mousePressed) {
      for (int i = 0; i < numCircles; i++){
        Circle circle = circles[i];
        float d = dist(mouseX, mouseY, circle.x, circle.y);
        if (d < circle.diameter/ 2){
          circle.applyEffect();
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

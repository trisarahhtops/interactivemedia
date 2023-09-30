import ddf.minim.*;
Minim minim;
AudioPlayer soundEffectCircle;
AudioPlayer soundEffectStar;

PImage backgroundImage;
Table xy;
Table rainfallData; // Table for rainfall data
Table windSpeedData; // Table for wind speed data
int index = 0;
int numShapes = 50; // Number of circles and stars
Circle[] circles = new Circle[numShapes];
Star[] stars = new Star[numShapes];

void setup() {
  size(1400, 775);

  minim = new Minim(this);
  soundEffectCircle = minim.loadFile("anime-wow-sound-effect.mp3");
  soundEffectStar = minim.loadFile("decide.mp3");
  
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
  
  // Load wind speed data
  windSpeedData = loadTable("windspeed_data.csv", "header");

  for (int i = 0; i < numShapes; i++) {
    float x = random(width);
    float y = random(height);
    float diameter = random(20, 100);
    float speedX = random(-2, 2);
    float speedY = random(-2, 2);
    color c = color(random(255), random(255), random(255), 150);
    
    // Assign a unique animation speed to each shape
    float shapeAnimationSpeed = random(0.005, 0.02);

    circles[i] = new Circle(x, y, diameter, speedX, speedY, c, shapeAnimationSpeed);
    stars[i] = new Star(x, y, diameter, windSpeedData.getFloat(i, "Windspeed"), c); // Pass the index to identify the star
  }
}

void draw() {
  if (backgroundImage != null) {
    image(backgroundImage, 0, 0);
  } else {
    background(0);
  }

  for (int i = 0; i < numShapes; i++) {
    boolean isMouseOverShape = dist(mouseX, mouseY, circles[i].x, circles[i].y) < circles[i].diameter / 2;

    if (isMouseOverShape) {
      circles[i].enlarge();
      stars[i].enlarge();
    } else {
      circles[i].shrink();
      stars[i].shrink();
    }

    // Move the shape
    circles[i].move();
    stars[i].move();

    float circleRotationAmount = map(circles[i].x, 0, width, circles[i].minRotationSpeed, circles[i].maxRotationSpeed);
    float starRotationAmount = map(stars[i].x, 0, width, stars[i].minRotationSpeed, stars[i].maxRotationSpeed);

    circles[i].updateRotation(circleRotationAmount);
    stars[i].updateRotation(starRotationAmount);

    circles[i].display();
    stars[i].display();
  }

  if (index < xy.getRowCount()) {
    int yValue = xy.getInt(index, 1);
    fill(255);
    text("Humidity: " + yValue, 10, 20);
    index++;
  }

  for (int i = 0; i < numShapes; i++) {
    if (circles[i].isClicked()) {
      Circle selectedCircle = circles[i];
      fill(191, 64, 191);
      ellipse(selectedCircle.x, selectedCircle.y, selectedCircle.diameter, selectedCircle.diameter);
      textSize(16);

      fill(255, 0, 0);
      float textX = selectedCircle.x - textWidth("Information") / 2;
      float textY = selectedCircle.y + selectedCircle.diameter / 2 + 20;
      text("Information", textX, textY);

      // Display exact time and rainfall level from the Excel datax
      String time = rainfallData.getString(i, "Time");
      float rainfall = rainfallData.getFloat(i, "Rainfall");
      fill(76, 153, 0);
      text("Time: " + time, textX, textY + 30);
      text("Rainfall: " + rainfall, textX, textY + 50);
    }
    
    if (stars[i].isClicked()) {
      Star selectedStar = stars[i];
      textSize(16);
      
      float textX = selectedStar.x - textWidth("Information") / 2;
      float textY = selectedStar.y + selectedStar.size / 2 + 20;
      
      fill(0, 255, 255);
      text("Information", textX, textY);

      // Display information for the star
      String time = windSpeedData.getString(i, "Time");
      float windSpeed = windSpeedData.getFloat(i, "Windspeed");
      fill(0, 255, 255);
      text("Time: " + time, textX, textY + 30);
      fill(0, 0, 204);
      text("Wind Speed: " + windSpeed, textX, textY + 50);
    }
  }
}

void mouseClicked() {
  // 遍历所有的圆圈
  for (int i = 0; i < numShapes; i++) {
    if (circles[i].isMouseOver()) {
      // 取消其他圆圈的点击状态
      for (int j = 0; j < numShapes; j++) {
        if (j != i) {
          circles[j].cancelClick();
        }
      }
      // 点击当前圆圈
      circles[i].applyEffect();
      soundEffectCircle.rewind(); // 
      soundEffectCircle.play();
    }
  }
  
  // 遍历所有的星星
  for (int i = 0; i < numShapes; i++) {
    if (stars[i].isMouseOver()) {
      // 取消其他星星的点击状态
      for (int j = 0; j < numShapes; j++) {
        if (j != i) {
          stars[j].cancelClick();
        }
      }
      // 
      stars[i].applyEffect();
      soundEffectStar.rewind(); // 
      soundEffectStar.play();
    }
  }
}

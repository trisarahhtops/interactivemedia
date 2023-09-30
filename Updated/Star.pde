import processing.core.PVector;
class Star {
  float x, y;
  float size;
  float windSpeed; // Wind speed data
  color c;
  color starColor;
  color clickedColor = color(127, 0, 255);
  boolean clicked = false;
  float angle = 0;
  float minRotationSpeed;
  float maxRotationSpeed;
  
  PVector targetPosition;
  float movementSpeed = 1.0;

  Star(float x, float y, float size, float windSpeed, color c) {
    this.x = x;
    this.y = y;
    this.size = size;
    this.windSpeed = windSpeed;
    this.c = c;
    this.minRotationSpeed = -0.01;
    this.maxRotationSpeed = 0.01;
    starColor =c;
    
    targetPosition = new PVector(x,y);
  }
  
  void cancelClick() {
    clicked = false;
  }

  void move() {
    // Implement movement logic for stars if needed
    if (!clicked) {
      // Continue moving
       if (!clicked) {
      // 计算星星朝目标位置移动的增量
      PVector direction = PVector.sub(targetPosition, new PVector(x, y));
      direction.normalize();
      direction.mult(movementSpeed);

      // 更新星星的位置
      x += direction.x;
      y += direction.y;

      // 如果星星接近目标位置，更新目标位置
      float proximity = 2.0; // 你可以根据需要调整这个值
      if (PVector.dist(targetPosition, new PVector(x, y)) < proximity) {
        targetPosition.x = random(width);
        targetPosition.y = random(height);
      }
    }
  }
  }
  boolean isMouseOver() {
    return dist(mouseX, mouseY, x, y) < size / 2;
  }

  void display() {
    if (clicked) {
      fill(clickedColor); // 如果星星被点击，使用黑色
    } else {
      fill(starColor); // 否则使用原始颜色
    }
    noStroke();
    drawStar(x, y, size / 2, size / 4, 5);
  }


  void updateRotation(float angleChange) {
    // Update the angle of rotation
    angle += angleChange;
    angle %= TWO_PI; // Keep the angle within the range [0, 2*PI]
  }

  void rotate(float angleChange) {
    // Apply rotation to the star
    this.angle += angleChange;
    this.angle %= TWO_PI; // Keep the angle within the range [0, 2*PI]
  }

  void enlarge() {
    // Implement enlargement logic for stars if needed
  }

  void shrink() {
    // Implement shrinkage logic for stars if needed
  }

  void applyEffect() {
    clicked = !clicked;
  }

  boolean isClicked() {
    return clicked;
  }

  void drawStar(float x, float y, float radius1, float radius2, int npoints) {
    float angle = TWO_PI / npoints;
    float halfAngle = angle / 2.0;
    beginShape();
    for (float a = -PI/2; a < TWO_PI-PI/2; a += angle) {
      float sx = x + cos(a) * radius2;
      float sy = y + sin(a) * radius2;
      vertex(sx, sy);
      sx = x + cos(a + halfAngle) * radius1;
      sy = y + sin(a + halfAngle) * radius1;
      vertex(sx, sy);
    }
    endShape(CLOSE);
  }
}

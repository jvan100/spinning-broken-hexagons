class Spinner {
  float x, y;
  float angle;
  float startAngle;
  float targetAngle;
  float scale = 1;
  float targetScale = 0.88;
  float distanceToCenter;
  
  color fromColour = color(87, 190, 230);
  color toColour = color(243, 238, 138);
  color colour;
  
  int frameCounter = 0;
  int duration;
  int activationFrame = 0;
  
  boolean rotating = false;
  int stage;
  
  Spinner(float x, float y, float angle, float distanceToCenter, int duration, int stage) {
    this.x = x;
    this.y = y;
    this.angle = angle;
    this.startAngle = angle;
    this.targetAngle = angle + TWO_PI / 3;
    this.distanceToCenter = distanceToCenter;
    this.duration = duration;
    this.stage = stage;
    this.colour = stage == 0 ? fromColour : toColour;
  }
  
  void update() {
    if (!rotating) {
      return; 
    }
    
    angle = easeInOutQuart(frameCounter, 0, duration, startAngle, targetAngle);
    
    float progress = (angle - startAngle) / (targetAngle - startAngle);
    colour = stage == 0 ? lerpColor(fromColour, toColour, progress) : lerpColor(toColour, fromColour, progress);
    scale = progress <= 0.5 ? easeInQuart(progress, 0, 0.5, 1, targetScale) : easeOutQuart(progress, 0.5, 1, targetScale, 1);
    
    frameCounter++;
    
    if (angle >= targetAngle) {
      angle = startAngle;
      frameCounter = 0; 
      rotating = false;
    }
  }
  
  void show() {
    pushMatrix();
    
    translate(x, y);
    rotate(angle);
    scale(scale);
    
    stroke(colour);
    strokeWeight(9);

    for (int i = 0; i < 3; i++) {
      line(0, 10, 0, 50);
      rotate(TWO_PI / 3);
    }
    
    popMatrix();
  }
  
  void resetColour() {
    colour = stage == 0 ? fromColour : toColour;
  }
}

float xSpacing = 120 * sin(PI / 3);
float ySpacing = 60 * cos(PI / 3) + 60;

int numRows = 13;
int numCols = 13;
Spinner[][][] spinners;

int totalDuration = 300;
int spinnerDuration = 130;
int frameCounter = 0;

int stage = 0;
int stages = 2;

void setup() {
  size(1080, 1080, P2D);
  frameRate(60);
  smooth(8);

  spinners = new Spinner[stages][numRows][numCols];
  
  float[] yOffsets = { 0, 60 };
  float[] startAngles = { 0, TWO_PI / 6 };
  
  for (int s = 0; s < stages; s++) {
    float centerX = width / 2;
    float centerY = height / 2 - 30 + yOffsets[s];
    
    float maxDistanceToCenter = 0;
  
    for (int row = 0; row < numRows; row++) {
      float rowY = centerY + (row - numRows / 2) * ySpacing;
      float rowCenterX = centerX + (row % 2) * xSpacing / 2;
  
      for (int col = 0; col < numCols; col++) {
        float colX = rowCenterX + (col - numCols / 2) * xSpacing;   
        float distanceToCenter = dist(colX, rowY, centerX, centerY - yOffsets[s]);      
        spinners[s][row][col] = new Spinner(colX, rowY, startAngles[s], distanceToCenter, spinnerDuration, s);
        
        maxDistanceToCenter = max(maxDistanceToCenter, distanceToCenter);
      }
    }
    
    for (Spinner[] rowSpinners : spinners[s]) {
      for (Spinner spinner : rowSpinners) {
        float from = s % 2 == 0 ? totalDuration - spinnerDuration : 0;
        float to = s % 2 == 0 ? 0 : totalDuration - spinnerDuration;
        int activationFrame = int(map(spinner.distanceToCenter, 0, maxDistanceToCenter, from, to));
        spinner.activationFrame = activationFrame;
      }
    }
  }
}

void draw() {
  background(72, 45, 86);
  
  for (Spinner[] rowSpinners : spinners[stage]) {
    for (Spinner spinner : rowSpinners) {
      if (frameCounter == spinner.activationFrame) {
        spinner.rotating = true;
      }
      
      spinner.update();
      spinner.show();
    }
  }
 
  frameCounter++;
  
  //saveFrame("frames/frame-####.png");
  
  if (frameCounter >= totalDuration) {
    frameCounter = 0;
    stage++;
    
    if (stage == stages) {
      stage = 0;
      //print("Finished");
      //noLoop();
    }
    
    for (Spinner[] rowSpinners : spinners[stage]) {
      for (Spinner spinner : rowSpinners) {
        spinner.resetColour();
      }
    }
  }
}

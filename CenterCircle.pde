class CenterCircle
{
  
  color circleColor = color(255,255,255);
  
  float diameter = 100; 
  float minDiameter = 50;
  float maxDiameter = 650;
  float diameterReduce = 7;
  float diameterIncrease = 100;
  
  int framesToWait = 15;
  int framesToGrow = 3;
  int frameCounter = 0;
  
  boolean shouldGrow = false;
  
  color fillColor = color(255);
  
  void draw()
  {
    if (diameter >= minDiameter)
    {
      diameter -= diameterReduce;
    }
    if (shouldGrow == true && diameter <= maxDiameter)
    {
      frameCounter++;
      diameter += diameterIncrease;
    }
    if (frameCounter >= framesToGrow || diameter >= maxDiameter)
    {
      frameCounter = 0;
      shouldGrow = false;
    }
    ellipseMode(CENTER);
    fill(fillColor);
    noStroke();
    ellipse(width/2,height/2,diameter,diameter);
  }
  
  void grow(float _diameterIncrease)
  {
    diameterIncrease = _diameterIncrease;
    shouldGrow = true;
  }
}

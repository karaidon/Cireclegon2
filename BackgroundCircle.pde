class BackgroundCircle extends Entity
{
  
  color strokeColor = color(0,0,0);
  int strokeWeight = 300;
  
  float initDiameter;
  float diameter = 0;
  float diameterIncrement = 75;
  
  boolean shouldGrow = false;
  
  void setup()
  {
    initDiameter = diameter;
  }
  
  void draw()
  {
    noFill();
    strokeWeight(strokeWeight);
    stroke(strokeColor);
    ellipseMode(CENTER);
    if (shouldGrow == true)
    {
      diameter += diameterIncrement;
    }
    if ((diameter + strokeWeight) > dist(width,0,width/2,height/2)*2)
    {
      diameter = initDiameter;
      shouldGrow = false;
    }
    ellipse(width/2,height/2,diameter,diameter);
  }
  
  void grow()
  {
    diameter = initDiameter;
    shouldGrow = true;
  }
  
}

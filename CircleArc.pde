class CircleArc extends Entity
{

  boolean shouldGrow = false;

  int layer = 1;
  int distanceBetweenLayers = 25;

  int strokeWeight = 5;

  float currentStartAngle;
  float currentEndAngle;

  float targetStartAngle;
  float targetEndAngle;

  float startAngleIncrement;
  float endAngleIncrement;

  float maxIncrement = PI/180 * 7;

  color strokeColor = color(255);

  public CircleArc(int _layer, int _strokeWeight)
  {
    layer = _layer;
    distanceBetweenLayers = _strokeWeight * 5;
    strokeWeight = _strokeWeight;
    changeTargetAngle();
  }

  void reinitialize()
  {
    layer = int(random(1, 15+1));
    randomizeWeight();
    changeTargetAngle();
  }

  void draw()
  {

    currentStartAngle += startAngleIncrement;
    currentEndAngle += endAngleIncrement;

    if (startAngleIncrement >= 0)
    {
      if (currentStartAngle >= targetStartAngle)
      {
        changeTargetAngle();
      }
    }
    else if (startAngleIncrement < 0)
    {
      if (currentStartAngle <= targetStartAngle)
      {
        changeTargetAngle();
      }
    }
    if (endAngleIncrement >= 0)
    {
      if (currentEndAngle >= targetEndAngle)
      {
        changeTargetAngle();
      }
    }
    else if (endAngleIncrement < 0)
    {
      if (currentEndAngle <= targetEndAngle)
      {
        changeTargetAngle();
      }
    }

    noFill();
    ellipseMode(CENTER);
    stroke(strokeColor);
    strokeWeight(strokeWeight);
    CircleWorld world = (CircleWorld) currentWorld;

    arc(width/2, height/2, world.centerCircle.diameter+(layer*distanceBetweenLayers), world.centerCircle.diameter+(layer*distanceBetweenLayers), currentStartAngle, currentEndAngle);
  }

  void changeTargetAngle()
  {
    if (int(random(0,2)) == 0)
    {
      targetStartAngle = random(-PI/2, PI/2);
      targetEndAngle = random(PI/2, 1.5*PI);
    }
    else
    {
      targetStartAngle = random(-2*PI, -1*PI);
      targetEndAngle = random(-1*PI, 0);
    }
    changeAngleIncrements();
  }

  void changeAngleIncrements()
  {

    if (targetStartAngle >= currentStartAngle)
    {
      startAngleIncrement = random(PI/180 * 0.05, maxIncrement);
    }
    else
    {
      startAngleIncrement = random(-maxIncrement, -(PI/180 * 0.05));
    }

    if (targetEndAngle >= currentEndAngle)
    {
      endAngleIncrement = random(PI/180 * 0.05, maxIncrement);
    }
    else
    {
      endAngleIncrement = random(-maxIncrement, -(PI/180 * 0.05));
    }
  }

  void randomizeWeight()
  {
    strokeWeight = int(random(4, 20+1));
    distanceBetweenLayers = strokeWeight * 5;
  }

  void mouseClicked()
  {
    //changeTargetAngle();
    int i = int(random(0, 15+1));
    if (i == 10)
    {
      reinitialize();
    }
    if (i <= 3)
    {
      changeTargetAngle();
    }
  }
}


class GridSquare extends Entity
{
  
  int sqrLength;
  color sqrColor;
  color outlineColor;
  color initColor;
  int strWidth;
  int x;
  int y;
  int xOffset;
  int yOffset;
  
  color targetColor;
  color storeColor;
  int upperFluctThreshold = 50;
  int lowerFluctThreshold = 255;
  float currLerpIndex = 0;
  float lerpSpeed = 10;
  
  int autoFluctChance = 60;
  int autoLerpSpeedMax = 75;
  int autoLerpSpeedMin = 20;
  
  int initLength;
  int storeLength;
  int targetLength;
  float currGrowIndex = 0;
  float growLerpSpeed = 10;
  
  public GridSquare(int _xRow, int _yRow, int _length, color _color, color _outline, int _strWidth)
  {
    sqrLength = _length;
    initLength = sqrLength;
    targetLength = sqrLength;
    sqrColor = _color;
    initColor = _color;
    outlineColor = _outline;
    strWidth = _strWidth;
    x = (_xRow) * (_length) + (_length/2);
    y = (_yRow) * (_length) + (_length/2);
    xOffset = int(((float(width)/_length) - float(floor(float(width)/_length))) * float(_length));
    yOffset = int(((float(height)/_length) - float(floor(float(height)/_length))) * float(_length));
  }
  
  void draw()
  {
    fill(sqrColor);
    stroke(outlineColor);
    strokeWeight(strWidth);
    rectMode(CENTER);
    grow();
    lerpFill();
    rect(x-(xOffset/2),y-(yOffset/2),sqrLength,sqrLength);
  }
  
  
  void lerpFill()
  {
    if (int(random(0,autoFluctChance)) == 0)
    {
      lerpSpeed = int(random(autoLerpSpeedMin,autoLerpSpeedMax));
      fluctuateColor();
    }
    if (sqrColor == targetColor)
    {
      currLerpIndex = 0;
    }
    else
    {
      currLerpIndex += 1/lerpSpeed;
      currLerpIndex = constrain(currLerpIndex,0,1);
      sqrColor = lerpColor(storeColor,targetColor,currLerpIndex);
    }
  }
  
  void manualFluctuateColor()
  {
    lerpSpeed = 10;
    fluctuateColor();
  }
  
  void grow()
  {
    if (sqrLength == targetLength)
    {
      currGrowIndex = 0;
      targetLength = initLength;
      storeLength = sqrLength;
    }
    else
    {
      growLerpSpeed = random(4,25);
      currGrowIndex += 1/growLerpSpeed;
      currGrowIndex = constrain(currGrowIndex,0,1);
      sqrLength = int(lerp(storeLength,targetLength,currGrowIndex));
    }
  }
  
  void growLength(float _vol)
  {
    storeLength = sqrLength;
    targetLength = int(initLength * random(0,1.5+_vol));
  }
  
  void changeColor(color _color)
  {
    storeColor = sqrColor;
    targetColor = _color;
    initColor = _color;
  }
  
  void fluctuateColor()
  {
    storeColor = sqrColor;
    if (int(random(0,2)) == 0)
    {
      float _random = int(random(0,upperFluctThreshold));
      targetColor = color(red(initColor) + _random, green(initColor) + _random, blue(initColor) + _random);
      //targetColor.green() = ;
      //targetColor.blue() = blue(initColor) + int(random(0,fluctThreshold));
    }
    else
    {
      float _random = int(random(0,lowerFluctThreshold));
      targetColor = color(red(initColor) - _random, green(initColor) - _random, blue(initColor) - _random);
      //targetColor.green() = initColor.green() - int(random(0,fluctThreshold));
      //targetColor.blue() = initColor.blue() - int(random(0,fluctThreshold));
    }
  }
}

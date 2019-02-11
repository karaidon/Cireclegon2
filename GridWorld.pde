class GridWorld extends World
{
  
  ArrayList squareList = new ArrayList();
  color[] colorList = new color[0];
  int sqrLength = 160;
  
  int changeColorChance = 60;
  
  boolean colorChangeOn = true;
  
  void setup()
  {
    for (int i = -1; i <= 9;i++)
    {
      for (int m = -1; m <= 7; m++)
      {
        squareList.add(new GridSquare(i,m,sqrLength,color(200,100,0),color(0),2));
      }
    }
    //beat.setSensitivity(200);
    
    colorList = new color[0];
    colorList = append(colorList,color(200,100,0));
    colorList = append(colorList,color(100,200,0));
    colorList = append(colorList,color(100,0,200));
    colorList = append(colorList,color(0,200,100));
    colorList = append(colorList,color(200,0,100));
    colorList = append(colorList,color(0,200,100));
    colorList = append(colorList,color(0,200,0));
    colorList = append(colorList,color(0,0,200));
    colorList = append(colorList,color(200,0,0));
    
    colorChangeOn = true;
    
    helpText = "BckSpace-force Trigger\nz-toggle Color Change\nx-force Color Change";
  }
  
  void draw()
  {
    if (int(random(0,changeColorChance)) == 0 && colorChangeOn == true)
    {
      color _color = colorList[int(random(0,colorList.length))];
      changeColor(_color);
    }
    
    beat.detect(input.mix);
    if (beat.isOnset() || beat.isKick())
    {
      fluctuateColor();
      grow(input.mix.level()); 
    }
    if (beat.isHat())
    {
      fluctuateColor();
    }
    for (int i = squareList.size()-1; i != 0; i--)
    {
      GridSquare square = (GridSquare) squareList.get(i);
      square.draw();
    }
  }
  
  void changeColor(color _color)
  {
    for (int i = 0; i <= squareList.size()-1; i++)
    {
      GridSquare square = (GridSquare) squareList.get(i);
      square.changeColor(_color);
    }
  }
  
  void fluctuateColor()
  {
    for (int i = 0; i <= squareList.size()-1; i++)
    {
      GridSquare square = (GridSquare) squareList.get(i);
      square.manualFluctuateColor();
    }
  }
  
  void grow(float _vol)
  {
    for (int i = 0; i <= squareList.size()-1; i++)
    {
      GridSquare square = (GridSquare) squareList.get(i);
      square.growLength(_vol);
    }
  }
  
  void mouseClicked()
  {
    if (key ==BACKSPACE)
    {
      fluctuateColor();
      grow(0.5);
    }
    else if (key =='z')
    {
      colorChangeOn = !colorChangeOn;
      println("colorChangeOn: " + colorChangeOn);
      f.debug("colorChangeOn: " + colorChangeOn);
    }
    else if (key =='x')
    {
      color _color = colorList[int(random(0,colorList.length))];
      changeColor(_color);
    }
  }
  
  void stop()
  {
    
  }
}

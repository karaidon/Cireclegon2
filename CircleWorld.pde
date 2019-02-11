class CircleWorld extends World
{
  CenterCircle centerCircle;
  
  BackgroundCircle bgCircle;
  
  ArrayList arcArray = new ArrayList();
  
  color bgColor = color(0,0,0);
  color fgColor = color(255,255,255);
  color fgColor2 = color(255,255,255);
  color fgColor3 = color(255,255,255);
  
  color fromFGColor2;
  color fromFGColor3;
  color toFGColor2;
  color toFGColor3;
  
  color fromBGColor;
  color fromFGColor;
  color toBGColor;
  color toFGColor;
  float lerpCounter = 0;
  color[] colorList1 = new color[10];
  color[] colorList2 = new color[10];
  color[] colorList3 = new color[10];
  color[] colorList4 = new color[10];
  boolean freezeColor = false;
  boolean multiColor = true;
  boolean colorFading = true;
  
  int colorOverrideCounter = 0;
  
  void setup()
  {
    
    bgCircle = new BackgroundCircle();
    centerCircle = new CenterCircle();
    for (int i = 1; i <= 30; i++)
    {
      arcArray.add(new CircleArc(i,5));
      //arcArray.add(new CircleArc(i,5));
      //arcArray.add(new CircleArc(i,5));
    }
    for (int i = 0; i <= arcArray.size()-1; i++)
    {
      CircleArc arc = (CircleArc) arcArray.get(i);
      arc.randomizeWeight();
    }
    
    colorList1[0] = color(0);
    colorList2[0] = color(255);
    colorList3[0] = color(0);
    colorList4[0] = color(255);
    
    colorList1[1] = color(83,12,232);
    colorList2[1] = color(255,0,0);
    colorList3[1] = color(200,0,0);
    colorList4[1] = color(60,15,220);
    
    colorList1[2] = color(195,224,255);
    colorList2[2] = color(64,120,178);
    colorList3[2] = color(178,178,178);
    colorList4[2] = color(255,205,117);
    
    colorList1[3] = color(249,255,248);
    colorList2[3] = color(73,178,64);
    colorList3[3] = color(255,117,202);
    colorList4[3] = color(128,255,117);
    
    colorList1[4] = color(255,253,248);
    colorList2[4] = color(178,151,64);
    colorList3[4] = color(93,107,178);
    colorList4[4] = color(50,84,255);
    
    colorList1[5] = color(139,255,188);
    colorList2[5] = color(8,255,112);
    colorList3[5] = color(34,178,95);
    colorList4[5] = color(255,52,37);
    
    colorList1[6] = color(100);
    colorList2[6] = color(178);
    colorList3[6] = color(165);
    colorList4[6] = color(255);
    
    colorList1[7] = color(200,251,255);
    colorList2[7] = color(77,172,178);
    colorList3[7] = color(69,243,255);
    colorList4[7] = color(178,72,0);
    
    colorList1[8] = color(164,178,77);
    colorList2[8] = color(228,255,69);
    colorList3[8] = color(128,50,178);
    colorList4[8] = color(154,0,255);
    
    colorList1[9] = color(200,255,203);
    colorList2[9] = color(69,255,78);
    colorList3[9] = color(170,35,92);
    colorList4[9] = color(255,0,107);
    
    resetColorLerp();
    
    helpText = "z-toggle Color Change\nx-toggle Multi Color\nc-toggle Fading Color\nv-force Color Change\nb-force BGCircle Growth\nBckSpace-Force Trigger";
  }
  
  void draw()
  {
    beat.detect(input.mix);
    if (beat.isOnset() || beat.isKick())
    {
      triggerGrowth(input.mix.level()+volComp);
      
      if (input.mix.level() < 0.3)
      {
        multiColor = false;
      }
      else
      {
        multiColor = true; 
      }
      
      if (input.mix.level()+volComp >= mixLvlThreshold)
      {
        bgCircle.grow();
      }
      
    }
    
    if (freezeColor == false)
    {
      lerpCounter += 0.015;
      bgColor = lerpColor(fromBGColor,toBGColor,lerpCounter);
      fgColor = lerpColor(fromFGColor,toFGColor,lerpCounter);
    }
    if (lerpCounter >= 1 && colorFading == true)
    {
      resetColorLerp();
    }
    
    background(bgColor);
    bgCircle.draw();
    for (int i = 0; i <= arcArray.size()-1; i++)
    {
      CircleArc arc = (CircleArc) arcArray.get(i);
      
      
      if (multiColor == false)
      {
        arc.strokeColor = fgColor;
      }
      else
      {
        int x = int(random(1,3+1));
        switch(x)
        {
          case 1:
          arc.strokeColor = fgColor;
          break;
          case 2:
          arc.strokeColor = fgColor2;
          break;
          case 3:
          arc.strokeColor = fgColor3;
          break;
        }
      }
      
      arc.draw();
    }
    centerCircle.fillColor = fgColor;
    centerCircle.draw();
    
    //offsetPixels(16,512,32,56,"RIGHT");
  }
  
  void resetColorLerp()
  {
    int bgI = int(random(0,9+1));
    overrideColor(bgI);
  }
  
  void overrideColor(int counter)
  {
    int bgN = int(random(1,4+1));
    switch(bgN)
    {
      case 1:
      toBGColor = (color) colorList1[counter];
      break;
      case 2:
      toBGColor = (color) colorList2[counter];
      break;
      case 3:
      toBGColor = (color) colorList3[counter];
      break;
      case 4:
      toBGColor = (color) colorList4[counter];
      break;
    }
    
    int fgN = int(random(1,4+1));
    if (fgN == bgN)
    {
      fgN -= 1;
      if (fgN <= 0)
      {
        fgN += 2;
      }
    }
    switch(fgN)
    {
      case 1:
      toFGColor = (color) colorList1[counter];
      break;
      case 2:
      toFGColor = (color) colorList2[counter];
      break;
      case 3:
      toFGColor = (color) colorList3[counter];
      break;
      case 4:
      toFGColor = (color) colorList4[counter];
      break;
    }
    
    int fgN2 = int(random(1,4+1));
    switch(fgN2)
    {
      case 1:
      toFGColor2 = (color) colorList1[counter];
      break;
      case 2:
      toFGColor2 = (color) colorList2[counter];
      break;
      case 3:
      toFGColor2 = (color) colorList3[counter];
      break;
      case 4:
      toFGColor2 = (color) colorList4[counter];
      break;
    }
    
    int fgN3 = int(random(1,4+1));
    switch(fgN3)
    {
      case 1:
      toFGColor3 = (color) colorList1[counter];
      bgCircle.strokeColor = (color) colorList1[counter];
      break;
      case 2:
      toFGColor3 = (color) colorList2[counter];
      bgCircle.strokeColor = (color) colorList2[counter];
      break;
      case 3:
      toFGColor3 = (color) colorList3[counter];
      bgCircle.strokeColor = (color) colorList3[counter];
      break;
      case 4:
      toFGColor3 = (color) colorList4[counter];
      bgCircle.strokeColor = (color) colorList4[counter];
      break;
    }
    
    lerpCounter = 0;
    fromBGColor = bgColor;
    fromFGColor = fgColor;
    fromFGColor2 = fgColor2;
    fromFGColor3 = fgColor3;
  }
  
  void forceColor(int counter)
  {
  int bgN = int(random(1,4+1));
    switch(bgN)
    {
      case 1:
      bgColor = (color) colorList1[counter];
      break;
      case 2:
      bgColor = (color) colorList2[counter];
      break;
      case 3:
      bgColor = (color) colorList3[counter];
      break;
      case 4:
      bgColor = (color) colorList4[counter];
      break;
    }
    
    int fgN = int(random(1,4+1));
    if (fgN == bgN)
    {
      fgN -= 1;
      if (fgN <= 0)
      {
        fgN += 2;
      }
    }
    switch(fgN)
    {
      case 1:
      fgColor = (color) colorList1[counter];
      bgCircle.strokeColor = (color) colorList2[counter];
      break;
      case 2:
      fgColor = (color) colorList2[counter];
      bgCircle.strokeColor = (color) colorList1[counter];
      break;
      case 3:
      fgColor = (color) colorList3[counter];
      bgCircle.strokeColor = (color) colorList4[counter];
      break;
      case 4:
      fgColor = (color) colorList4[counter];
      bgCircle.strokeColor = (color) colorList3[counter];
      break;
    }
    fromBGColor = bgColor;
    fromFGColor = fgColor;
    lerpCounter = 0;
  }
  
  void triggerGrowth(float fraction)
  {
    centerCircle.grow(75*fraction);
    //bgCircle.grow();
      for (int i = 0; i <= arcArray.size()-1; i++)
      {
        CircleArc arc = (CircleArc) arcArray.get(i);
        arc.mouseClicked();
      }
   }
  
  void mouseClicked()
  {
    if (key == 'z')
    {
      freezeColor = !freezeColor;
      println("freezeColor: " + freezeColor);
      f.debug("freezeColor: " + freezeColor);
    }
    else if (key == 'x')
    {
      multiColor = !multiColor;
      println("multiColor: " + multiColor);
      f.debug("multiColor: " + multiColor);
    }
    else if (key == 'c')
    {
      colorFading = !colorFading;
      println("colorFading: " + colorFading);
      f.debug("colorFading: " + colorFading);
    }
    else if (key == 'v')
    {
      forceColor(colorOverrideCounter);
      colorOverrideCounter++;
      if (colorOverrideCounter > colorList1.length-1)
      {
        colorOverrideCounter = 0;
      }
    }
    else if (key == 'b')
    {
    bgCircle.grow();
    }
    
    else if (key == BACKSPACE)
    {
      triggerGrowth(1);
    }
  }
}

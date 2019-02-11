class RotSquareWorld extends World
{
  
  color[] colorList = new color[0];
  
  
  float currentSqrSize;
  float currentSqrAngle;
  color initSqrColor;
  
  float storeSqrSize;
  float storeSqrAngle;
  
  float targetSqrSize;
  float targetSqrAngle;
  
  boolean colorChangeOn;
  boolean angleChangeOn;
  boolean sizeChangeOn;
  
  float colorLerpCounter;
  float ColorVarLerpCounter;
  float angleLerpCounter;
  float sizeLerpCounter;
  float colorLerpInc;
  
  color currentSqr1Color;
  color storeSqr1Color;
  color targetSqr1Color;
  
  color currentSqr2Color;
  color storeSqr2Color;
  color targetSqr2Color;
  
  color currentSqr3Color;
  color storeSqr3Color;
  color targetSqr3Color;
  
  color currentSqr4Color;
  color storeSqr4Color;
  color targetSqr4Color;
  
  color currentSqr5Color;
  color storeSqr5Color;
  color targetSqr5Color;
  
  color currentSqr6Color;
  color storeSqr6Color;
  color targetSqr6Color;
  
  color currentSqr7Color;
  color storeSqr7Color;
  color targetSqr7Color;
  
  color currentSqr8Color;
  color storeSqr8Color;
  color targetSqr8Color;
  
  color currentSqr9Color;
  color storeSqr9Color;
  color targetSqr9Color;
  
  boolean firstFrame;
  PImage prevFrame;
  
  void setup()
  {
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
    colorList = append(colorList,color(255));
    colorList = append(colorList,color(0));
    
    colorChangeOn = true;
    angleChangeOn = true;
    sizeChangeOn = true;
    
    currentSqr1Color = color(0,0,0);
    currentSqr2Color = color(0,0,0);
    currentSqr3Color = color(0,0,0);
    currentSqr4Color = color(0,0,0);
    currentSqr5Color = color(0,0,0);
    currentSqr6Color = color(0,0,0);
    currentSqr7Color = color(0,0,0);
    currentSqr8Color = color(0,0,0);
    currentSqr9Color = color(0,0,0);
    
    colorLerpCounter = 0;
    ColorVarLerpCounter = 0;
    angleLerpCounter = 0;
    sizeLerpCounter = 0;
    colorLerpInc = 0.05;
    
    currentSqrSize = 450;
    currentSqrAngle = 0;
    
    firstFrame = true;
    prevFrame = createImage(width,height,RGB);
    
    helpText = "z-toggle Color Change\nx-toggle Size Change\nc-toggle Angle Change";
  }
  
  void draw()
  {
    beat.detect(input.mix);
    if (beat.isOnset() || beat.isKick())
    {
      background(0);
      loadPixels();
      prevFrame.pixels = pixels;
      prevFrame.updatePixels();
    }
    if (firstFrame == false)
    {
      prevFrame.loadPixels();
      pixels = prevFrame.pixels;
      updatePixels();
    }
    else 
    {
      firstFrame = false;
      background(0);
    }
    
   
    if (beat.isOnset() || beat.isKick())
    {
      changeColor();
      changeAngle();
      if (input.mix.level() + volComp >= mixLvlThreshold)
      {
        changeSize(5*(input.mix.level()+volComp));
      }
    }
    if (beat.isHat())
    {
      changeAngle();
    }
    
    if (colorChangeOn == true)
    {
      colorLerpCounter += colorLerpInc;
      currentSqr1Color = lerpColor(storeSqr1Color,targetSqr1Color,colorLerpCounter);
      currentSqr2Color = lerpColor(storeSqr2Color,targetSqr2Color,colorLerpCounter);
      currentSqr3Color = lerpColor(storeSqr3Color,targetSqr3Color,colorLerpCounter);
      currentSqr4Color = lerpColor(storeSqr4Color,targetSqr4Color,colorLerpCounter);
      currentSqr5Color = lerpColor(storeSqr5Color,targetSqr5Color,colorLerpCounter);
      currentSqr6Color = lerpColor(storeSqr6Color,targetSqr6Color,colorLerpCounter);
      currentSqr7Color = lerpColor(storeSqr7Color,targetSqr7Color,colorLerpCounter);
      currentSqr8Color = lerpColor(storeSqr8Color,targetSqr8Color,colorLerpCounter);
      currentSqr9Color = lerpColor(storeSqr9Color,targetSqr9Color,colorLerpCounter);
      //if (colorLerpCounter >= 1) colorLerpCounter = 0;
    }
    if (sizeChangeOn == true)
    {
      if (sizeLerpCounter <= 3)
      {
        sizeLerpCounter += 1;
        if (currentSqrSize <= 800) currentSqrSize += 100*(input.mix.level()+volComp);
      }
      //if (sizeLerpCounter >= 1) sizeLerpCounter = 0;
      if (currentSqrSize >= 450) currentSqrSize -= 15;
    }
    if (angleChangeOn == true)
    {
      angleLerpCounter += 0.05;
      currentSqrAngle = lerp(storeSqrAngle,targetSqrAngle,angleLerpCounter);
      if (angleLerpCounter >= 1) angleLerpCounter = 1;
    }
    //fluctuateColor();
    rectMode(CENTER);
    translate(width/2,height/2);
    rotate(currentSqrAngle);
    //translate(0,0);
    noStroke();
    fill(currentSqr1Color);
    rect(-currentSqrSize/3,-currentSqrSize/3,currentSqrSize/3,currentSqrSize/3);
    fill(currentSqr2Color);
    rect(0,-currentSqrSize/3,currentSqrSize/3,currentSqrSize/3);
    fill(currentSqr3Color);
    rect(-currentSqrSize/3,0,currentSqrSize/3,currentSqrSize/3);
    fill(currentSqr4Color);
    rect(0,0,currentSqrSize/3,currentSqrSize/3);
    fill(currentSqr5Color);
    rect(currentSqrSize/3,currentSqrSize/3,currentSqrSize/3,currentSqrSize/3);
    fill(currentSqr6Color);
    rect(0,currentSqrSize/3,currentSqrSize/3,currentSqrSize/3);
    fill(currentSqr7Color);
    rect(currentSqrSize/3,0,currentSqrSize/3,currentSqrSize/3);
    fill(currentSqr8Color);
   // rect(-currentSqrSize/3,currentSqrSize/3,currentSqrSize/3,currentSqrSize/3);
    fill(currentSqr9Color);
   // rect(currentSqrSize/3,-currentSqrSize/3,currentSqrSize/3,currentSqrSize/3);
    
    loadPixels();
    prevFrame.pixels = pixels;
    prevFrame.updatePixels();
  }
  
  
  void drawFrame()
  {
    
  }
  
  void fluctuateColor()
  {
    colorLerpInc = 0.005;
    storeSqr1Color = currentSqr1Color;
    storeSqr2Color = currentSqr2Color;
    storeSqr3Color = currentSqr3Color;
    storeSqr4Color = currentSqr4Color;
    storeSqr5Color = currentSqr5Color;
    storeSqr6Color = currentSqr6Color;
    storeSqr7Color = currentSqr7Color;
    storeSqr8Color = currentSqr8Color;
    storeSqr9Color = currentSqr9Color;
    if (int(random(0,2)) == 0)
    {
      float _random = int(random(0,50));
      targetSqr1Color = color(red(initSqrColor) + _random, green(initSqrColor) + _random, blue(initSqrColor) + _random);
      targetSqr2Color = color(red(initSqrColor) + _random, green(initSqrColor) + _random, blue(initSqrColor) + _random);
      targetSqr3Color = color(red(initSqrColor) + _random, green(initSqrColor) + _random, blue(initSqrColor) + _random);
      targetSqr4Color = color(red(initSqrColor) + _random, green(initSqrColor) + _random, blue(initSqrColor) + _random);
      targetSqr5Color = color(red(initSqrColor) + _random, green(initSqrColor) + _random, blue(initSqrColor) + _random);
      targetSqr6Color = color(red(initSqrColor) + _random, green(initSqrColor) + _random, blue(initSqrColor) + _random);
      targetSqr7Color = color(red(initSqrColor) + _random, green(initSqrColor) + _random, blue(initSqrColor) + _random);
      targetSqr8Color = color(red(initSqrColor) + _random, green(initSqrColor) + _random, blue(initSqrColor) + _random);
      targetSqr9Color = color(red(initSqrColor) + _random, green(initSqrColor) + _random, blue(initSqrColor) + _random);
      //targetColor.green() = ;
      //targetColor.blue() = blue(initColor) + int(random(0,fluctThreshold));
      
    }
    else
    {
      float _random = int(random(0,50));
      targetSqr1Color = color(red(initSqrColor) - _random, green(initSqrColor) - _random, blue(initSqrColor) - _random);
      targetSqr2Color = color(red(initSqrColor) - _random, green(initSqrColor) - _random, blue(initSqrColor) - _random);
      targetSqr3Color = color(red(initSqrColor) - _random, green(initSqrColor) - _random, blue(initSqrColor) - _random);
      targetSqr4Color = color(red(initSqrColor) - _random, green(initSqrColor) - _random, blue(initSqrColor) - _random);
      targetSqr5Color = color(red(initSqrColor) - _random, green(initSqrColor) - _random, blue(initSqrColor) - _random);
      targetSqr6Color = color(red(initSqrColor) - _random, green(initSqrColor) - _random, blue(initSqrColor) - _random);
      targetSqr7Color = color(red(initSqrColor) - _random, green(initSqrColor) - _random, blue(initSqrColor) - _random);
      targetSqr8Color = color(red(initSqrColor) - _random, green(initSqrColor) - _random, blue(initSqrColor) - _random);
      targetSqr9Color = color(red(initSqrColor) - _random, green(initSqrColor) - _random, blue(initSqrColor) - _random);
      //targetColor.green() = initColor.green() - int(random(0,fluctThreshold));
      //targetColor.blue() = initColor.blue() - int(random(0,fluctThreshold));
    }
    colorLerpInc = 0.005;
  }
  
  void changeColor()
  {
    storeSqr1Color = currentSqr1Color;
    targetSqr1Color = colorList[int(random(0,colorList.length))];
    initSqrColor = colorList[int(random(0,colorList.length))];
    
    storeSqr2Color = currentSqr2Color;
    targetSqr2Color = colorList[int(random(0,colorList.length))];
    
    storeSqr3Color = currentSqr3Color;
    targetSqr3Color = colorList[int(random(0,colorList.length))];
    
    storeSqr4Color = currentSqr4Color;
    targetSqr4Color = colorList[int(random(0,colorList.length))];
    
    storeSqr5Color = currentSqr5Color;
    targetSqr5Color = colorList[int(random(0,colorList.length))];
    
    storeSqr6Color = currentSqr6Color;
    targetSqr6Color = colorList[int(random(0,colorList.length))];
    
    storeSqr7Color = currentSqr7Color;
    targetSqr7Color = colorList[int(random(0,colorList.length))];
    
    storeSqr8Color = currentSqr8Color;
    targetSqr8Color = colorList[int(random(0,colorList.length))];
    
    storeSqr9Color = currentSqr9Color;
    targetSqr9Color = colorList[int(random(0,colorList.length))];
    
    colorLerpCounter = 0;
    colorLerpInc = 0.1;
  }
  
  void changeAngle()
  {
    storeSqrAngle = currentSqrAngle;
    targetSqrAngle = random(0, TWO_PI);
    //initSqrAngle = random(0, TWO_PI);
    angleLerpCounter = 0;
  }
  
  void changeSize(float _size)
  {
    storeSqrSize = currentSqrSize;
    targetSqrSize = currentSqrSize + _size;
    //initSqrAngle = currentSqrSize + _size;
    sizeLerpCounter = 0;
  }
  
  void mouseClicked()
  {
    if (key == 'z')
    {
      colorChangeOn = !colorChangeOn;
      println("colorChangeOn: " + colorChangeOn);
      f.debug("colorChangeOn: " + colorChangeOn);
    }
    else if (key == 'x')
    {
      sizeChangeOn = !sizeChangeOn;
      println("sizeChangeOn: " + sizeChangeOn);
      f.debug("sizeChangeOn: " + sizeChangeOn);
    }
    else if (key == 'c')
    {
      angleChangeOn = !angleChangeOn;
      println("angleChangeOn: " + angleChangeOn);
      f.debug("angleChangeOn: " + angleChangeOn);
    }
  }
  
  void stop()
  {
  }
}

class ArcWorld extends World
{
  
  float storeThickness;
  float targetThickness;
  float currentThickness;
  
  float storeWidth;
  float targetWidth;
  float currentWidth;
  
  float storeRotationX;
  float targetRotationX;
  float currentRotationX;
  
  float storeRotationY;
  float targetRotationY;
  float currentRotationY;
  
  float growRotationX;
  float growRotationY;
  float growRotationX2;
  float growRotationY2;
  float growWidth;
  float growThickness;
  
  float thicknessLerpCounter;
  float widthLerpCounter;
  float rotationLerpCounter;
  float colorLerpCounter;
  float rotationLerpInc;
  
  boolean thicknessChangeOn;
  boolean widthChangeOn;
  boolean rotationChangeOn;
  boolean colorChangeOn;
  
  boolean shouldGrow;
  
  color currentColor;
  color storeColor;
  color targetColor;
  
  color currentGrowColor;
  color storeGrowColor;
  color targetGrowColor;
  
  color[] colorList = new color[0];
  
  void setup()
  {
    currentRotationX = 0;
    currentRotationY = 0;
    currentWidth = 500;
    currentThickness = 100;
    thicknessChangeOn = true;
    rotationChangeOn = true;
    widthChangeOn = true;
    colorChangeOn = true;
    
    thicknessLerpCounter = 0;
    widthLerpCounter = 0;
    rotationLerpCounter = 0;
    rotationLerpInc = 0.01;
    
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
    
    
    currentColor = color(255);
    currentGrowColor = color(0);
    
    helpText = "z-toggle Color Change\nx-toggle Thickness Change\nc-toggle Width Change\nv-toggle Rotation Change";
  }
  
  
  void draw()
  {
    
    beat.detect(input.mix);
    if (beat.isOnset() || beat.isKick())
    {
      changeThickness();
      changeWidth();
      changeColor();
      startGrow();
    }
    
    if (thicknessChangeOn == true)
    {
      if (thicknessLerpCounter <= 3)
      {
        thicknessLerpCounter += 1;
        if (currentThickness <= 100) currentThickness += 80*(input.mix.level()+volComp);
      }
      if (currentThickness >= 25) currentThickness -= 5;
    }
    if (widthChangeOn == true)
    {
      if (widthLerpCounter <= 4)
      {
        widthLerpCounter += 1;
        if (currentWidth <= 1500) currentWidth += 75*(input.mix.level()+volComp);
      }
      if (currentWidth >= 500) currentWidth -= 5;
    }
    if (rotationChangeOn == true)
    {
      rotationLerpCounter += rotationLerpInc;
      currentRotationX = lerp(storeRotationX,targetRotationX,rotationLerpCounter);
      currentRotationY = lerp(storeRotationY,targetRotationY,rotationLerpCounter);
      if (rotationLerpCounter >= 1) changeRotation();
    }
    if (colorChangeOn == true)
    {
      colorLerpCounter += 0.1;
      currentColor = lerpColor(storeColor,targetColor,colorLerpCounter);
      currentGrowColor = lerpColor(storeGrowColor,targetGrowColor,colorLerpCounter);
      if (colorLerpCounter >= 1) colorLerpCounter = 1;
    }
    
    ellipseMode(CENTER);
    translate(width/2,height/2);
    stroke(255);
    
    noFill();
    
    
    
    float randomInc = PI/96;
    growRotationX2+=randomInc;
    growRotationY2+=randomInc;
    growRotationX-=randomInc;
    growRotationY-=randomInc;
    if (shouldGrow == true)
    {
      
      //rotateX(-currentRotationX);
      //rotateY(-currentRotationY);
      rotateX(growRotationX);
      rotateY(growRotationY);
      strokeWeight(growThickness);
      arc(0,0,growWidth,growWidth,0,TWO_PI);
      if (growWidth >= 4500) shouldGrow = false;
      growWidth += 75;
      growThickness += 2;
      rotateX(growRotationX2);
      rotateY(growRotationY2);
      arc(0,0,growWidth,growWidth,0,TWO_PI);
    }
    
    strokeWeight(currentThickness);
    //rotateX(-growRotationX);
    //rotateY(-growRotationY);
    rotateX(currentRotationX-growRotationX-growRotationX2);
    rotateY(currentRotationY-growRotationY-growRotationY2);
    
    stroke(255);
    arc(0,0,currentWidth,currentWidth,0,TWO_PI);
    
  }
  
  void changeColor()
  {
    storeColor = currentColor;
    targetColor = colorList[int(random(0,colorList.length))];
    
    storeGrowColor = currentGrowColor;
    targetGrowColor = colorList[int(random(0,colorList.length))];
  }
  
  void changeRotation()
  {
    storeRotationX = currentRotationX;
    targetRotationX = random(0,TWO_PI);
    storeRotationY = currentRotationY;
    targetRotationY = random(0,TWO_PI);
    rotationLerpCounter = 0;
    rotationLerpInc = random(0.005, 0.025);
  }
  
  void changeWidth()
  {
     widthLerpCounter = 0;
  }
  
  void changeThickness()
  {
    thicknessLerpCounter = 0;
  }
  
  void startGrow()
  {
    growRotationX = currentRotationX;
    growRotationY = currentRotationY;
    growRotationX2 = currentRotationX / random(1,3);
    growRotationY2 = currentRotationY / random(1,3);
    growWidth = currentWidth/2;
    growThickness = currentThickness;
    shouldGrow = true;
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
      thicknessChangeOn = !thicknessChangeOn;
      println("thicknessChangeOn: " + thicknessChangeOn);
      f.debug("thicknessChangeOn: " + thicknessChangeOn);
    }
    else if (key == 'c')
    {
      widthChangeOn = !widthChangeOn;
      println("widthChangeOn: " + widthChangeOn);
      f.debug("widthChangeOn: " + widthChangeOn);
    }
    else if (key == 'v')
    {
      rotationChangeOn = !rotationChangeOn;
      println("rotationChangeOn: " + rotationChangeOn);
      f.debug("rotationChangeOn: " + rotationChangeOn);
    }
    
  }
  
}

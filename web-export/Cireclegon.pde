import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.ugens.*;

import promidi.*;
MidiIO midiIO;

color bgColor = color(0,0,0);

World currentWorld = new CircleWorld();

AudioInput input;
Minim minim;

void setup()
{
  //size(displayWidth,displayHeight,P3D);
  size(1366,768,P3D);
  background(bgColor);
  
  /*midiIO = MidiIO.getInstance(this);
  println("printPorts of midiIO");
  midiIO.printDevices();
  midiIO.openInput(0,0);*/
  currentWorld.setup();
  minim = new Minim(this);
  input = minim.getLineIn(Minim.MONO,512,44100);
}

boolean sketchFullScreen() 
{
  return true;
}

void draw()
{
  clear();
  currentWorld.draw();
}

void keyPressed()
{
  currentWorld.mouseClicked();
}
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
  BeatDetect beat;
  
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
    
    beat = new BeatDetect();
    beat.detectMode(beat.SOUND_ENERGY);
    beat.setSensitivity(200);
  }
  
  void draw()
  {
    beat.detect(input.mix);
    if (beat.isOnset())
    {
      triggerGrowth(input.mix.level());
      
      if (input.mix.level() < 0.3)
      {
        multiColor = false;
      }
      else
      {
        multiColor = true; 
      }
      
      if (input.mix.level() >= 0.5)
      {
        bgCircle.grow();
      }
      
    }
    println(input.mix.level());
    
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
    }
    else if (key == 'x')
    {
      multiColor = !multiColor;
    }
    else if (key == 'c')
    {
      colorFading = !colorFading;
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
    
    else
    {
      triggerGrowth(1);
    }
  }
}
class Entity
{
  
  void draw()
  {}
}
class IntroWorld extends World
{
  
  int x = width/2;
  int y = height/2;
  int i = 1;
  int j = 1;
  float b = 1;
  float k = 0.001;
  int p = 0;
  float r = 0;
  float g = 0;
  float bl = 0;
  
  boolean shouldGrow = false;
  
  PImage prevFrame;
  
  void setup()
  {
    x = width /2;
    y = height/2;
    background(200);
    prevFrame = createImage(width,height,RGB);
    drawFrame();
  }
  
  void draw()
  {
    prevFrame.loadPixels();
    pixels = prevFrame.pixels;
    updatePixels();
    
    if (shouldGrow == true)
    {
      drawFrame();
    }
    
    loadPixels();
    prevFrame.pixels = pixels;
    prevFrame.updatePixels();
  }
  
  void drawFrame()
  {
    b+=0.015*b;
    fill(r,g,bl);
    smooth();
   // background(random(0,255),random(0,255),random(0,255), 1);
    stroke(0,0);
    ellipse(x-i*b,y-k*b*b,16,16);
    ellipse(x+k*b*b,y-i*b,16,16);
    ellipse(x+i*b,y+k*b*b,16,16);
    ellipse(x-k*b*b,y+i*b,16,16);
    r+=0.01*random(0,16);
    g+=0.01*random(0,16);
    bl+=0.01*+random(0,16);
    if (x+k*b*b > 1366 || x+k*b*b < 0)
    {
      p+=1;
      b = 1;
      k+=0.001*p;
    }
  }
  
  void mouseClicked()
  {
    if (key == 'z')
    {
      shouldGrow = !shouldGrow;
    }
  }
  
}
class World
{
  
  color bgColor = color(0,0,0);
  
  void setup()
  {
    background(bgColor);
  }
  
  void draw()
  {}
  
  void mouseClicked()
  {}
}



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
  boolean firstFrame = true;
  
  PImage prevFrame;
  
  AudioPlayer player;
  
  float worldChangeTemp = 2;
  
  void setup()
  {
    x = width /2;
    y = height/2;
    prevFrame = createImage(width,height,RGB);
    drawFrame();
   // player = minim.loadFile("intro.wav",1024);
    
    i = 1;
    j = 1;
    b = 1;
    k = 0.001;
    p = 0;
    r = 0;
    g = 0;
    bl = 0;
  
    shouldGrow = false;
    
    firstFrame = true;
    
    helpText = "Right Click-Start Drawing";
    
    worldChangeTemp = worldChangeInterval;
    worldChangeInterval = 10000;
  }
  
  void draw()
  {
    if (firstFrame == false)
    {
      prevFrame.loadPixels();
      pixels = prevFrame.pixels;
      updatePixels();
    }
    else 
    {
      firstFrame = false;
      background(200);
      drawFrame();
    }
    
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
    if (mouseButton == RIGHT)
    {
      shouldGrow = !shouldGrow;
      println("is Drawing: " + shouldGrow);
      f.debug("is Drawing: " + shouldGrow);
      //if (player.isPlaying() == false)
     // {
        //player.rewind();
        //player.play();
      //}
    }
  }
  
  void stop()
  {
    //player.close();
    //minim.stop();
  }
  
  void clearWorld()
  {
    this.stop();
    worldChangeInterval = worldChangeTemp;
  }
  
}

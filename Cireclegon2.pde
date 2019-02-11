import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;




import java.awt.Frame;

import promidi.*;
MidiIO midiIO;

color bgColor = color(0,0,0);

World currentWorld = new IntroWorld();

AudioInput input;
Minim minim;

BeatDetect beat;
int energyMode = 0;

int onsetSensitivity = 200;
float mixLvlThreshold = 0.5;
float volComp = 0.4;

float worldChangeTimer = 0;
float worldChangeLastTime = 0;

float worldChangeInterval = 2;

public static int noOfShaders = 11;

public PFrame f;
secondApplet s;

void setup()
{
  size(displayWidth,displayHeight,P3D);
  //size(1366,768,P3D);
  frameRate(60);
  background(bgColor);
  noCursor(); 
  f = new PFrame();
  
  /*midiIO = MidiIO.getInstance(this);
  println("printPorts of midiIO");
  midiIO.printDevices();
  midiIO.openInput(0,0);*/
  
  minim = new Minim(this);
  input = minim.getLineIn();
  beat = new BeatDetect();
  beat.detectMode(beat.SOUND_ENERGY);
  beat.setSensitivity(onsetSensitivity);
  changeWorld(new IntroWorld());
}

boolean sketchFullScreen() 
{
  return true;
}

void draw()
{
  camera(width/2.0, height/2.0, (height/2.0) / tan(PI*30.0 / 180.0), width/2.0, height/2.0, 0, 0, 1, 0);
  clear();
  worldChangeTimer = float(millis()) / 1000 / 60;
  if (worldChangeTimer - worldChangeLastTime >= worldChangeInterval)
  {
    worldChangeLastTime = worldChangeTimer;
    randomWorld();
  }
  currentWorld.draw();
}

void mouseClicked()
{
  currentWorld.mouseClicked();
}

void keyPressed()
{
  currentWorld.mouseClicked();
  if (key == '1')
  {
    changeWorld(new IntroWorld());
  }
  else if (key == '2')
  {
    changeWorld(new ShaderWorld());
  }
  else if (key == '3')
  {
    changeWorld(new CircleWorld());
  }
  else if (key == '4')
  {
    changeWorld(new GridWorld());
  }
  else if (key == '5')
  {
    changeWorld(new RotSquareWorld());
  }
  else if (key == '6')
  {
    changeWorld(new ArcWorld());
  }
  else if (key == '7')
  {
    randomWorld();
  }
  
  if (key =='a')
  {
    reloadAudio();
  }
  else if (key == 's')
  {
    changeEnergyMode();
  }
  else if (key == 'd')
  {
    decreaseSensitivity();
  }
  else if (key == 'f')
  {
    increaseSensitivity();
  }
  else if (key == 'g')
  {
    decreaseMixLvlThreshold();
  }
  else if (key == 'h')
  {
    increaseMixLvlThreshold();
  }
  else if (key == 'j')
  {
    decreaseComp();
  }
  else if (key == 'k')
  {
    increaseComp();
  }
  else if (key == 'l')
  {
    println("vol lvl:" + input.mix.level());
    f.debug("vol lvl:" + input.mix.level());
  }
  
}

void randomWorld()
{
  int rand = int(random(0,3+noOfShaders+1));
  switch (rand)
  {
    case 0:
    changeWorld(new CircleWorld());
    break;
    case 1:
    changeWorld(new GridWorld());
    break;
    case 2:
    changeWorld(new RotSquareWorld());
    break;
    case 3:
    changeWorld(new ArcWorld());
    break;
    default:
    changeWorld(new ShaderWorld());
    break;
  }
}

void changeWorld(World newWorld)
{
  clear();
  currentWorld.clearWorld();
  currentWorld = newWorld;
  currentWorld.setup();
  f.changeText(currentWorld.helpText);
}

void stop()
{
  input.close();
  minim.stop();
  currentWorld.stop();
  super.stop();
}

void increaseSensitivity()
{
  onsetSensitivity += 10;
  beat.setSensitivity(onsetSensitivity);
  println("current Sensitivity: " + onsetSensitivity);
  f.debug("current Sensitivity: " + onsetSensitivity);
}

void decreaseSensitivity()
{
  onsetSensitivity -= 10;
  beat.setSensitivity(onsetSensitivity);
  println("current Sensitivity: " + onsetSensitivity);
  f.debug("current Sensitivity: " + onsetSensitivity);
}

void increaseMixLvlThreshold()
{
  mixLvlThreshold += 0.025;
  mixLvlThreshold = constrain(mixLvlThreshold,0,1);
  println ("current mixLvlThreshold: "+ mixLvlThreshold);
  f.debug("current mixLvlThreshold: "+ mixLvlThreshold);
}

void decreaseMixLvlThreshold()
{
  mixLvlThreshold -= 0.025;
  mixLvlThreshold = constrain(mixLvlThreshold,0,1);
  println ("current mixLvlThreshold: "+ mixLvlThreshold);
  f.debug("current mixLvlThreshold: "+ mixLvlThreshold);
}

void increaseComp()
{
  volComp += 0.025;
  println("currentCompensation: " + volComp);
  f.debug("currentCompensation: " + volComp);
}

void decreaseComp()
{
  volComp -= 0.025;
  println("currentCompensation: " + volComp);
  f.debug("currentCompensation: " + volComp);
}

void reloadAudio()
{
  /**input.close();
  minim.stop();
  minim = new Minim(this);
  input = minim.getLineIn(Minim.STEREO,512,44100);
  beat = new BeatDetect();
  if (energyMode == 0) beat.detectMode(beat.SOUND_ENERGY);
  else beat.detectMode(beat.FREQ_ENERGY);
  println("audio input reloaded");**/
}

void changeEnergyMode()
{
  if (energyMode == 0) energyMode = 1;
  else energyMode = 0;
  
  if (energyMode == 0) beat.detectMode(beat.SOUND_ENERGY);
  else beat.detectMode(beat.FREQ_ENERGY);
  if (energyMode == 0)
  {
    println("Switched to Sound Energy mode");
    f.debug("Switched to Sound Energy mode");
  }
  else 
  {
    println("Switched to Freq Energy mode");
    f.debug("Switched to Freq Energy mode");
  }
}


public class PFrame extends Frame {
    public PFrame() {
        setBounds(100,100,600,500);
        s = new secondApplet();
        add(s);
        s.init();
        show();
        s.draw();
    }
    
    public void changeText(String text)
    {
      s.text = text;
      s.draw();
    }
    public void debug(String debug)
    {
      s.debug = debug;
      s.draw();
    }
}
public class secondApplet extends PApplet {
  public String text = "";
  public String debug = "";
    public void setup() {
        size(600, 500);
       // noLoop();
    }
    public void draw() 
    {
      this.clear();
      text(
      "1-Intro,2-Shader,3-Circle,4-Grid,5-RotSqr,6-Arc,7-Rand\na-reloadAudio\ns-changeEnergyMode(Freq/Sound Energy)\nd-Sens-(Less is more sensitive)\nf-Sens+\ng-threshold-(threshold before beats trigger vis.)\nh-threshold+\nj-VolumeComp-\nk-VolumeComp+\nl-Print volume of current input buffer\n"
       + "\ncurrentWorld: " + currentWorld.toString() + "\n\n"
       + text
       + "\n\n"
       + debug
       +"\n\n"
       +"change time: " + str(worldChangeTimer - worldChangeLastTime)
       ,5,5,600,500);
    }
}

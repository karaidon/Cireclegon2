class Sqr3DWorld extends World
{

 float jCamInc = 0;
 float kCamInc = 0;
 float jCam = 0;
 float kCam = 0;
  
 void setup()
 {
 }
 
 void draw()
 {
   rectMode(CORNER);
   jCamInc = constrain(jCamInc,-200,200);
   kCamInc = constrain(kCamInc,-200,200);
   jCam = jCamInc*10;
   kCam = kCamInc*10;
   camera(jCam, 200, kCam, // eyeX, eyeY, eyeZ
         width/2, height/2, 0.0, // centerX, centerY, centerZ
         0.0, 1.0, 0.0); // upX, upY, upZ
   translate(width/2,height/2);
   box(500,500,0.1);
 }
  
 void mouseClicked()
 {
   //spherical rotation around center, pythagoras theorem
   if (key == 'z')
    {
      jCamInc+=5;
      kCamInc-=5;
    }
    else if (key == 'x')
    {
      jCamInc-=5;
      kCamInc+=5;
    }
    else if (key == 'c')
    {
      //angleChangeOn = !angleChangeOn;
      //println("angleChangeOn: " + angleChangeOn);
      //f.debug("angleChangeOn: " + angleChangeOn);
    }
 }
  
}

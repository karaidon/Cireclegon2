public class ShaderWorld extends World
{
  PShader shader;  
      
  Float beatF = 0.0;
  Float beatF2 = 1.0;
      
  void setup() {
    int shd = int(random(1,Cireclegon2.noOfShaders+1));
    println(shd);
    shader = loadShader("shader" + str(shd) + ".glsl");
    shader.set("resolution", float(width), float(height));

    helpText = "z-change Shader\nx-force Trigger";
  }
  
  void draw() {
    beat.detect(input.mix);
    if (beat.isOnset() || beat.isKick())
    {
       if (input.mix.level()+volComp >= mixLvlThreshold)
       {
         beatF = 1.0;
       }
    }
    if (beatF >= 0.0) beatF -=0.05;
    if (beatF <= 0.0001) beatF = 0.0001;
    shader.set("beat", beatF);
    shader.set("time", float(millis()));  
    shader.set("mouse", float(mouseX), float(mouseY));
    shader.set("resolution", float(width), float(height));
    translate(0,0,0);
    shader(shader);
    background(255);
    rectMode(CORNER);
    rect(0,0,width,height);
  }
  
  void mouseClicked()
  {
    if (key =='z')
    {
      int shd = int(random(1,Cireclegon2.noOfShaders+1));
      shader = loadShader("shader" + str(shd) + ".glsl");
      shader.set("resolution", float(width), float(height));
    }
    else if (key == 'x')
    {
      beatF = 1.0;
    }
  }
 
  void clearWorld()
  {
    resetShader();
  }
}

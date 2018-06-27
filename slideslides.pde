
PImage img;  // Declare variable "a" of type PImage
PImage img2;
boolean loading = false;

class SlidePic {
  float x = 0, y = 0, s = 0, fitScale = 0;
  float dX = 0, dY = 0, dS = 0;
  long endTime = 0;
  long nextTime = 0;
  long startTime = 0;
  PImage img = null;
 
  
  void randomizeStart(String path) {
    if (img != null)
      g.removeCache(img);
      
    img = loadImage(path);
    //x = random(-img.width, img.width);
    //y = random(-img.height, img.height);
    float scaleX, scaleY;
    if (height > img.height) {
      scaleX = width / (float)img.width;
      scaleY = height / (float)img.height;
    } else {
      scaleX = img.width / (float)width;
      scaleY = img.height / (float)height;
    }
    x = random(-width/1.2, width/1.2);
    y = random(-height/1.2, height/1.2);
    if (scaleX < scaleY) {
      fitScale = scaleX; 
      s = random(scaleX / 6, scaleY * 3);
    } else {
      fitScale = scaleY;
      s = random(scaleY / 6, scaleX * 3);
    }
    //println(fitScale);
    //println(s);
    println("x:" +width + ", y:" + height);
  }
  
  void setTarget(float rate, float seconds) {
    dX = -x / (rate * seconds);
    dY = -y / (rate * seconds);
    dS = (fitScale - s) / (rate * seconds);
    startTime = System.currentTimeMillis();
    endTime = startTime + (long)(seconds * 1000);
    nextTime = endTime + (long)((seconds - 2) * 1000); 
  }
  
  void tick(long time) {
    long dSec = time - startTime;
    float x1 = (dSec - 3000) / 2000.0;
    float speedCurve = x1*x1 + 1;
    x += dX * speedCurve;
    y += dY * speedCurve;
    s += dS * speedCurve;
    if (s < 0) s = 0; 
  }
  
  int fade(long time) {
    long dTime = time - startTime;
    if (dTime < 1000) {
      return (int)(255 * (dTime / 1000.0));
    }
    dTime = endTime - time;
    if (dTime < 1000) {
      return (int)(255 * (dTime / 1000.0));
    }
    return 255;
  }
}

SlidePic sp1 = null;
SlidePic sp2 = null;
void setup() {
  size(800, 600, P3D);
  //size(800,600);
  //fullScreen(P3D);
  frameRate(30);
  noCursor();
  // The image file must be in the data folder of the current sketch 
  // to load successfully
  sp1 = new SlidePic();
  sp2 = new SlidePic();
  sp2.nextTime = System.currentTimeMillis() + 4000;
}

void draw() {
  long cTime = System.currentTimeMillis();
  if (cTime >= sp1.nextTime) {
    if (!loading) {
      loading = true;
      thread("loadSp1");
    }
  }

  if (cTime >= sp2.nextTime) {
    if (!loading) {
      loading = true;
      thread("loadSp2");
    }
  }
   
  background(0);
  
  if (cTime <= sp1.endTime) {
    pushMatrix();
    sp1.tick(cTime);
    // Displays the image at its actual size at point (0,0)
   translate(sp1.x, sp1.y);
   scale(sp1.s);
   tint(255, sp1.fade(cTime));  
   image(sp1.img, 0, 0);
   popMatrix();
  }
 
 if (cTime <= sp2.endTime) {
   pushMatrix();
   sp2.tick(cTime);
   translate(sp2.x, sp2.y);
   scale(sp2.s);
   tint(255, sp2.fade(cTime));  
   image(sp2.img, 0, 0);
   popMatrix();
 }
 hint(DISABLE_DEPTH_TEST);
//rotateX(PI * sin(count/118.0));
//rotateY(PI* sin(count/118.0));
//rotateZ(PI * sin(count/118.0));
  //image(img2, 0, 0, img2.width/(frameCount*0.5), img2.height/(frameCount*0.5));
  //filter(BLUR, 60 * sin(count/118.0));
  //filter(BLUR,count);
  // Displays the image at point (0, height/2) at half of its size
  //image(img, 0, height/2, img.width/2, img.height/2);
}

String basePath = ".";

void loadSp1() {
      // load next slide
    sp1.randomizeStart(basePath + "/Unicorn" + (int)random(1, 12) + ".jpg");
    sp1.setTarget(frameRate, 6.0);
    loading = false;
}

void loadSp2() {
      // load next slide
    sp2.randomizeStart(basePath + "/Unicorn" + (int)random(1, 12) + ".jpg");
    sp2.setTarget(frameRate, 6.0);
    loading = false;
}

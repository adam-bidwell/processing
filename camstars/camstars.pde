import processing.video.*;

Capture video;
PImage prevFrame;
int SRC_WIDTH = 640;
int SRC_HEIGHT = 480;
int MAX_STARS = 40;
int MAX_SPEED = 10;
float GRAVITY = 0.9;
float BOUNCE_MODIFIER = -0.2;
float INIT_SCALE = 0.8;
float HUE_INCREMENT = 31;
int STAR_THRESHOLD = 200;
int BLUR_THRESHOLD = 50;
int DOT_SIZE = 12;
float X_SCALE;
float Y_SCALE;
boolean starsOn = false;

int current_star = 0;
int hue = 0;
Star[] stars;
float lastX = mouseX;

boolean sketchFullScreen() {
  return true;
}

void setup() {
  size(displayWidth, displayHeight, P3D);
  X_SCALE = displayWidth / SRC_WIDTH;
  Y_SCALE = X_SCALE; //displayHeight / SRC_HEIGHT;

  String[] cameras = Capture.list();
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    video = new Capture(this, cameras[0]);
    video.start();
  }      

  prevFrame = createImage(SRC_WIDTH, SRC_HEIGHT,RGB);

  stars = new Star[MAX_STARS];
  for (int s = 0; s < stars.length; s ++) {
    stars[s] = new Star();
  }
  
  frameRate(10);
}

void draw() {
  background(0);
  
  if (video.available()) {
    prevFrame.copy(video, 0, 0, SRC_WIDTH, SRC_HEIGHT, 0, 0, SRC_WIDTH, SRC_HEIGHT);
    prevFrame.updatePixels();
    video.read();
    video.filter(BLUR, 1);
  }
  
  PImage temp = video.get(0, 0, SRC_WIDTH, SRC_HEIGHT);
  temp.resize(displayWidth, 0);
  image(temp, 0, 0);
  
  loadPixels();
  video.loadPixels();
  
  prevFrame.loadPixels();
  for (int y = 0; y < SRC_HEIGHT; y ++) {
    for (int x = 0; x < SRC_WIDTH; x ++) {
      int i = x + (y * SRC_WIDTH);
      
      if (i >= prevFrame.pixels.length || i >= video.pixels.length) continue;

      color current = video.pixels[i];
      color previous = prevFrame.pixels[i];
      
      float r1 = red(current); 
      float g1 = green(current);
      float b1 = blue(current);
      float r2 = red(previous); 
      float g2 = green(previous);
      float b2 = blue(previous);
      
      float diff = dist(r1,g1,b1,r2,g2,b2);
      if (diff > BLUR_THRESHOLD) {
        smooth();
        noStroke();
        fill(r1, g1, b1);
        ellipse(x * X_SCALE, y * Y_SCALE, DOT_SIZE, DOT_SIZE);
      }

      if (starsOn) {
        if (diff > STAR_THRESHOLD && (int)abs(random(0, 10)) == 1) {
          for (int s = 0; s < MAX_STARS; s ++) {
            if (stars[s].isFaded()) {
              stars[s] = new Star(color(100, 100, 100, 50), (int) abs(x * X_SCALE), (int) abs(y * Y_SCALE), random(0,4)-2);
              break;
            }
          }
        }
      }
    }
  }

  // if the star isn't faded, update the physics/position and draw it
  for (int s = 0; s < stars.length; s ++) {
    if (!stars[s].isFaded()) {
      stars[s].update();
      stars[s].display();
    }
  }
}

void mouseReleased() {
  starsOn = !starsOn;
  println((starsOn ? "STARS!" : "NO STARS"));
}

class Star {

  PShape s;
  float x, y;
  boolean faded;
  float speed, direction;
  color hue;

  Star() {
    this.faded = true;
  }

  Star(color hue, int x, int y, float direction) {
    this.hue = hue;
    this.s = createShape();
    this.s.beginShape();
    this.s.vertex(0, -50);
    this.s.vertex(14, -20);
    this.s.vertex(47, -15);
    this.s.vertex(23, 7);
    this.s.vertex(29, 40);
    this.s.vertex(0, 25);
    this.s.vertex(-29, 40);
    this.s.vertex(-23, 7);
    this.s.vertex(-47, -15);
    this.s.vertex(-14, -20);
    this.s.endShape(CLOSE);

    this.s.scale(INIT_SCALE);
    this.x = x - ((this.s.width * INIT_SCALE) / 2);
    this.y = y - ((this.s.height * INIT_SCALE) / 2);
    this.faded = false;
    this.speed = random(MAX_SPEED) - (MAX_SPEED / 2);
    this.direction = direction;
  }
  
  boolean isFaded() {
    return this.faded;
  }
  
  void update() {
    if (!this.isFaded()) {
      this.y = this.y + this.speed;
      this.x += this.direction;
      this.speed = this.speed + GRAVITY;
      
      if (this.y > height - (this.s.height / 2)) {
        this.speed = this.speed * BOUNCE_MODIFIER;
        if (this.speed > -0.45 && this.speed < 0) {
          this.faded = true;
        }
      }
      
      if (this.x < 0 - this.s.width) this.faded = true;
      if (this.y > width) this.faded = true;
    }
  }

  void display() {
    fill(this.hue);
    stroke(this.hue);
    strokeWeight(8);
    shape(this.s, this.x, this.y);
  }
}

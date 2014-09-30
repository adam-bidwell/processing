// maximum stars on screen at once (once a star is off the edges, it immediately
// "fades", so this could be a lot lower if performance is an issue
int MAX_STARS = 2000;

// maximum speed the star can be emitted
int MAX_SPEED = 10;

// gravity constant
float GRAVITY = 0.1;

// rate that the bounce deteriorates the speed
float BOUNCE_MODIFIER = -0.75;

// star size
float INIT_SCALE = 0.6;

// increment to hue on each button press
float HUE_INCREMENT = 31;

// general init values
int current_star = 0;
int hue = 0;
Star[] stars;
float lastX = mouseX;

// go fullscreen
boolean sketchFullScreen() {
  return true;
}

// setup the screen
void setup() {
  // we're going to use 360 degree hue and percentages for saturation and brightness
  colorMode(HSB, 360, 100, 100);
  
  // screensize is max for fullscreen
  size(displayWidth,displayHeight,P3D);
  
  // initialise the star objets
  stars = new Star[MAX_STARS];
  for (int s = 0; s < stars.length; s ++) {
    stars[s] = new Star();
  }
}

void draw() {
  // clear the background each frame
  background(200,80,20);

  // if the star isn't faded, update the physics/position and draw it
  for (int s = 0; s < stars.length; s ++) {
    if (!stars[s].isFaded()) {
      stars[s].update();
      stars[s].display();
    }
  }
}

void mousePressed() {
  // increment the colour value
  hue += HUE_INCREMENT;
  while (hue >= 360) hue -= 360;
}

void mouseDragged() {
  // when the mouse is being dragged, emit stars
  for (int s = 0; s < MAX_STARS; s ++) {
    if (stars[s].isFaded()) {
      // find the first 'faded' star in the queue
      // reset it and fire it off in the opposite direction to the drag
      float direction = lastX - mouseX;
      stars[s] = new Star(hue, mouseX, mouseY, direction);
      break;
    }
  }
  
  lastX = mouseX;
}

class Star {

  PShape s;
  float x, y;
  boolean faded;
  float speed, direction, hue;

  Star() {
    this.faded = true;
  }

  Star(float hue, int x, int y, float direction) {
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
    fill(this.hue, 80, 80, 70);
    stroke(this.hue, 100, 90, 70);
    strokeWeight(8);
    shape(this.s, this.x, this.y);
  }
}

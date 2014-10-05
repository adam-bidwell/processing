import processing.video.*;

// some globals we'll use later
Capture cam;
PImage overlay;
PImage puzzle;

// flip to fullscreen
boolean sketchFullScreen() {
  return true;
}

void setup() {
  size(displayWidth, displayHeight);
  
  // load the overlay image
  overlay = loadImage("jigsaw-overlay.png");
  if (overlay == null) {
    println("You'll need a file in the sketch folder, called jigsaw-overlay.png");
    exit();
  } else {
    // get the camera list
    String[] cameras = Capture.list();
    if (cameras.length == 0) {
      println("There are no cameras available for capture.");
      exit();
    } else {
      println("Available cameras:");
      for (int i = 0; i < cameras.length; i++) {
        println(cameras[i]);
      }
      
      // we're just going to take the first one in the list
      cam = new Capture(this, cameras[0]);
      cam.start();
    }      
  }
}

void draw() {
  // make sure camera is ready 
  if (cam.available() == true) {
    cam.read();
  }
  
  // get the camera image
  puzzle = cam.get(0, 0, 640, 480);
  
  // apply an effect
  puzzle.filter(BLUR, 6);
  puzzle.filter(POSTERIZE, 10);
  
  // scale it to screen width, and height in aspect ratio
  puzzle.resize(displayWidth, 0);
  
  // draw it on screen
  image(puzzle, 0, 0);
  
  // overlay the puzzle pattern
  for (int x = 0; x < (int) abs(displayWidth / overlay.width) + 1; x ++) {
    for (int y = 0; y < (int) abs(displayHeight / overlay.height) + 1; y ++) {
      image(overlay, x * overlay.width, y * overlay.height);
    }
  }
}

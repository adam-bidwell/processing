import processing.video.*;

Capture cam;

PImage overlay;
PImage puzzle;

void setup() {
  size(1280, 960);

  String[] cameras = Capture.list();
  
  overlay = loadImage("jigsaw-overlay.png");
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }
    
    // The camera can be initialized directly using an 
    // element from the array returned by list():
    cam = new Capture(this, cameras[0]);
    cam.start();     
  }      
}

void draw() {
  if (cam.available() == true) {
    cam.read();
  }
  
  puzzle = cam.get(0, 0, 640, 480);
  puzzle.filter(BLUR, 6);
  puzzle.filter(POSTERIZE, 10);
  puzzle.resize(1280, 960);
  image(puzzle, 0, 0);
  for (int x = 0; x < 4; x ++) {
    for (int y = 0; y < 4; y ++) {
      image(overlay, x * 340, y * 255);
    }
  }
  // The following does the same, and is faster when just drawing the image
  // without any additional resizing, transformations, or tint.
  //set(0, 0, cam);
}

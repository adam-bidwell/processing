import processing.video.*;

int CAM_TO_USE = 13;
int CELL_SIZE = 4;
Capture cam;
PImage img;
float[][][] kernel = {
                   {{ -1, -1, -1}, 
                    { -1,  9, -1}, 
                    { -1, -1, -1}},
                   {{ -1, -1, -1}, 
                    { -1,  9, -1}, 
                    { -1, -1, -1}},
                   {{ -1, -1, -1}, 
                    { -1,  9, -1}, 
                    { -1, -1, -1}}
};

float rstep = 1, gstep = 1, bstep = 1;
int blur = 8, posterize = 16;

// fullscreen by default
boolean sketchFullScreen() {
  return true;
}

void setup() {
  size(displayWidth, displayHeight, P3D);

  String[] cameras = Capture.list();
  
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(i + " " + cameras[i]);
    }
    
    // we'll initialise camera 13, you could pick any from the list that are suitable
    cam = new Capture(this, cameras[CAM_TO_USE]);
    cam.start();     
  }      
  frameRate(5);
}

void draw() {
  if (cam.available() == true) {
    cam.read();
  }
  
  noStroke();
  img = cam.get(0, 0, cam.width, cam.height);

  img.filter(BLUR, blur);
  img.filter(POSTERIZE, posterize);

  img.loadPixels();

  for (int y = 1; y < img.height-1; y+= CELL_SIZE) { // Skip top and bottom edges
    for (int x = 1; x < img.width-1; x+= CELL_SIZE) { // Skip left and right edges
      float rsum = 0, gsum = 0, bsum = 0; // Kernel sum for this pixel
      for (int ky = -1; ky <= 1; ky++) {
        for (int kx = -1; kx <= 1; kx++) {
          // Calculate the adjacent pixel for this kernel point
          int pos = (y + ky)*img.width + (x + kx);
          
          float rval = red(img.pixels[pos]);
          float gval = green(img.pixels[pos]);
          float bval = blue(img.pixels[pos]);

          // Multiply adjacent pixels based on the kernel values
          rsum += kernel[0][ky+1][kx+1] * rval * rstep;
          gsum += kernel[1][ky+1][kx+1] * gval * gstep;
          bsum += kernel[2][ky+1][kx+1] * bval * bstep;
        }
      }
      
      fill(rsum, gsum, bsum);
      rect(x, y, CELL_SIZE, CELL_SIZE);
    }
  }
}

void keyPressed() {
  switch (key) {
    case ' ':
      saveFrame("ss-####.png");
      break;
    case 'q':
      rstep -= 0.1;
      break;
    case 'a':
      rstep += 0.1;
      break;
    case 'w':
      gstep -= 0.1;
      break;
    case 's':
      gstep += 0.1;
      break;
    case 'e':
      bstep -= 0.1;
      break;
    case 'd':
      bstep += 0.1;
      break;
    case 'r':
      blur --;
      break;
    case 'f':
      blur ++;
      break;
    case 't':
      posterize --;
      break;
    case 'g':
      posterize ++;
      break;
    default:
      break;
  }
}



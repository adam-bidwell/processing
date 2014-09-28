import processing.video.*;

Capture cam;

PImage overlay;
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
int blur = 8, posterize = 8;

boolean sketchFullScreen() {
  return true;
}

void setup() {
  size(displayWidth, displayHeight, P3D);

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
  
  img = cam.get(0, 0, 640, 480);
  img.filter(BLUR, blur);
  img.filter(POSTERIZE, posterize);

  img.loadPixels();

  // Create an opaque image of the same size as the original
  PImage edgeImg = createImage(img.width, img.height, RGB);
  // Loop through every pixel in the image.
  for (int y = 1; y < img.height-1; y++) { // Skip top and bottom edges
    for (int x = 1; x < img.width-1; x++) { // Skip left and right edges
      float rsum = 0, gsum = 0, bsum = 0; // Kernel sum for this pixel
      for (int ky = -1; ky <= 1; ky++) {
        for (int kx = -1; kx <= 1; kx++) {
          // Calculate the adjacent pixel for this kernel point
          int pos = (y + ky)*img.width + (x + kx);
          
          float x_distance = (x - mouseX);
          if (x_distance == 0) x_distance = 0.001;
          float distance = atan(1-(y - mouseY) / x_distance);

          float rval = red(img.pixels[pos]);
          float gval = green(img.pixels[pos]);
          float bval = blue(img.pixels[pos]);

          // Multiply adjacent pixels based on the kernel values
          rsum += kernel[0][ky+1][kx+1] * rval * rstep * distance;
          gsum += kernel[1][ky+1][kx+1] * gval * gstep * distance;
          bsum += kernel[2][ky+1][kx+1] * bval * bstep * distance;
        }
      }
      // For this pixel in the new image, set the gray value
      // based on the sum from the kernel
      edgeImg.pixels[y*img.width + x] = color(rsum, gsum, bsum);
    }
  }
  // State that there are changes to edgeImg.pixels[]
  edgeImg.updatePixels();
//  image(edgeImg, width/2, 0); // Draw the new image
 
  edgeImg.resize(displayWidth, displayHeight);
  image(edgeImg, 0, 0);
  
//  System.out.printf ("%.1f, %.1f, %.1f, %d, %d", rstep, gstep, bstep, blur, posterize);
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



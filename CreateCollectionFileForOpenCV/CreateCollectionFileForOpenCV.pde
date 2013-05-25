/*
CREATE COLLECTION FILE FOR OpenCV
 Jeff Thompson | 2012 | www.jeffreythompson.org
 
 A utillity to prepare a "collection file" for training the OpenCV*** library to find
 objects based on positive images (with the object).  Essentially, the collection file
 includes the path to each image, the # of objects in the image (here we default to 1)
 and the coordinates of a rectangle containing the object (x,y and width,height).
 
 *** 
 Not to be confused with Processing's port of the OpenCV library, the full version
 must be installed via the command-line.  This install includes all features, including
 a few extra tools accessible only via the command-line.
 
 For instructions on installing OpenCV for Mac, see:
 http://www.jeffreythompson.org/blog/2012/09/21/installing-opencv-for-python-on-mac-lion
 
 TO USE:
 1. All files should be in a single folder (specified when the sketch launches) in png 
 or jpg format and no larger than about 1MB
 2. The images will open one-by-one; click and drag to define the object and hit
 spacebar to save and proceed to the next
 3. To skip ahead or back hit the arrow keys; to select all of the image and go to the
 next hit enter/return
 4. The resulting text file will be saved automatically on exit
 
 At the moment, saving the file will overwrite an existing file - sorry!
 
 */

boolean crosshairs = true;         // show large crosshairs?
boolean showInstructions = true;   // display instructions onscreen?
int bigStep = 10;                  // up-down arrow keys jump N images

PImage img;                         // variable to load image into
String pathToDirectory = "";        // store the full path to the image file folder
String[] images = new String[0];    // array of all images in directory
int whichImage, numImages;          // keep track of the number of images
PrintWriter output;                 // to write to text file
int startX, startY, w, h;           // bounding box values
boolean done = false;               // all images reached?
int numStored = 0;                  // how many bounding boxes (objects) stored?
PFont font;                         // font from data folder

void setup() {

  // basic setup stuff
  size(640, 480);
  smooth();
  noStroke();
  textAlign(LEFT, CENTER);
  font = loadFont("Helvetica-64.vlw");
  cursor(CROSS);
  frame.setTitle("Create Collectoin File For OpenCV");
  
  // box starts offscreen (so it doesn't show up before we've made a selection)
  startX = startY = -10;
  
  // print instructions
  println("spacebar = save selection  |  return/enter = save entire image  |  L/R arrow = skip (U/D = skip " + bigStep + ")");

  // prepare exit handler so the file saves when we quit
  prepareExitHandler();

  // open a directory of images (also creates PrintWriter for output to text file)
  selectFolder("Choose image folder...", "openDirectory");
}

void draw() {

  // gray background when no image is loaded
  background(150);
  stroke(0);
  line(0, 0, width, height);
  line(0, height, width, 0);
  noStroke();

  // so long as we're not past the last image...
  if (!done) {

    // display the current image if loaded
    if (img != null) {
      image(img, 0, 0);
    }

    // draw bounding box
    if (startX >= 0) {
      noFill();
      strokeWeight(1);
      stroke(0);
      rect(startX, startY, w, h);
      stroke(255);
      rect(startX+1, startY+1, w-2, h-2);
      noStroke();
    }

    // display instructions as an overlay, if specified
    if (showInstructions) {
      fill(0, 200);
      rect(0, height-65, width, 65);
      fill(255);
      text("spacebar = save selection  |  enter = save entire image  |  L/R arrow = skip (U/D = skip " + bigStep + ")\n\ncurrent: " + (whichImage+1) + "/" + numImages, 20, height-35);
    }

    // crosshairs for easier editing
    if (crosshairs) {
      stroke(0, 100);
      line(0, mouseY, width, mouseY);
      line(mouseX, 0, mouseX, height);
      stroke(255, 100);
      line(0, mouseY-1, width, mouseY-1);
      line(mouseX+1, 0, mouseX+1, height);
      noStroke();
    }
  }

  // after the last image, show that we're finished and the # of images recorded
  // the last step is useful for the command-line arguments needed later
  else {
    if (width < 640 || height < 480) {
      frame.setSize(640, 480);
    }
    background(150);
    fill(255);
    textFont(font, 64);
    text("ALL DONE!", width/2, height/2 - 30);
    textFont(font, 28);
    text("# of objects stored: " + numStored, width/2, height/2 + 30);
  }
}

// mouse click starts the object bounding-box; drag to define size
void mousePressed() {
  startX = mouseX;
  startY = mouseY;
  w = 0;
  h = 0;
}
void mouseDragged() {
  w = constrain(mouseX - startX, 1, width-startX);    // keep size from going offscreen
  h = constrain(mouseY - startY, 1, height-startY);
}

// L/R arrow keys move image without storing by 1, up/down by 10
// spacebar stores and moves ahead
// enter/return selects the entire image and moves ahead
void keyPressed() {
  if (key == CODED) {
    if (keyCode == RIGHT && whichImage < numImages-(bigStep+1)) {
      nextImage(1);
    }
    else if (keyCode == UP && whichImage < numImages-1) {
      nextImage(bigStep);
    }
    else if (keyCode == LEFT && whichImage > 1) {
      previousImage(1);
    }
    else if (keyCode == DOWN && whichImage > bigStep+1) {
      previousImage(bigStep);
    }
  }
  else if (key == 32) {
    numStored++;
    saveDetails();
  }
  else if (key == RETURN || key == ENTER) {
    startX = 0;
    startY = 0;
    w = img.width;
    h = img.height;
    saveDetails();    // save and go to next image
  }
}


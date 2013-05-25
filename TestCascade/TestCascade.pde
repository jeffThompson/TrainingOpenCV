import hypermedia.video.*;
import java.awt.Rectangle;

/*
TEST CASCADE
Jeff Thompson | 2012 | www.jeffreythompson.org

A simple utility to test our newly-made cascade file - we load
an image and should get a bounding-box around it!

Requires the OpenCV library and an additional install, see:
http://ubaa.net/shared/processing/opencv

NOTE: if you have installed OpenCV 2, this may not work - try the
Python script 'TestCascade.py' instead.
*/

// test face using known cascade to make sure our code works
// String imageFilename = "face.jpg";
// String cascadeFilename = "frontalface.xml";

// test our new cascade file!
String imageFilename = "test.jpg";
String cascadeFilename = "cascade.xml";

OpenCV cv;
PImage img;

void setup() {
  
  // load image
  img = loadImage(imageFilename);
  size(img.width, img.height);
  image(img, 0,0);
  
  // setup OpenCV
  cv = new OpenCV(this);
  cv.allocate(img.width, img.height);
  cv.copy(img.pixels, img.width, 0,0, img.width, img.height, 0,0, img.width, img.height);
  cv.cascade(sketchPath("") + cascadeFilename);
  cv.convert(GRAY);
  
  // run detection!
  Rectangle[] found = cv.detect(1.2, 2, OpenCV.HAAR_DO_CANNY_PRUNING, 60,60);
  println("Found objects: " + found.length);
  
  // draw rectangle around found objects
  stroke(255);
  noFill();
  for (Rectangle f : found) {
    rect(f.x, f.y, f.width, f.height);
  }
}

// be nice and close CV on exit
public void stop() {
  cv.stop();
  super.stop();
}

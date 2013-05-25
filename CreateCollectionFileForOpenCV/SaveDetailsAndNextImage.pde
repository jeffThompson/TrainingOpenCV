
void saveDetails() {
  // image path #numObjects(1) startX startY width height
  output.println(images[whichImage] + " 1 " + startX + " " + startY + " " + w + " " + h);

  // update bounding box variables
  startX = -10;    // offscreen will not be shown
  startY = -10;
  w = 0;
  h = 0;

  // if we're not at the last image, go to the next
  if (whichImage < numImages-1) {
    nextImage(1);
  }
  // otherwise, display the "done" screen
  else {
    done = true;
  }
}

// get the next image
void nextImage(int step) {
  whichImage += step;                      // increment
  img = loadImage(images[whichImage]);     // load
  
  // unlock window size, change, lock again
  frame.setResizable(true);
  frame.setSize(img.width, img.height);
  frame.setResizable(false);
  
  // set title of window to the name of the current file
  String[] splitPath = split(images[whichImage], '/');
  frame.setTitle(splitPath[splitPath.length-1]);
}

// get previous image
void previousImage(int step) {
  whichImage -= step;                      // go back by x
  img = loadImage(images[whichImage]);     // load
  
  // unlock window size, change, lock again
  frame.setResizable(true);
  frame.setSize(img.width, img.height);
  frame.setResizable(false);
  
  // set title of window to the name of the current file
  String[] splitPath = split(images[whichImage], '/');
  frame.setTitle(splitPath[splitPath.length-1]);
}


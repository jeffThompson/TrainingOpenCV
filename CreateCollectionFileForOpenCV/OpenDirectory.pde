
// not the best or cleanest method (better would be to use Java's FilenameFilter) but
// we're keeping things easy and clean...

// fancier? try:
// http://www.devdaily.com/blog/post/java/how-implement-java-filefilter-list-files-directory

void openDirectory(File f) {
  
  // setup text file output
  output = createWriter(sketchPath("") + f.getName() + "_Collection.txt");
  
  // get all files
  pathToDirectory = f.getAbsolutePath();
  String[] files = new String[0];
  if (f != null && f.isDirectory()) {
    files = f.list();
  }

  // run through, ignoring non-image files (png and jpeg only)
  for (int i=0; i<files.length; i++) {
    String[] extension = match(files[i], "\\.(png|jpg|jpeg)");
    if (extension != null) {
      images = append(images, pathToDirectory + "/" + files[i]);
    }
  }
  // println(images);

  // load the first image
  whichImage = 0;
  numImages = images.length;
  img = loadImage(images[0]);
  
  // unlock window size, change, lock again
  frame.setResizable(true);
  frame.setSize(img.width, img.height);
  frame.setResizable(false);
  
  // set title of window to the name of the current file
  String[] splitPath = split(images[whichImage], '/');
  frame.setTitle(splitPath[splitPath.length-1]);
}

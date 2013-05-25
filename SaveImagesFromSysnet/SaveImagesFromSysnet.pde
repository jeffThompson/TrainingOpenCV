/*
SAVE IMAGES FROM SYSNET
Jeff Thompson | 2012 | www.jeffreythompson.org

A utility to download 1000s of images from Sysnet for
computer vision training:
http://www.image-net.org/search?q=computer

Files are available as a list of external URLs, making
the lists great for finding source files for computer vision.

Also skips any URL that results in the Flickr "no image found" error.
*/

// read an external text file of URLs
String filename = "desk.txt";
// String filename = "livingRoom.txt";

void setup() {

  // load the link URLs into a string array using the Processing method (easier)
  String[] links = loadStrings(filename);
  println("Loaded a total of " + links.length + " links, download will start now...\n");

  // download everylink, save the image to a png file
  int numLinks = links.length;
  for (int count=0; count<links.length; count++) {

    // download the image
    println((count+1) + "/" + numLinks + ": " + links[count]);    // let us know how we're doing
    PImage img = loadImage(links[count]);                         // download the file

    // run everything in a try in case of download errors
    try {
      boolean allWhite = true;                   // set flag to true
      img.loadPixels();                          // load the downloaded image's pixels

      // check if the image is the default Flickr "no image found" image
      for (int i=0; i<100; i++) {                // test the first 2 rows

        // if any pixels are NOT white, well then we're not reading the Flickr image...
        int r = int(red(img.pixels[i]));
        int g = int(green(img.pixels[i]));
        int b = int(blue(img.pixels[i]));

        // Flickr image starts with lots of rgb(204,204,204) values
        if (r != 204 && g != 204 && b != 204) {
          allWhite = false;
          continue;
        }
      }

      // if the image isn't the Flickr default, save it!
      if (!allWhite) {
        img.save("downloadedImages/" + nf((count+1), 4) + ".png");    // save as png file w/ 4 leading zeros
      }
    }

    // any errors, let us know but continue regardless
    catch (Exception e) {
      println("  error, file skipped (" + e + ")");
    }
  }

  // all done, quit
  println("\nFINISHED!");
  exit();
}


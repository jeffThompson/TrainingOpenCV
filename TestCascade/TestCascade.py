# TEST CASCADE
# Jeff Thompson | 2012 | www.jeffreythompson.org
#
# A simple utility to test our newly-made cascade file - we load
# an image and should get a bounding-box around it!

#import library - MUST use cv2 if using opencv_traincascade
import cv2

def rgb(r,g,b):				# OpenCV wants colors as BGR not RGB - weird
	return (b,g,r)			# flip the color order

# rectangle color and stroke
strokeColor = rgb(255,0,0)	# outline color (using rgb function)
strokeWeight = 1			# thickness of outline

# set window name
windowName = "Object Detection"

# load an image to search for objects
#img = cv2.imread("face.jpg")
img = cv2.imread("../PositiveImageFiles-Original/01.jpg")
# couldn't read (from only 1 +file trans 100x): 16, 2, 3 (sees a false +), 4, 7, 8, 9

# load detection file (various files for different views and uses)
#cascade = cv2.CascadeClassifier("frontalface.xml")
cascade = cv2.CascadeClassifier("cascade.xml")

# preprocessing - not needed but suggested by:
# http://www.bytefish.de/wiki/opencv/object_detection
grayImg = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)		# convert to grayscale
grayImg = cv2.equalizeHist(grayImg)					# normalize bright, increase contrast

# detect objects, return as list of rectangles (x,y of upper-left corner, width/height)
# detection is done on the preprocessed grayscale copy created in previous step
rects = cascade.detectMultiScale(grayImg)

# display until escape key is hit
while True:

	# draw all rectangles
	for x,y, width,height in rects:
		cv2.rectangle(img, (x,y), (x+width, y+height), strokeColor, strokeWeight)
	
	# display the image!
	cv2.imshow(windowName, img)
	
	# escape key (ASCII 27) closes window
	if cv2.waitKey(20) == 27:
		break

# if esc key is hit, quit!
exit()
import imutils
from imutils import paths
import face_recognition
import pickle
import cv2
import os
import io
import base64
import imageio
import pymongo
from pymongo import MongoClient
import certifi
from bson.binary import Binary

import sys

# Sets variables equivalent to parameters 1, 2
col = sys.argv[1]
col1 = sys.argv[2]

# Sets x equal to a document in the collection
x = col.find_one()

# Variable Declaration
kEncodings = []
kNames = []
record = []

# Grabs the name from the db document
name = x["Name"]

# Grabs the base64 string from the document
imgString = x["Pic"]

# Converts the base 64 string into an image (ndarray)
image = imageio.imread(io.BytesIO(base64.b64decode(imgString)))

# Creates the cv2 image for facial recognition
rgb = cv2.cvtColor(image, cv2.COLOR_RGB2BGR)

# Shows the image that was grabbed
cv2.imshow("pic", rgb)
cv2.waitKey(0)
cv2.destroyAllWindows() 

# Determines the location of faces in the image
boxes = face_recognition.face_locations(rgb,model='hog')

# Creates encodings for all of the ffaces that were found in the image
encodings = face_recognition.face_encodings(rgb, boxes)

#save encodings along with their names in dictionary data
data = {"encoding": Binary(pickle.dumps(encodings, protocol=2), subtype = 128), "names": name}

# Inserts the encoding and name into the database
# We should just return data and have api upload encoding
# client["SmockLock"]["IMG"].insert_one(data)

# grabs the document that we just inserted
y = col1.find_one()

# prints the ndarray of the encoding
print(pickle.loads(y["encoding"]))
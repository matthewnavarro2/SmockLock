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

# We need to convert our base 64 images on our database to a png which then encodes
# we are getting this from the parameters.
"""
Input needs to look like
{
    Name: String name
    Pic: base64 bytes
}
"""

# Connection the database client
ca = certifi.where()
client = MongoClient("mongodb+srv://SmockLock:S3n1oRD3s1GN@cluster0.hfo9g.mongodb.net/SmockLock?retryWrites=true&w=majority", tlsCAFile=ca)

# Sets us in the SmockLock Database
db = client["SmockLock"]

# Sets variables equivalent to collections
col = db["IMG1"]
col1 = db["IMG"]

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
client["SmockLock"]["IMG"].insert_one(data)

# grabs the document that we just inserted
y = col1.find_one()

# prints the ndarray of the encoding
print(pickle.loads(y["encoding"]))

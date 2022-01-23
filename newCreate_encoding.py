# things that need to get done first of all make sure that when we test with arc that
# x is getting filled so run the file locally and see what it returns we are gonna have this file run all the api requests
# and just run the script


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

ca = certifi.where()
client = MongoClient("mongodb+srv://SmockLock:S3n1oRD3s1GN@cluster0.hfo9g.mongodb.net/SmockLock?retryWrites=true&w=majority", tlsCAFile=ca)



# Sets us in the SmockLock Database
db = client["SmockLock"]

col = db["UserPics"]



# Sets variables equivalent to parameters 1, 2
#pics = sys.argv[2].Pic
#names = sys.argv[2].Name # names = []

# Sets x equal to a document in the collection
# x = col.find_one()

# Variable Declaration
kEncodings = []
kNames = []
record = []

for x in col.find({}, {"_id":0, "Name": 1, "Pic": 1 }):
    pic = (x["Pic"])
    name = (x["Name"])

    image = imageio.imread(io.BytesIO(base64.b64decode(pic)))
    rgb = cv2.cvtColor(image, cv2.COLOR_RGB2BGR)
    boxes = face_recognition.face_locations(rgb,model='hog')

    # compute the facial embedding for the any face
    encodings = face_recognition.face_encodings(rgb, boxes)

    # loop over the encodings
    for encoding in encodings:
        kEncodings.append(encoding)
        kNames.append(name)
# Save emcodings along with their names in dictionary data
data = {"encodings": Binary(pickle.dumps(kEncodings, protocol=2), subtype = 128), "names": kNames}
print(data)
if client["SmockLock"]["EncodedPics"].find_one() != "" :
    client["SmockLock"]["EncodedPics"].delete_one({})

# Delete old collection


# Inserts the encoding and name into the database
client["SmockLock"]["EncodedPics"].insert_one(data)



# Creates the face encodings from a folder of images

import imutils
from imutils import paths
import face_recognition
import pickle
import cv2
import os
import base64
import imageio
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


db_dict = []
#imagePath = list(paths.list_images('RealData'))
kEncodings = []
kNames = []

for key in db_dict:
    name = key
    imgBytes = db_dict[key]
    imgString = imgBytes.decode()
    image = imageio.imread(io.BytesIO(base64.b64decode(imgString)))
    rgb = cv2.cvtColor(image, cv2.COLOR_RGB2BGR)
    boxes = face_recognition.face_locations(rgb,model='hog')
    
    # compute the facial embedding for the any face
    encodings = face_recognition.face_encodings(rgb, boxes)
    
    # loop over the encodings
    for encoding in encodings:
        kEncodings.append(encoding)
        kNames.append(name)

#save emcodings along with their names in dictionary data
data = {"encodings": kEncodings, "names": kNames}


#use pickle to save data into a file for later use
f = open("face_enc123", "wb")
f.write(pickle.dumps(data))#to open file in write mode
f.close()#to close file

"""
# loop over the image paths
for (i, ip) in enumerate(imagePath):
    
    # extract the person name from the image path
    name = ip.split(os.path.sep)[-2]
    


    # load the input image and convert it from BGR
    image = cv2.imread(ip)
    rgb = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
    boxes = face_recognition.face_locations(rgb,model='hog')
    
    # compute the facial embedding for the any face
    encodings = face_recognition.face_encodings(rgb, boxes)
    
    # loop over the encodings
    for encoding in encodings:
        kEncodings.append(encoding)
        kNames.append(name)

#save emcodings along with their names in dictionary data
data = {"encodings": kEncodings, "names": kNames}
#use pickle to save data into a file for later use
f = open("face_enc123", "wb")
f.write(pickle.dumps(data))#to open file in write mode
f.close()#to close file
"""
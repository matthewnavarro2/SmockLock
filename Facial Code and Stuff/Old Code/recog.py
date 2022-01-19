import face_recognition
import imutils #imutils includes opencv functions
import pickle
import time
import cv2
import os
import numpy as np

#to find path of xml file containing haarCascade file
cfp = os.path.dirname(cv2.__file__) + "/data/haarcascade_frontalface_alt2.xml"
# load the harcaascade in the cascade classifier
fc = cv2.CascadeClassifier(cfp)
# load the known faces and embeddings saved in last file
data = pickle.loads(open('face_enc123', "rb").read())

#Find path to the image you want to detect face and pass it here
image = cv2.imread("both.jpg")
rgb = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
#convert image to Greyscale for HaarCascade
gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

faces = fc.detectMultiScale(
    gray,
    scaleFactor=1.1,
    minNeighbors=6,
    minSize=(60, 60),
    flags=cv2.CASCADE_SCALE_IMAGE
    )

# the facial embeddings for face in input
loc = face_recognition.face_locations(rgb)
encodings = face_recognition.face_encodings(rgb, loc)

names = []
# loop over the facial embeddings incase
# we have multiple embeddings for multiple fcaes
for encoding in encodings:
    #Compare encodings with encodings in data["encodings"]
    #Matches contain array with boolean values True and False
    matches = face_recognition.compare_faces(data["encodings"], encoding)
    #set name =unknown if no encoding matches
    name = "Unknown"
   
    face_distances = face_recognition.face_distance(data["encodings"], encoding)
    best_match_index = np.argmin(face_distances)
    if matches[best_match_index]:
        name = data["names"][best_match_index]
    
    names.append(name)

for ((top, right, bottom, left), name) in zip(loc, names):
    cv2.rectangle(image, (left, top), (right, bottom), (0,255,0), 2)
    font = cv2.FONT_HERSHEY_SIMPLEX
    cv2.putText(image, name, (left+12,bottom+12), font, .5, (0,255,0), 2)

cv2.imshow("Frame", image)
cv2.waitKey(0)
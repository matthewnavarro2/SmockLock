import cv2
import os
import pickle
import face_recognition
import imutils

#to find path of xml file containing haarCascade file
cfp = os.path.dirname(cv2.__file__) + "/data/haarcascade_frontalface_default.xml"
# load the harcaascade in the cascade classifier
faceCascade = cv2.CascadeClassifier(cfp)

# load the known faces and embeddings saved in last file
data = pickle.loads(open('face_enc123', "rb").read())

imagePath = "both1.jpg"

image = cv2.imread(imagePath)
rgb = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

encodings = face_recognition.face_encodings(rgb)
names = []

faces = faceCascade.detectMultiScale(
    gray,
    scaleFactor=1.1,
    minNeighbors=5,
    minSize=(30, 30),
    flags = cv2.CASCADE_SCALE_IMAGE
)

# Draw a rectangle around the faces
for (x, y, w, h) in faces:
    cv2.rectangle(image, (x, y), (x+w, y+h), (0, 255, 0), 2)

cv2.imshow("Faces found", image)
cv2.waitKey(0)

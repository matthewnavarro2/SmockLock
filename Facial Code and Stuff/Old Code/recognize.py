import face_recognition
import imutils #imutils includes opencv functions
import pickle
import time
import cv2
import os

#to find path of xml file containing haarCascade file
cfp = os.path.dirname(cv2.__file__) + "/data/haarcascade_frontalface_alt2.xml"
# load the harcaascade in the cascade classifier
fc = cv2.CascadeClassifier(cfp)
# load the known faces and embeddings saved in last file
data = pickle.loads(open('face_enc123', "rb").read())

#Find path to the image you want to detect face and pass it here
image = cv2.imread("both1.jpg")
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
    # check to see if we have found a match
    if True in matches:
        #Find positions at which we get True and store them
        matchedIdxs = [i for (i, b) in enumerate(matches) if b]

    count = {}

    # loop over the matched indexes and maintain a count for
    # each recognized face face
    for i in matchedIdxs:
        #Check the names at respective indexes we stored in matchedIdxs
        name = data["names"][i]
        #increase count for the name we got
        count[name] = count.get(name, 0) + 1
        #set name which has highest count
        name = max(count, key=count.get)
        # will update the list of names
        names.append(name)


names1 = []
for i in names:
    if i not in names1:
        names1.append(i)
print(names)
print(names1)

# do loop over the recognized faces
for ((x, y, w, h), name) in zip(faces, names1):
    # rescale the face coordinates
    # draw the predicted face name on the image
    cv2.rectangle(image, (x, y), (x + w, y + h), (0, 255, 0), 2)
    cv2.putText(image, name, (x, y), cv2.FONT_HERSHEY_SIMPLEX,
    0.75, (0, 255, 0), 2)

cv2.imshow("Frame", image)
cv2.waitKey(0)
import cv2
import urllib.request
import numpy as np
import face_recognition
import pickle
 
f_cas= cv2.CascadeClassifier(cv2.data.haarcascades+'haarcascade_frontalface_default.xml')
eye_cascade=cv2.CascadeClassifier(cv2.data.haarcascades +'haarcascade_eye.xml')
data = pickle.loads(open('face_enc123', "rb").read())

# This is where pic is grabbed from, this pic is going to be passed in as a paramter in base64 format we need to convert to png or figure out a way to encode direct from base64.
url='http://192.168.0.238/cam-hi.jpg '
##'''cam.bmp / cam-lo.jpg /cam-hi.jpg / cam.mjpeg '''
cv2.namedWindow("Live Transmission", cv2.WINDOW_AUTOSIZE)

while True:
    img_resp=urllib.request.urlopen(url) 
    imgnp=np.array(bytearray(img_resp.read()),dtype=np.uint8)
    img=cv2.imdecode(imgnp,-1)
    # Converting the image to RGB and GrayScale
    gray=cv2.cvtColor(img,cv2.COLOR_BGR2GRAY)
    rgb = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
    # Detects faces based on the cascade classifier
    face=f_cas.detectMultiScale(gray,scaleFactor=1.1,minNeighbors=5)
    # Draws rectangles around the faces
    for x,y,w,h in face:
        cv2.rectangle(img,(x,y),(x+w,y+h),(0,0,255),3)
        roi_gray = gray[y:y+h, x:x+w]
        roi_color = img[y:y+h, x:x+w]
        #eyes = eye_cascade.detectMultiScale(roi_gray)
        #for (ex,ey,ew,eh) in eyes:
            #cv2.rectangle(roi_color,(ex,ey),(ex+ew,ey+eh),(0,255,0),2)
 
    # the facial embeddings for face in input
    # the locations of the faces on the image
    loc = face_recognition.face_locations(rgb)
    # creates an encoding from the location of the face
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

        # Tells us how similar the faces are based on euclidian distance
        face_distances = face_recognition.face_distance(data["encodings"], encoding)
        # looking
        best_match_index = np.argmin(face_distances)
        if matches[best_match_index]:
            name = data["names"][best_match_index]
        
        names.append(name)

    for ((top, right, bottom, left), name) in zip(loc, names):
        #cv2.rectangle(img, (left, top), (right, bottom), (0,255,0), 2)
        font = cv2.FONT_HERSHEY_SIMPLEX
        cv2.putText(img, name, (left+12,bottom+12), font, .5, (0,255,0), 2)

    cv2.imshow("live transmission",img)
    key=cv2.waitKey(5)
    if key==ord('q'):
        break
 
cv2.destroyAllWindows()
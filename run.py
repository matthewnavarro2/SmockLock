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
from flask import Flask, jsonify, request, redirect

app = Flask(__name__)
ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'gif'}

def allowed_file(filename):
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

@app.route('/embedding', methods=['GET', 'POST'])
def get_embedding():
    # Check if a valid image file was uploaded
    if request.method == 'POST':
        if 'file' not in request.files:
            print("file not in request.files")
            return redirect(request.url)

        file = request.files['file']

        if file.filename == '':
            print("file name is blank")
            return redirect(request.url)

if file and allowed_file(file.filename):
            print("file found")

            # The image file seems valid! Detect faces and return the result.
            img = face_recognition.load_image_file(file)
            emb = face_recognition.face_encodings(img)[0]
            return jsonify(emb.tolist())

 # If no valid image file was uploaded, show the file upload form:
    return '''
    <!doctype html>
    <title>upload</title>
    <h1>Please select image and upload</h1>
    <form method="POST" enctype="multipart/form-data">
      <input type="file" name="file">
      <input type="submit" value="Upload">
    </form>
    '''

if __name__ == "__main__":
    app.run(host='0.0.0.0')
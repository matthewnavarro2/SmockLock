import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_app/ekeyscreen/ekey.dart';
import 'package:mobile_app/ekeyscreen/listekey.dart';
import 'package:mobile_app/login/login.dart';
import 'package:mobile_app/login/register.dart';

import 'camerascreen/takepicturescreen.dart';
import 'ekeyscreen/editekey.dart';
import 'home.dart';
import 'login/intro.dart';

const SERVER_IP = 'http://smocklock2.herokuapp.com/api';
final storage = FlutterSecureStorage();

bool isLoggedIn = false;



Future<void> main() async {

  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();
  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();
  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;



  runApp(
      MaterialApp(

          initialRoute: '/',
          routes: {
            '/': (context) => const Intro(),
            '/login': (context) => const Login(),
            '/register': (context) => const Register(),
            '/home': (context) => const Home(),
            //'/location': (context) => ChooseLocation(),
            '/picture': (context) => TakePictureScreen(camera: cameras.first),
            '/ekey': (context) => const Ekeyscreen(),
            '/listekeys': (context) => const ListEKeys(),
            '/editekeys' : (context) => const EditEKeys(),
      }

  ));



}



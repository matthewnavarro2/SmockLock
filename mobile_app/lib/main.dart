import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_app/login/login.dart';
import 'package:mobile_app/login/register.dart';

import 'home.dart';
import 'login/intro.dart';

const SERVER_IP = 'http://smocklock2.herokuapp.com/api';
final storage = FlutterSecureStorage();
bool isLoggedIn = false;

void main() => runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => const Intro(),
      '/login': (context) => const Login(),
      '/register': (context) => const Register(),
      '/home': (context) => Home(),
      //'/location': (context) => ChooseLocation(),
    }
));
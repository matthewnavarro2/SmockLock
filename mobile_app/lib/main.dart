import 'package:flutter/material.dart';
import 'package:mobile_app/login/login.dart';
import 'package:mobile_app/login/register.dart';

import 'login/intro.dart';

void main() => runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => const Intro(),
      '/login': (context) => const Login(),
      '/register': (context) => const Register(),
      //'/home': (context) => Home(),
      //'/location': (context) => ChooseLocation(),
    }
));
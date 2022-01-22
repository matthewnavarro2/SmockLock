import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Intro extends StatefulWidget {
  const Intro({Key? key}) : super(key: key);

  @override
  _IntroState createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/Capturessss.PNG"),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: (){
                    Navigator.pushNamed(context, '/register');
                  },
                  child: const Text('Sign Up'),
                ),
                TextButton(
                  onPressed: (){
                    Navigator.pushNamed(context, '/login');
                  },
                  child: const Text('Login'),
                ),
              ],
            )

          ],

        ),
      ),
    );
  }
}

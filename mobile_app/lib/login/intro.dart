import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/API/device_info.dart';

class Intro extends StatefulWidget {
  const Intro({Key? key}) : super(key: key);

  @override
  _IntroState createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color.fromRGBO(32, 31, 30, 1),
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: (MediaQuery.of(context).size.height) * .1),
                Container(
                  width: (MediaQuery.of(context).size.width) * 1,
                  height: (MediaQuery.of(context).size.height) * .8,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/smock_lock_bg.PNG"),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: Container(
                        alignment: AlignmentDirectional.center,
                        height: (MediaQuery.of(context).size.height) * .04,
                        width: (MediaQuery.of(context).size.width) * .3,
                        decoration: const BoxDecoration(
                          color: const Color.fromRGBO(150, 150, 150, 1),
                        ),
                        child: const Text(
                          'Register',
                          style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 1),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: Container(
                        alignment: AlignmentDirectional.center,
                        height: (MediaQuery.of(context).size.height) * .04,
                        width: (MediaQuery.of(context).size.width) * .3,
                        decoration: const BoxDecoration(
                          color: const Color.fromRGBO(150, 150, 150, 1),
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 1),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

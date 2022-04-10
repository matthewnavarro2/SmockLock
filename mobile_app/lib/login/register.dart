import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mobile_app/API/api.dart';

import '../main.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final userController = TextEditingController();  // controller for username textfield
  final passController = TextEditingController(); // controller for password textfield
  final fnController = TextEditingController();
  final lnController = TextEditingController();
  final emailController = TextEditingController();
  final referralController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }


  @override
  void dispose(){
    userController.dispose(); // dispose controller when page is disposed
    passController.dispose();
    fnController.dispose();
    lnController.dispose();
    emailController.dispose();
    referralController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Register',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: const Color.fromRGBO(32, 31, 30, 1),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: (MediaQuery.of(context).size.width) * 1,
                  height: (MediaQuery.of(context).size.height) * .1,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/smock_lock_bg_no_text.PNG"),
                    ),
                  ),
                ),
                TextField(
                  controller: userController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.zero),
                    ),
                    label: Text(
                      'Username',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    fillColor: Color.fromRGBO(255, 255, 255, 1),
                    filled: true,
                  ),
                ),
                SizedBox(height: (MediaQuery.of(context).size.height) * .03),
                TextField(
                  obscureText: true,
                  controller: passController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.zero),
                    ),
                    label: Text(
                      'Password',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    fillColor: Color.fromRGBO(255, 255, 255, 1),
                    filled: true,
                  ),
                ),
                SizedBox(height: (MediaQuery.of(context).size.height) * .03),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.zero),
                    ),
                    label: Text(
                      'Email',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    fillColor: Color.fromRGBO(255, 255, 255, 1),
                    filled: true,
                  ),
                ),
                SizedBox(height: (MediaQuery.of(context).size.height) * .03),
                TextField(
                  controller: fnController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.zero),
                    ),
                    label: Text(
                      'First Name',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    fillColor: Color.fromRGBO(255, 255, 255, 1),
                    filled: true,
                  ),
                ),
                SizedBox(height: (MediaQuery.of(context).size.height) * .03),
                TextField(
                  controller: lnController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.zero),
                    ),
                    label: Text(
                      'Last Name',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    fillColor: Color.fromRGBO(255, 255, 255, 1),
                    filled: true,
                  ),
                ),

                SizedBox(height: (MediaQuery.of(context).size.height) * .03),
                TextButton(
                  onPressed: () async {
                    var email = emailController.text.trim();
                    var fn = fnController.text.trim();
                    var ln = lnController.text.trim();
                    var user = userController.text.trim();
                    var pass = passController.text.trim();

                    var res = await Api.register(email, fn, ln, user, pass);

                    var res1 = await Api.login(user, pass);

                    if (res1.statusCode == 200) { // Success, do login
                      Map<String, dynamic> jsonObject = jsonDecode(res1.body);
                      var jwt = jsonObject['token']['accessToken'];
                      await storage.write(key: 'jwt', value: jwt);
                      Map<String, dynamic> decodedToken = JwtDecoder.decode(jwt!);
                      var userId = decodedToken["userId"];
                      // api call to get mac adress and store it based on userid
                      isLoggedIn = true;
                      Navigator.pushNamed(
                        context,
                        '/home',
                        arguments: {'jwt': jwt},
                      );
                    }

                  },
                  child: Container(
                    alignment: AlignmentDirectional.center,
                    height: (MediaQuery.of(context).size.height) * .04,
                    width: (MediaQuery.of(context).size.width) * .3,
                    decoration: const BoxDecoration(
                      color: const Color.fromRGBO(255, 255, 255, 1),

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
              ],

            ),
          ),
        )
    );
  }

}

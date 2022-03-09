import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/API/api.dart';

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
                  height: (MediaQuery.of(context).size.height) * .2,
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

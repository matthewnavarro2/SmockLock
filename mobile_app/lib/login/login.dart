import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_app/API/api.dart';
import 'package:mobile_app/main.dart';
class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final userController = TextEditingController();  // controller for username textfield
  final passController = TextEditingController(); // controller for password textfield






  @override
  void initState() {
    super.initState();
  }


  @override
  void dispose(){
    userController.dispose(); // dispose controller when page is disposed
    passController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Username',
            textAlign: TextAlign.center,
            style: TextStyle(

            ),
          ),
         TextField(
            controller: userController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Username',
            ),
          ),
          const Text(
            'Password',
            textAlign: TextAlign.center,
            style: TextStyle(

            ),
          ),
          TextField(
            controller: passController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),

              labelText: 'Password',
            ),
          ),
          TextButton(
            onPressed: () async {
              String username = '', pass = '';
              username = userController.text;
              pass = passController.text;
              var res = await Api.login(username, pass);

              print(res.statusCode);

              if (res.statusCode == 200) { // Success, do login
                Map<String, dynamic> jsonObject = jsonDecode(res.body);
                var jwt = jsonObject['token']['accessToken'];
                await storage.write(key: 'jwt', value: jwt);
                isLoggedIn = true;
                Navigator.pushNamed(context, '/home');
              }
              else if (res.statusCode != 200) { // fail // trying to figure out how to do a dialog popup saying what error it is

                var errTitle = 'Error';
                var errMessage = '${res.statusCode}';
                showAlertDialog(context, errTitle , errMessage).showDialog;

              }

            },
            child: const Text('Login'),
          ),
        ],

      )
    );
  }
  showAlertDialog(BuildContext context, String title, String message) {

    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

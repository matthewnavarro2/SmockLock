import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final myController1 = TextEditingController();  // controller for username textfield
  final myController2 = TextEditingController(); // controller for password textfield

  String message = '', newMessageText = '';
  String loginName = '', password = '';
  String firstName = '', lastName = '';



  @override
  void initState() {
    super.initState();
  }


  @override
  void dispose(){
    myController1.dispose(); // dispose controller when page is disposed
    myController2.dispose();
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
          const TextField(
            decoration: InputDecoration(
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
          const TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Password',
            ),
          ),
          TextButton(
            onPressed: (){

            },
            child: const Text('Login'),
          ),
        ],

      )
    );
  }
}

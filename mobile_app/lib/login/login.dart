import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mobile_app/API/api.dart';
import 'package:mobile_app/main.dart';
import 'package:mobile_app/utility/authorized_lock_info.dart';
import 'package:mobile_app/utility/authorized_lock_info.dart';
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
        title: const Text(
          'Login',
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
        child: Stack(
          //alignment: AlignmentDirectional.topCenter,
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: (MediaQuery.of(context).size.height) * .05),

                  Container(

                    width: (MediaQuery.of(context).size.width) * 1,
                    height: (MediaQuery.of(context).size.height) * .5,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/smock_lock_bg.PNG"),
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
                  SizedBox(height: (MediaQuery.of(context).size.height) * .02),
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
                      //labelText:
                      fillColor: Color.fromRGBO(255, 255, 255, 1),
                      filled: true,
                    ),
                  ),
                  SizedBox(height: (MediaQuery.of(context).size.height) * .02),

                  TextButton(
                    onPressed: () async {

                      String username = '', pass = '';
                      username = userController.text;
                      pass = passController.text;
                      var res = await Api.login(username, pass);

                      if (res.statusCode == 200) { // Success, do login
                        Map<String, dynamic> jsonObject = jsonDecode(res.body);
                        var jwt = jsonObject['token']['accessToken'];
                        await storage.write(key: 'jwt', value: jwt);
                        Map<String, dynamic> decodedToken = JwtDecoder.decode(jwt!);
                        var userId = decodedToken["userId"];
                        List<String> nameList = [];

                        for(int i = 0; i < decodedToken["locks"].length; i++){
                          if(decodedToken["locks"][i]["access"] == "Master"){
                            var name = decodedToken["firstName"] + " " + decodedToken["lastName"];
                            nameList.add(name);
                          }
                          else if(decodedToken["locks"][i]["access"] == "aUser"){
                            var masterLockId = decodedToken["locks"][i]["masterLockId"];
                            var res1 = await Api.getUser(masterLockId);
                            Map<String, dynamic> jsonObject2 = jsonDecode(res1.body);
                            var name = jsonObject2["result"][0]["FullName"];
                            nameList.add(name);
                          }
                        }




                        isLoggedIn = true;
                        Navigator.pushNamed(
                            context,
                            '/home',
                            arguments: {'jwt': jwt, 'nameList': nameList},
                        );
                      }
                      else if (res.statusCode == 400) { // fail // trying to figure out how to do a dialog popup saying what error it is
                        var errTitle = 'Error ${res.statusCode}';
                        Map<String, dynamic> jsonObject = jsonDecode(res.body);
                        var errMessage = '${jsonObject["error"]}';
                        showAlertDialog(context, errTitle , errMessage).showDialog;
                      }else{
                        var errTitle = 'Error';
                        var errMessage = 'Something went wrong.';
                        showAlertDialog(context, errTitle , errMessage).showDialog;
                      }
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
              ),
            ),
          ],
        ),
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

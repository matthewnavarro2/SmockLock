import 'package:flutter/material.dart';
import 'package:mobile_app/API/api.dart';

import '../main.dart';

class Setup extends StatefulWidget {
  const Setup({Key? key}) : super(key: key);

  @override
  _SetupState createState() => _SetupState();
}

class _SetupState extends State<Setup> {
  final macController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }


  @override
  void dispose(){
    macController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Initial Lock Setup"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Text(
              'Please input the MAC address of the lock',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: macController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.zero),
                ),
                label: Text(
                  'MAC Address',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                //labelText:
                fillColor: Color.fromRGBO(255, 255, 255, 1),
                filled: true,
              ),
            ),
            TextButton(
                onPressed: () async {
                  var res = await Api.linklock(macController.text);
                  print(res.body);
                  // Alert: GO TO SETTINGS AND CONNECT TO LOCK WIFI
                  //        INPUT WIFI INFORMATION TO CONNECT Lock
                  //        STAY IN LOOP UNTIL PROCESS IS FINISHED

                  showAlertDialog(context, "Connect to Locks Access Point", "Navigate to your phones wifi settings and look for the locks access point to connect to your wifi. Click Finished when you are done.");




                },
                child: Text('SUBMIT'),
            ),



          ],
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context, String title, String message) {

    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );

    // set up the button
    Widget okButton = TextButton(
      child: Text("Finished"),
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.pushNamed(context, '/setup2');
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        cancelButton,
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

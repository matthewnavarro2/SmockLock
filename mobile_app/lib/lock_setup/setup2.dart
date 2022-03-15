import 'package:flutter/material.dart';
import 'package:mobile_app/API/api.dart';

class Setup2 extends StatefulWidget {
  const Setup2({Key? key}) : super(key: key);

  @override
  _Setup2State createState() => _Setup2State();
}

class _Setup2State extends State<Setup2> {

  Future<int> wifiStatus() async {
    int lockStatus = 0;

    while(lockStatus == 0){
      var res = await Api.checkWifiStatus();
      //check res to see if status is 0 or 1
      //set lockstatus to status
    }
    // move to next page with assumption it is connected to wifi
    return 1;

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
                Text('Please Connect to the locks access points to connect lock to your wireless network.'),

              ],
            )
        )
    );
  }
}

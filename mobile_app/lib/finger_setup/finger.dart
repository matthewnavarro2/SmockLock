import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_app/API/api.dart';

class Finger extends StatefulWidget {
  const Finger({Key? key}) : super(key: key);

  @override
  _FingerState createState() => _FingerState();
}

class _FingerState extends State<Finger> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('finger setup'),
      ),
      body: Column(
        children: [
          Text("To enroll a fingerprint, please ensure that your lock and"
              " device are connected to the same Wifi network"),
          TextButton(
              onPressed: () async {
                //get a fingerid from api call
                //send fingerid to lock
                var res1 = await Api.getFingerId();
                Map<String, dynamic> jsonObject = jsonDecode(res1.body);
                var fingerId = jsonObject['newFpUserId'];
                // get ip address

                //var res2 = await Api.startFingerEnrollment(ip, fingerId);

              },
              child: Text('Start enrollment process'),
          ),
        ],
      )
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_app/API/api.dart';
import 'package:mobile_app/utility/authorized_lock_info.dart';

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
                var res = await Api.getFingerId(AuthorizedLocks.masterMac);
                Map<String, dynamic> jsonObject = jsonDecode(res.body);
                var fingerId = jsonObject['newFpUserId'];
                // get ip address
                var masterIP = AuthorizedLocks.masterLock[0]['IP'];
                print(masterIP.runtimeType);
                print(fingerId.runtimeType);
                var res2 = await Api.startFingerEnrollment(masterIP, fingerId);
                print(res2);
              },
              child: Text('Start enrollment process'),
          ),
        ],
      )
    );
  }
}

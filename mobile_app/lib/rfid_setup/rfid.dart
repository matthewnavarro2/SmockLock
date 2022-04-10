import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_app/API/api.dart';
import 'package:mobile_app/utility/authorized_lock_info.dart';

class Rfid extends StatefulWidget {
  const Rfid({Key? key}) : super(key: key);

  @override
  _RfidState createState() => _RfidState();
}

class _RfidState extends State<Rfid> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('RFID setup'),
        ),
        body: Column(
          children: [
            Text("To enroll in RFID, please ensure that your lock and"
                " device are connected to the same Wifi network"),
            TextButton(
              onPressed: () async {

                // get ip address
                var masterIP = AuthorizedLocks.masterLock[0]['IP'];
                var res2 = await Api.startRfidEnrollment(masterIP);
              },
              child: Text('Start enrollment process'),
            ),
          ],
        )
    );
  }
}

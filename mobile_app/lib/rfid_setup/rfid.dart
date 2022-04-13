import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mobile_app/API/api.dart';
import 'package:mobile_app/utility/authorized_lock_info.dart';

import '../main.dart';

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
               // var masterIP = AuthorizedLocks.masterLock[0]['IP'];

                var jwt = await storage.read(key: 'jwt');
                Map<String, dynamic> decodedToken = JwtDecoder.decode(jwt!);
                var userId = decodedToken["userId"];
                var res = await Api.getLockUI(userId);
                Map<String, dynamic> jsonObject = jsonDecode(res.body);
                var ip = jsonObject["result"][0]["IP"];
                var mac = jsonObject["result"][0]["MACAddress"];
                var res2 = await Api.startRfidEnrollment(ip);
                print(res2.body);
                if(res2.body == "Failed" || res2.body == "" || res2 == null){
                  print("Failure. Please try again");
                }else{
                  var rfid = res2.body;
                  var res1 = await Api.enrollRFID(mac, rfid);
                }

                // print(decodedToken["locks"]);
                // print(decodedToken["locks"][0]["masterLockId"]);


               //
              },
              child: Text('Start enrollment process'),
            ),
          ],
        )
    );
  }
}

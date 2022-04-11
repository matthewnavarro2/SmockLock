import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mobile_app/API/api.dart';
import 'package:mobile_app/utility/authorized_lock_info.dart';

import '../main.dart';

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

                //
                // get ip address
                var jwt = await storage.read(key: 'jwt');
                Map<String, dynamic> decodedToken = JwtDecoder.decode(jwt!);
                var userId = decodedToken["userId"];
                var res1 = await Api.getLockUI(userId);
                Map<String, dynamic> jsonObject = jsonDecode(res1.body);
                var ip = jsonObject["result"][0]["IP"];
                var mac = jsonObject["result"][0]["MACAddress"];


                var res2 = await Api.getFingerId(mac);
                Map<String, dynamic> jsonObject2 = jsonDecode(res2.body);
                var fingerId = jsonObject2['newFpUserId'];
                
                var res3 = await Api.startFingerEnrollment(ip, fingerId.toString());
                if(res3.body == "Success"){
                  print(res3.body);
                }else if(res3.body == "Failed"){
                  print(res3.body);
                }else{
                  print("this mega failed");
                }

              },
              child: Text('Start enrollment process'),
          ),
        ],
      )
    );
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

import '../main.dart';

class Api {
  static Future login(String login, String password) async {
    var res = await http.post(
      Uri.parse('$SERVER_IP/login'),

      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'login': login,
        'password': password}),

    );
    return res;
  }

  static Future<int> register(String email, String firstname, String lastname, String login, String password, {String code = ""}) async {
    var res = await http.post(
        Uri.parse('$SERVER_IP/register'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'firstname': firstname,
          'lastname': lastname,
          'login': login,
          'password': password,
          'plainCode': code
        })

    );
    return res.statusCode;
  }

  static Future<int> addPic(String base64) async {

    var jwt = await storage.read(key:"jwt");
    Map<String, dynamic> decodedToken = JwtDecoder.decode(jwt!);
    var name = decodedToken["firstName"];

    var res = await http.post(
        Uri.parse('$SERVER_IP/addPic'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'name': name,
          'pic': base64,
          'jwtToken': jwt,
          })

    );
    if(res.statusCode == 200){
      var res2 = await encodeForFacial();
    }
    return res.statusCode;
  }

  static Future listPics() async {

    var jwt = await storage.read(key:"jwt");
    Map<String, dynamic> decodedToken = JwtDecoder.decode(jwt!);
    var userId = decodedToken["userId"];

    var res = await http.post(
        Uri.parse('$SERVER_IP/listPics'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'userId': "$userId",
          'jwtToken': jwt
        })
    );

    return res;
  }

  static Future createEKey(String dateTime, String email, String fn, String ln) async {
    var jwt = await storage.read(key:"jwt");
    Map<String, dynamic> decodedToken = JwtDecoder.decode(jwt!);
    var userId = decodedToken["userId"];
    var res = await http.post(
        Uri.parse('$SERVER_IP/createEKey'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'userId': userId,
          'tgo': dateTime,
          'fn': fn,
          'ln': ln,
          'email': email,
        })
    );
    return res;
  }

  static Future listEKey() async {
    var jwt = await storage.read(key:"jwt");
    Map<String, dynamic> decodedToken = JwtDecoder.decode(jwt!);
    var userId = decodedToken["userId"];
    var res = await http.post(
        Uri.parse('$SERVER_IP/listEKeys'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'userId': userId,
          'jwtToken': jwt
        })
    );
    return res;
  }

  static Future<int> encodeForFacial() async {
    var res = await http.post(
        Uri.parse('http://face-rec751.herokuapp.com/encodeUserPictures')
    );
    return res.statusCode;
  }

  static Future linklock( mac) async {
    var jwt = await storage.read(key:"jwt");
    var mac = await storage.read(key:"mac");
    Map<String, dynamic> decodedToken = JwtDecoder.decode(jwt!);
    var userId = decodedToken["userId"];
    var res = await http.post(
        Uri.parse('$SERVER_IP/linkLock'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'userId': userId,
          'macAdd': mac
        })
    );
    return res;
  }

  static Future updateTier(String tier, String mac) async {
    var res = await http.post(
        Uri.parse('$SERVER_IP/updateTier'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'tier': tier,
          'macAdd': mac
        })

    );
    return res;
  }

  static Future startFingerEnrollment(String ip, String fingerId) async {
    String message = "";
    message = " enrollFinger-" + fingerId +  "-";
    var res = await http.post(
      Uri.parse('http://$ip/body'),
      body: message,
    );
    return res;
  }

  static Future startRfidEnrollment(String ip) async {
    String message = "";
    message = " enrollRFID-";
    var res = await http.post(
      Uri.parse('http://$ip/body'),
      body: message,
    );
    return res;
  }

  static Future getFingerId(String macAdd) async {
    var res = await http.post(
        Uri.parse('$SERVER_IP/getFingerId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'macAdd': macAdd
        })
    );
    return res;
  }

  static Future getLock({bool macAddress = false}) async {
    if (macAddress){
      var mac = await storage.read(key:"mac");
      var res = await http.post(
          Uri.parse('$SERVER_IP/getLockMA'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            'macAdd': mac
          })
      );
      return res;
    }
    else{
      var jwt = await storage.read(key:"jwt");
      Map<String, dynamic> decodedToken = JwtDecoder.decode(jwt!);
      var userId = decodedToken["userId"];
      var res = await http.post(
          Uri.parse('$SERVER_IP/getLockUI'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            'userId': "$userId"
          })
      );
      return res;
    }
  }

/*
  static Future checkWifiStatus(String mac) async {
    var jwt = await storage.read(key:"jwt");

    Map<String, dynamic> decodedToken = JwtDecoder.decode(jwt!);
    var userId = decodedToken["userId"];

    var res = await http.post(
        Uri.parse('$SERVER_IP/checkWifiStatus'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'userId': userId,
          'macAdd': mac
        })

    );
    return res;
  }
  Future<int> wifiStatus() async {
    int lockStatus = 0;

    while(lockStatus == 0){
      var res = await Api.checkWifiStatus();
      print("111111");
      //check res to see if status is 0 or 1
      //set lockstatus to status
    }
    // move to next page with assumption it is connected to wifi
    return 1;

  }
 */


}


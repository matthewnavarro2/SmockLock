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

  static Future<int> register(String email, String firstname, String lastname, String login, String password) async {
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
          'password': password})

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
      var res3 = await listPics();
      print('list status:');
      print('${res3.body}');
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


  static Future<int> encodeForFacial() async {

    var res = await http.post(
        Uri.parse('http://face-rec751.herokuapp.com/encodeUserPictures')
    );
    print(res.statusCode);
    print(res.body);
    return res.statusCode;
  }



// if(res.statusCode == 200){
//  Map<String, dynamic> jsonObject = jsonDecode(res.body);
// return jsonObject;

}


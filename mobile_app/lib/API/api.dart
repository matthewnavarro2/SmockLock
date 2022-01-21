import 'dart:convert';
import 'package:http/http.dart' as http;

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
          'email': '$email',
          'firstname': '$firstname',
          'lastname': '$lastname',
          'login': '$login',
          'password': '$password'})

    );
    return res.statusCode;
  }



// if(res.statusCode == 200){
//  Map<String, dynamic> jsonObject = jsonDecode(res.body);
// return jsonObject;

}


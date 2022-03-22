import 'package:flutter/material.dart';

class AuthorizedUsers extends StatefulWidget {
  const AuthorizedUsers({Key? key}) : super(key: key);

  @override
  _AuthorizedUsersState createState() => _AuthorizedUsersState();
}

class _AuthorizedUsersState extends State<AuthorizedUsers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("authorized Users"),
      ),
    );
  }
}

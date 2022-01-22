
import 'package:flutter/material.dart';
import 'package:mobile_app/main.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextButton(
              onPressed: () async {
                isLoggedIn = false;
                await storage.deleteAll();
                Navigator.popUntil(context, ModalRoute.withName('/'));

              },
              child: const Text('Logout'),
          ),
        ],
      )
    );
  }
}

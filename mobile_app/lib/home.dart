
import 'package:flutter/material.dart';
import 'package:mobile_app/main.dart';

import 'API/device_info.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/Capturessss.PNG"),
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * .06),
            TextButton(
                onPressed: () async {
                  isLoggedIn = false;
                  await storage.deleteAll();
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                },
                child: const Text('Logout'),
            ),
            IconButton(
                onPressed: (){},
                icon: const Icon(
                  Icons.settings,
                  //size: DeviceInfo.width,
                ),
            )
          ],
        ),
      )
    );
  }
}

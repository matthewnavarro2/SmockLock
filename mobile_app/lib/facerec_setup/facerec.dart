import 'package:flutter/material.dart';

class Facerec extends StatefulWidget {
  const Facerec({Key? key}) : super(key: key);

  @override
  _FacerecState createState() => _FacerecState();
}

class _FacerecState extends State<Facerec> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('facerec setup'),
      ),
    );
  }
}

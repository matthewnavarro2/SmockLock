import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Ekeyscreen extends StatefulWidget {
  const Ekeyscreen({Key? key}) : super(key: key);

  @override
  _EkeyscreenState createState() => _EkeyscreenState();
}

class _EkeyscreenState extends State<Ekeyscreen> {
  String dropdownValue = 'One';
  DateTime _myDateTime = DateTime.now();
  TimeOfDay _myTimeOfDay = TimeOfDay.now();
  String time = '';
  String timeOfDay = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(time),
          Text(timeOfDay),
          ElevatedButton(
              onPressed: () async {


                _myDateTime = (await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2030),
                ))!;
                _myTimeOfDay = (await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                ))!;
                setState(() {
                  final now = DateTime.now();
                  time = _myDateTime.toString();
                  timeOfDay = _myTimeOfDay.toString();
                });


              },
              child: const Text('Expiration Date')
          ),
        ],
      ),
    );
  }
}

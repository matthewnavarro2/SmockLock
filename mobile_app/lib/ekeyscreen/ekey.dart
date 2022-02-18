import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/API/api.dart';

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
          //Text(time),
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
                  //time = DateFormat('yyyy-MM-ddTHms').format(_myDateTime);
                  //time = _myDateTime.toString();

                  timeOfDay = formatTimeOfDay(_myDateTime, _myTimeOfDay);

                  //TimeOfDayFormat _timeOfDayFormat = T
                });
                var res = await Api.createEKey(timeOfDay);

              },
              child: const Text('Expiration Date')
          ),
        ],
      ),
    );
  }

  String formatTimeOfDay(DateTime time, TimeOfDay tod) {
    final now = DateTime.now();
    final dt = DateTime(time.year, time.month, time.day, tod.hour, tod.minute);
    final format = DateFormat('yyyy-MM-ddTHH:mm:ss').format(dt);  //"2022-02-17-T17:05:00"
    return format;
  }

}

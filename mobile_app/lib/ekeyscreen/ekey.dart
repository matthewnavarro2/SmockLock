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
  final emailController = TextEditingController(); // controller for password textfield
  final fnController = TextEditingController();
  final lnController = TextEditingController();


  @override
  void initState() {
    super.initState();
  }


  @override
  void dispose(){
    emailController.dispose();
    fnController.dispose();
    lnController.dispose();
    super.dispose();
  }

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
          const Text(
            'Email',
            textAlign: TextAlign.center,
            style: TextStyle(

            ),
          ),
          TextField(
            controller: emailController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Email',
            ),
          ),
          const Text(
            'First Name',
            textAlign: TextAlign.center,
            style: TextStyle(

            ),
          ),
          TextField(
            controller: fnController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'First Name',
            ),
          ),
          const Text(
            'Last Name',
            textAlign: TextAlign.center,
            style: TextStyle(

            ),
          ),
          TextField(
            controller: lnController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Last Name',
            ),
          ),

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

                var fn = fnController.text;
                var ln = lnController.text;
                var email = emailController.text;


                var res = await Api.createEKey(timeOfDay, email, fn, ln);
                print(res.body);
                Navigator.pop(context);

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

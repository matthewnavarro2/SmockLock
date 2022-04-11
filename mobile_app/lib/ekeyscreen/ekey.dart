import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/API/api.dart';
import 'package:mobile_app/ekeyscreen/parse_json_ekey.dart';

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


                var res1 = await Api.createEKey(timeOfDay, email, fn, ln);

                //
                var res = await Api.listEKey();

                var resultObjsJson = jsonDecode(
                    res.body)['result_array'] as List;
                List<GetResults> resultObjs = resultObjsJson.map((resultJson) =>
                    GetResults.fromJson(resultJson)).toList();


                try {
                  /* first ekey info */

                  ////////////////////


                  /*maybe length of ekeys returned from certain user*/
                  var resultlength = resultObjs.length;
                  ////////////////////////

                  Navigator.pop(context);
                  Navigator.pushNamed(
                    context,
                    '/listekeys',
                    arguments: {'resultObjs': resultObjs},

                  );
                } catch (e) {
                  print(e);
                }

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

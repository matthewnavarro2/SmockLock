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
  String time = '';

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
          ElevatedButton(
              onPressed: () async {
                setState(() {
                  final now = DateTime.now();
                  time = _myDateTime.toString();
                });

                _myDateTime = (await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2030),
                ))!;
              },
              child: const Text('Expiration Date')
          ),
          Text('Create an eKey'),
          Text('Expiration Date'),
          DropdownButton<String>(
            value: dropdownValue,
            icon: const Icon(Icons.arrow_downward),
            elevation: 16,
            style: const TextStyle(color: Colors.deepPurple),
            underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
            ),
            onChanged: (String? newValue) {
              setState(() {
                dropdownValue = newValue!;

              });
              },
            items: <String>['One', 'Two', 'Free', 'Four']
                .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }
}

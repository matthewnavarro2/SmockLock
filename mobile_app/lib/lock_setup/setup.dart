import 'package:flutter/material.dart';
import 'package:mobile_app/API/api.dart';

import '../main.dart';

class Setup extends StatefulWidget {
  const Setup({Key? key}) : super(key: key);

  @override
  _SetupState createState() => _SetupState();
}

class _SetupState extends State<Setup> {
  final macController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }


  @override
  void dispose(){
    macController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Initial Lock Setup"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Text(
              'Please input the MAC address of the lock',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: macController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.zero),
                ),
                label: Text(
                  'MAC Address',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                //labelText:
                fillColor: Color.fromRGBO(255, 255, 255, 1),
                filled: true,
              ),
            ),
            TextButton(
                onPressed: () async {
                  //var res = await Api.linklock(macController.text);
                  await storage.write(key: 'mac', value: macController.text);
                  Navigator.pushNamed(context, '/setup2');


                },
                child: Text('SUBMIT'),
            ),



          ],
        ),
      ),
    );
  }
}

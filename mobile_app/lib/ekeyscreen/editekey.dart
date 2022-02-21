import 'package:flutter/material.dart';
import 'package:mobile_app/ekeyscreen/parse_json_ekey.dart';

class EditEKeys extends StatefulWidget {
  const EditEKeys({Key? key}) : super(key: key);

  @override
  _EditEKeysState createState() => _EditEKeysState();
}

class _EditEKeysState extends State<EditEKeys> {
  late List<GetResults> resultObjs;
  late var index;
  final emailController = TextEditingController(); // controller for password textfield
  final fnController = TextEditingController();
  final lnController = TextEditingController();
  final tgoController = TextEditingController();




  String email = "";
  String fn = "";
  String ln = "";
  String tgo = "";

  @override
  void initState() {
    super.initState();
    emailController.addListener(_updateEmailValue);
    fnController.addListener(_updatefnValue);
    lnController.addListener(_updatelnValue);
    tgoController.addListener(_updatetgoValue);
  }


  @override
  void dispose(){
    emailController.dispose();
    fnController.dispose();
    lnController.dispose();
    tgoController.dispose();
    super.dispose();
  }

  void _updateEmailValue() {
    setState(() {
      email = emailController.text;
    });


    //print('Second text field: ${emailController.text}');
  }

  void _updatefnValue() {
    setState(() {
      fn = fnController.text;
    });
    //print('Second text field: ${fnController.text}');
  }

  void _updatelnValue() {
    setState(() {
      ln = lnController.text;
    });
   // print('Second text field: ${lnController.text}');
  }

  void _updatetgoValue() {
    setState(() {
      tgo = tgoController.text;
    });
    //print('Second text field: ${tgoController.text}');
  }


  @override
  Widget build(BuildContext context) {

    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    resultObjs = arguments['resultObjs'];
    index = arguments['index'];
    email = resultObjs[index].email;
    fn = resultObjs[index].firstname;
    ln = resultObjs[index].lastname;
    tgo = resultObjs[index].tgo;


    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: (MediaQuery.of(context).size.width) * .19,
                child: const Text(
                  'First Name:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: (MediaQuery.of(context).size.height) * .10,
                width: (MediaQuery.of(context).size.width) * .8,
                child: TextField(
                  controller: fnController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: fn,
                  ),
                ),
              ),
            ]
          ),
          Row(
              children: [
                SizedBox(
                  width: (MediaQuery.of(context).size.width) * .19,
                  child: const Text(
                    'Last Name:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: (MediaQuery.of(context).size.height) * .10,
                  width: (MediaQuery.of(context).size.width) * .8,
                  child: TextField(
                    controller: lnController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: ln,
                    ),
                  ),
                ),
              ]
          ),
          Row(
              children: [
                SizedBox(
                  width: (MediaQuery.of(context).size.width) * .19,
                  child: const Text(
                    'Email:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: (MediaQuery.of(context).size.height) * .10,
                  width: (MediaQuery.of(context).size.width) * .8,
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: email,
                    ),
                  ),
                ),
              ]
          ),
          Row(
              children: [
                SizedBox(
                  width: (MediaQuery.of(context).size.width) * .19,
                  child: const Text(
                    'Expiration Date:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: (MediaQuery.of(context).size.height) * .10,
                  width: (MediaQuery.of(context).size.width) * .8,
                  child: TextField(
                    controller: tgoController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: tgo,
                    ),
                  ),
                ),
              ]
          ),
          ElevatedButton(
              onPressed: () {

              },
              child: Text('Submit'),
          ),
        ],
      ),


    );
  }
}

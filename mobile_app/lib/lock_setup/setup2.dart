import 'package:flutter/material.dart';
import 'package:mobile_app/API/api.dart';

class Setup2 extends StatefulWidget {
  const Setup2({Key? key}) : super(key: key);

  @override
  _Setup2State createState() => _Setup2State();
}

class _Setup2State extends State<Setup2> {

  bool isFaceRec = false;
  bool isFaceRec2 = false;
  bool isFinger = false;
  bool isFinger2 = false;
  bool isRFID = false;
  bool isEKEY = false;
  String tier = '';
  String setup = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Initial Lock Setup"),
        ),
        body: SingleChildScrollView(
            child: Column(
              children: [

                const Text("Please choose the modes of authorization "
                    "that are required for access. "
                    "Ex.) Choosing Fingerprint and Facial will require "
                    "both to be verified for the lock to unlock."
                ),

                ListTile(
                  title: const Text('Facial Recognition'),
                  leading: Switch(
                    value: isFaceRec,
                    onChanged: (bool value) {
                      setState(() {
                        isFaceRec = value;
                      });
                    },
                  ),
                ),

                ListTile(
                  title: const Text('Fingerprint Recognition'),
                  leading: Switch(
                    value: isFinger,
                    onChanged: (bool value) {
                      setState(() {
                        isFinger = value;
                      });
                    },
                  ),
                ),

                ListTile(
                  title: const Text('RFID'),
                  leading: Switch(
                    value: isRFID,
                    onChanged: (bool value) {
                      setState(() {
                        isRFID = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Digital E-Key'),
                  leading: Switch(
                    value: isEKEY,
                    onChanged: (bool value) {
                      setState(() {
                        isEKEY = value;
                      });
                    },
                  ),
                ),
                Text('Would you like to setup any of the following methods of authorizations (These can always be setup later in the settings)?'),
                ListTile(
                  title: const Text('Facial Recognition'),
                  leading: Switch(
                    value: isFaceRec2,
                    onChanged: (bool value) {
                      setState(() {
                        isFaceRec2 = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Fingerprint Recognition'),
                  leading: Switch(
                    value: isFinger2,
                    onChanged: (bool value) {
                      setState(() {
                        isFinger2 = value;
                      });
                    },
                  ),
                ),

                TextButton(
                    onPressed: () async {
                      tier = getTier(isFaceRec, isFinger, isRFID, isEKEY);
                      setup = getSetup(isFaceRec2, isFinger2);
                      var res = await Api.updateTier(tier);
                      if(setup == '11'){
                        //push facerec setup
                        //push finger setup
                        Navigator.pushNamed(context, '/facerec');
                        Navigator.pushNamed(context, '/finger');


                      }
                      else if(setup == '10'){
                        //push facerec setup
                        Navigator.pushNamed(context, '/facerec');

                      }
                      else if(setup == '01'){
                        Navigator.pushNamed(context, '/finger');

                        //push finger setup
                      }else if(setup == '00'){
                        //pop to settings
                        Navigator.of(context).pop();

                      }


                    },
                    child: Text("Next"),
                )
              ],
            )
        )
    );
  }

  String getSetup(bool isFaceRec2, bool isFinger2){
    String setup = '';

    if(isFaceRec2){
      setup = setup + '1';
    }
    else{
      setup = setup + '0';
    }
    if(isFinger2){
      setup = setup + '1';
    }
    else{
      setup = setup + '0';
    }

    return setup;
  }

  String getTier(bool isFaceRec, bool isFinger, bool isRFID, bool isEKEY){
    String tier = '';
    if(isFaceRec){
      tier = tier + '1';
    }
    else{
      tier = tier + '0';
    }

    if(isFinger){
      tier = tier + '1';
    }
    else{
      tier = tier + '0';
    }

    if(isRFID){
      tier = tier + '1';
    }
    else{
      tier = tier + '0';
    }

    if(isEKEY){
      tier = tier + '1';
    }
    else{
      tier = tier + '0';
    }
    return tier;
  }

}

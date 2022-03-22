import 'package:flutter/material.dart';
import 'package:mobile_app/API/api.dart';

class Setup22 extends StatefulWidget {
  const Setup22({Key? key}) : super(key: key);

  @override
  _Setup22State createState() => _Setup22State();
}

class _Setup22State extends State<Setup22> {

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
                TextButton(
                  onPressed: () async {
                    tier = getTier(isFaceRec, isFinger, isRFID, isEKEY);
                    var res = await Api.updateTier(tier);



                  },
                  child: Text("Save"),
                )
              ],
            )
        )
    );
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

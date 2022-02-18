
import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/API/api.dart';
import 'package:mobile_app/camerascreen/takepicturescreen.dart';
import 'package:mobile_app/ekeyscreen/parse_json_ekey.dart';
import 'package:mobile_app/main.dart';

import 'API/device_info.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color.fromRGBO(32, 31, 30, 1),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/image.PNG"),
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * .06),
              TextButton(
                  onPressed: () async {
                    isLoggedIn = false;
                    await storage.deleteAll();
                    Navigator.popUntil(context, ModalRoute.withName('/'));
                  },
                  child: const Text('Logout'),
              ),
              IconButton(
                  onPressed: (){},
                  icon: const Icon(
                    Icons.settings,
                    //size: DeviceInfo.width,
                  ),
              ),
              IconButton(
                onPressed: () async {
                  // Ensure that plugin services are initialized so that `availableCameras()`
                  // can be called before `runApp()`
                  WidgetsFlutterBinding.ensureInitialized();

                  // Obtain a list of the available cameras on the device.
                  final cameras = await availableCameras();
                  final firstCamera = cameras[0];
                  //navigator blah blah takepicturescreen(camera: firstCamera)

                  Navigator.pushNamed(
                    context,
                    '/picture',
                    arguments: TakePictureScreen(
                      camera: cameras[0],
                    ),
                  );




                },
                icon: const Icon(
                  Icons.camera,
                  //size: DeviceInfo.width,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/ekey');
                },
                child: const Text('Create an e-key'),
              ),
              TextButton(
                onPressed: () async {



                  var res = await Api.listEKey();
                  var resultObjsJson = jsonDecode(res.body)['results'] as List;
                  List<GetResults> resultObjs = resultObjsJson.map((resultJson) => GetResults.fromJson(resultJson)).toList();
                  try{
                    /* first ekey info */
                    var guestId = resultObjs[0].guestId;
                    var userId = resultObjs[0].userId;
                    var tgo = resultObjs[0].tgo;
                    ////////////////////

                    /*maybe length of ekeys returned from certain user*/
                    var resultlength = resultObjs.length;
                    ////////////////////////


                    Navigator.pushNamed(
                      context,
                      '/listekeys',
                      arguments: {'resultObjs' : resultObjs},

                    );

                  }catch(e){
                    print(e);
                  }

                },
                child: const Text('List EKEYS'),
              ),
            ],
          ),
        ),
      )
    );
  }
}

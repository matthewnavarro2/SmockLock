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
  String user = 'Hello User22';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Color.fromRGBO(234, 234, 234, 1),
                Color.fromRGBO(178, 229, 190, 1),
              ]
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * .08),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {},
                  child: const CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.white,
                    backgroundImage:  AssetImage("assets/images/housekey.PNG"),
                  ),
                ),
                IconButton(
                  iconSize: MediaQuery.of(context).size.height * .06,
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/settings',
                    );
                  },
                  icon: const Icon(
                    Icons.settings,
                    //size: DeviceInfo.width,
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * .08),

            Text(
              user,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),

            Image(
              image: AssetImage("assets/images/lock.PNG"),
              height: MediaQuery.of(context).size.height * .2,
              width: MediaQuery.of(context).size.width * .2,
            ),

            SizedBox(height: MediaQuery.of(context).size.height * .06),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {},
                  child: const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.blue,
                    backgroundImage:  AssetImage("assets/images/camera.PNG"), // not transparent rn
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.blueGrey,
                    backgroundImage:  AssetImage("assets/images/authorizedusers.PNG"),
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * .04),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {},
                  child: const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.green,
                    backgroundImage:  AssetImage("assets/images/unlocked.PNG"),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.blue,
                    backgroundImage:  AssetImage("assets/images/housekey.PNG"),
                  ),
                ),
              ],
            ),
            /*
            TextButton(
              onPressed: () async {
                isLoggedIn = false;
                await storage.deleteAll();
                Navigator.popUntil(context, ModalRoute.withName('/'));
              },
              child: const Text('Logout'),
            ),
            IconButton(
              iconSize: MediaQuery.of(context).size.height * .08,
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
                print(res.body);

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


                  Navigator.pushNamed(
                    context,
                    '/listekeys',
                    arguments: {'resultObjs': resultObjs},

                  );
                } catch (e) {
                  print(e);
                }
              },
              child: const Text('List EKEYS'),
            ),*/
          ],
        ),
      ),
    );
  }
}
class MyColor extends MaterialStateColor {
  const MyColor() : super(_defaultColor);

  static const int _defaultColor = 0xcafefeed;
  static const int _pressedColor = 0xdeadbeef;

  @override
  Color resolve(Set<MaterialState> states) {
    if (states.contains(MaterialState.pressed)) {
      return const Color(_pressedColor);
    }
    return const Color(_defaultColor);
  }
}
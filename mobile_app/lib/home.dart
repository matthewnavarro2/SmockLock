
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/camerascreen/takepicturescreen.dart';
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
              )
            ],
          ),
        ),
      )
    );
  }
}

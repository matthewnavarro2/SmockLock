import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/camerascreen/takepicturescreen.dart';

class Facerec extends StatefulWidget {
  const Facerec({Key? key}) : super(key: key);

  @override
  _FacerecState createState() => _FacerecState();
}

class _FacerecState extends State<Facerec> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('facerec setup'),
      ),
      body: Column(
        children: [
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
        ],
      ),
    );
  }
}

import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mobile_app/API/api.dart';
import 'package:mobile_app/camerascreen/takepicturescreen.dart';
import 'package:mobile_app/ekeyscreen/parse_json_ekey.dart';
import 'package:mobile_app/main.dart';

import '../API/device_info.dart';
import '../authorizeduserscreen/auth_user_object.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String selectedValue = "-1";
  String userName = '';
  late var jwt;
  var nameList;
  var time = 0;

  @override
  Widget build(BuildContext context) {
    ////////////////////////////////////////////////////////////////////////////////////////
    // This is done everytime the page is built. Set state causes this portion to run again..
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    jwt = arguments['jwt'];
    nameList = arguments['nameList'];
    Map<String, dynamic> decodedToken = JwtDecoder.decode(jwt!);
    List<DropdownMenuItem<String>> dropdownItems = [];

    // NEED TO IMPLEMENT THE FOLLOWING:
    // 1. HANDLE WHEN THERE IS NO LOCKS THE USER IS AUTHORIZED FOR
    // 2. HANDLE WHEN THERE IS ONLY AUTHORIZEDUSER LOCKS for the user

    if(decodedToken["locks"].length > 0){
      //time is used to auto set the lock being used to ur own lock.
      if(time == 0){
        selectedValue = decodedToken["locks"][0]["masterLockId"].toString();
        time++;
      }
      // for loop to populate a list of locks that the account has access to
      for(int i = 0; i < decodedToken["locks"].length; i++){
        if(decodedToken["locks"][i]["access"] == "Master"){
          var masterLockId = decodedToken["locks"][i]["masterLockId"];
          dropdownItems.add(DropdownMenuItem(child: Text("${nameList[i]}'s Lock"), value: masterLockId.toString()));
          if(selectedValue == masterLockId.toString()){
            userName = "${nameList[i]}'s Lock";
          }
        }
        else if(decodedToken["locks"][i]["access"] == "aUser"){
          var masterLockId = decodedToken["locks"][i]["masterLockId"];
          dropdownItems.add(DropdownMenuItem(child: Text("${nameList[i]}'s Lock"), value: masterLockId.toString()));
          if(selectedValue == masterLockId.toString()){
            userName = "${nameList[i]}'s Lock";
          }
        }
      }

    }
    dropdownItems.add(DropdownMenuItem(child: Text("Add a new lock"), value: "-1"));
    var user = decodedToken["userId"];
    // get first and last name of selected value "masterlockid" and assign to userName
    //userName = nameList[parseselectedValue]


    if(selectedValue == "$user")
    {
      // master lock
      print("masterlock");
      return Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [ // background gradient of the homepage
                  Color.fromRGBO(0, 201, 255, 1),
                  Color.fromRGBO(146, 254, 157, 1),
                ]
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * .08),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DropdownButton(
                    value: selectedValue,
                    items: dropdownItems,
                    onChanged: (String? newValue){
                      setState(() {
                        selectedValue = newValue!;
                      });
                    },
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
                userName,
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
                    onPressed: () async {
                      // Get the list of userId who have authorized access to my lock.
                      var userId = decodedToken["userId"];
                      var res = await Api.getLockUI(userId);
                      var resultObjsJson = jsonDecode(res.body);
                      List authorizedUserId = resultObjsJson["result"][0]["AuthorizedUsers"];
                      List authorizedUser = [];
                      for(int i = 0; i < authorizedUserId.length; i++){

                        var user = await Api.getUser(int.parse(authorizedUserId[i]));
                        var result = jsonDecode(user.body);
                        var authUserId = result["result"][0]["UserId"];
                        var email = result["result"][0]["Email"];
                        var firstName = result["result"][0]["FirstName"];
                        var lastName = result["result"][0]["LastName"];
                        AuthorizedUser newUser = AuthorizedUser(authUserId, email, firstName, lastName);
                        authorizedUser.add(newUser);

                      }


                      Navigator.pushNamed(
                        context,
                        '/auth_users',
                        arguments: {'authorizedUser': authorizedUser},
                      );



                    },
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
                    onPressed: () async {
                      var jwt = await storage.read(key:"jwt");
                      Map<String, dynamic> decodedToken = JwtDecoder.decode(jwt!);
                      var userId = decodedToken["userId"];
                      var res = await Api.getLockUI(userId);
                      Map<String, dynamic> jsonObject = jsonDecode(res.body);
                      var ip = jsonObject["result"][0]["IP"];
                      var res1 = await Api.unlockDoor(ip);
                      var trimmed = res1.body.trim();
                      if(trimmed == "Success" || trimmed == "Success\n"){
                        print("success");
                        var errTitle = 'Success';
                        var errMessage = 'Enrollment was succesful.';
                        showAlertDialog(context, errTitle , errMessage).showDialog;
                      }else if(trimmed == "Failed" || trimmed == "Failed\n"){
                        print("Try again, enrollment failed.");
                        var errTitle = 'Error';
                        var errMessage = 'Try again, enrollment failed.';
                        showAlertDialog(context, errTitle , errMessage).showDialog;

                      }else{
                        print(trimmed);
                        print("this mega failed");
                        var errTitle = 'Error';
                        var errMessage = 'Try again, enrollment failed.';
                        showAlertDialog(context, errTitle , errMessage).showDialog;
                      }

                    },
                    child: const CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.green,
                      backgroundImage:  AssetImage("assets/images/unlocked.PNG"),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
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
                        Navigator.pushNamed(
                          context,
                          '/listekeys',
                          arguments: {'resultObjs': resultObjs},

                        );
                      } catch (e) {
                        print(e);
                      }
                    },
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
    else if(selectedValue != "" && selectedValue != "$user" && selectedValue != "-1")
    {
      // auth lock
      print("authlock");
      return Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [ // background gradient of the homepage
                  Color.fromRGBO(41, 128, 185, .78),
                  Color.fromRGBO(109, 213, 250, 1),

                  Color.fromRGBO(255, 255, 255, 1),
                ]
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * .08),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DropdownButton(
                    value: selectedValue,
                    items: dropdownItems,
                    onChanged: (String? newValue){
                      setState(() {
                        selectedValue = newValue!;
                      });
                    },
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
                '$userName As: \nAuthorized User',
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
                    onPressed: () async {
                      var jwt = await storage.read(key:"jwt");
                      Map<String, dynamic> decodedToken = JwtDecoder.decode(jwt!);
                      var userId = decodedToken["userId"];
                      var res = await Api.getLockUI(userId);
                      Map<String, dynamic> jsonObject = jsonDecode(res.body);
                      var ip = jsonObject["result"][0]["IP"];
                      var res1 = await Api.unlockDoor(ip);
                      var trimmed = res1.body.trim();
                      if(trimmed == "Success" || trimmed == "Success\n"){
                        print("success");
                        var errTitle = 'Success';
                        var errMessage = 'Enrollment was succesful.';
                        showAlertDialog(context, errTitle , errMessage).showDialog;
                      }else if(trimmed == "Failed" || trimmed == "Failed\n"){
                        print("Try again, enrollment failed.");
                        var errTitle = 'Error';
                        var errMessage = 'Try again, enrollment failed.';
                        showAlertDialog(context, errTitle , errMessage).showDialog;

                      }else{
                        print(trimmed);
                        print("this mega failed");
                        var errTitle = 'Error';
                        var errMessage = 'Try again, enrollment failed.';
                        showAlertDialog(context, errTitle , errMessage).showDialog;
                      }
                    },
                    child: const CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.green,
                      backgroundImage:  AssetImage("assets/images/unlocked.PNG"),
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
    else if(selectedValue == '' || selectedValue == "-1")
    {
      // no lock
      print("no lock");
      return Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [ // background gradient of the homepage
                  Color.fromRGBO(0, 65, 106, 1),
                  Color.fromRGBO(255, 255, 255, .3),
                ]
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * .08),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DropdownButton(
                    value: selectedValue,
                    items: dropdownItems,
                    onChanged: (String? newValue){
                      setState(() {
                        selectedValue = newValue!;
                      });
                    },
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
                "Welcome to the SMOCK Lock Application",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),

              SizedBox(height: MediaQuery.of(context).size.height * .08),

              ListTile(
                leading: TextButton(
                  onPressed: (){
                    Navigator.pushNamed(context, '/setup');
                  },
                  child: Text("CLICK"),
                ),
                title: Text(
                  "Attach your lock to your account.",
                  style: const TextStyle(
                  ),
                ),
              ),
              ListTile(
                leading: TextButton(
                  onPressed: (){

                  },
                  child: Text("CLICK"),
                ),
                title: Text(
                  "Have a referral code? Join a lock now!",
                  style: const TextStyle(
                  ),
                ),
              ),




            ],
          ),
        ),
      );
    }
    else {
      return Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [ // background gradient of the homepage
                  Color.fromRGBO(234, 234, 234, 1),
                  Color.fromRGBO(178, 229, 190, 1),
                ]
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: MediaQuery
                  .of(context)
                  .size
                  .height * .08),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /* TextButton(
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
                      //*maybe length of ekeys returned from certain user*/
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
                  child: const CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.white,
                    backgroundImage:  AssetImage("assets/images/housekey.PNG"),
                  ),
                ),*/
                  DropdownButton(
                    value: selectedValue,
                    items: dropdownItems,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedValue = newValue!;
                      });
                    },
                  ),

                  IconButton(
                    iconSize: MediaQuery
                        .of(context)
                        .size
                        .height * .06,
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
              SizedBox(height: MediaQuery
                  .of(context)
                  .size
                  .height * .08),
              Text(
                selectedValue,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              Image(
                image: AssetImage("assets/images/lock.PNG"),
                height: MediaQuery
                    .of(context)
                    .size
                    .height * .2,
                width: MediaQuery
                    .of(context)
                    .size
                    .width * .2,
              ),
              SizedBox(height: MediaQuery
                  .of(context)
                  .size
                  .height * .06),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.blue,
                      backgroundImage: AssetImage(
                          "assets/images/camera.PNG"), // not transparent rn
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      // Get the list of userId who have authorized access to my lock.
                      var userId = decodedToken["userId"];
                      var res = await Api.getLockUI(userId);
                      var resultObjsJson = jsonDecode(res.body);
                      List authorizedUserId = resultObjsJson["result"][0]["AuthorizedUsers"];
                      List authorizedUser = [];
                      for (int i = 0; i < authorizedUserId.length; i++) {
                        var user = await Api.getUser(int.parse(
                            authorizedUserId[i]));
                        var result = jsonDecode(user.body);
                        var authUserId = result["result"][0]["UserId"];
                        var email = result["result"][0]["Email"];
                        var firstName = result["result"][0]["FirstName"];
                        var lastName = result["result"][0]["LastName"];
                        AuthorizedUser newUser = AuthorizedUser(
                            authUserId, email, firstName, lastName);
                        authorizedUser.add(newUser);
                      }


                      Navigator.pushNamed(
                        context,
                        '/auth_users',
                        arguments: {'authorizedUser': authorizedUser},
                      );
                    },
                    child: const CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.blueGrey,
                      backgroundImage: AssetImage(
                          "assets/images/authorizedusers.PNG"),
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery
                  .of(context)
                  .size
                  .height * .04),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () async {
                      var jwt = await storage.read(key: "jwt");
                      Map<String, dynamic> decodedToken = JwtDecoder.decode(
                          jwt!);
                      var userId = decodedToken["userId"];
                      var res = await Api.getLockUI(userId);
                      Map<String, dynamic> jsonObject = jsonDecode(res.body);
                      var ip = jsonObject["result"][0]["IP"];
                      var res1 = Api.unlockDoor(ip);
                    },
                    child: const CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.green,
                      backgroundImage: AssetImage("assets/images/unlocked.PNG"),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      var res = await Api.listEKey();
                      var resultObjsJson = jsonDecode(
                          res.body)['result_array'] as List;
                      List<GetResults> resultObjs = resultObjsJson.map((
                          resultJson) =>
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
                    child: const CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.blue,
                      backgroundImage: AssetImage("assets/images/housekey.PNG"),
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

  showAlertDialog(BuildContext context, String title, String message) {

    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }




}
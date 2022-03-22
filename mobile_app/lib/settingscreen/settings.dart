import 'package:flutter/material.dart';

import '../main.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * .02),
          Row(
            children: const [
              Icon(
                Icons.portrait,
                //color: Colors.pink,
                //size: 24.0,
                //semanticLabel: 'Text to announce in accessibility modes',
              ),
              Text('Account')
            ],
          ),
          const Divider(thickness: 2),
          TextButton(
            onPressed: (){},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Edit Username'),
                CircleAvatar(),
              ],
            ),
          ),
          TextButton(
            onPressed: (){},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Change Passowrd'),
                CircleAvatar(),
              ],
            ),
          ),
          TextButton(
            onPressed: (){
              Navigator.pushNamed(context, '/facerec');
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Configure Facial Recognition'),
                CircleAvatar(),
              ],
            ),
          ),
          TextButton(
            onPressed: (){
              Navigator.pushNamed(context, '/finger');
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Configure Fingerprint'),
                CircleAvatar(),
              ],
            ),
          ),
          TextButton(
            onPressed: () async {
              isLoggedIn = false;
              await storage.deleteAll();
              Navigator.popUntil(context, ModalRoute.withName('/'));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Logout'),
                CircleAvatar(),
              ],
            ),
          ),
          Row(
            children: const [
              Icon(
                Icons.lock,
                //color: Colors.pink,
                //size: 24.0,
                //semanticLabel: 'Text to announce in accessibility modes',
              ),
              Text('Lock')
            ],
          ),
          const Divider(thickness: 2),
          TextButton(
            onPressed: (){
              Navigator.pushNamed(context, '/setup');

            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Initial Lock Setup'),
                CircleAvatar(),
              ],
            ),
          ),
          TextButton(
            onPressed: (){
              Navigator.pushNamed(context, '/setup2_2');

            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Edit Security Level'),
                CircleAvatar(),
              ],
            ),
          ),
          Row(
            children: const [
              Icon(
                Icons.mail,
                //color: Colors.pink,
                //size: 24.0,
                //semanticLabel: 'Text to announce in accessibility modes',
              ),
              Text('Notifications')
            ],
          ),
          const Divider(thickness: 2),
          TextButton(
            onPressed: (){},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Notifications'),
                CircleAvatar(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class EKeyLogin extends StatefulWidget {
  const EKeyLogin({Key? key}) : super(key: key);

  @override
  _EKeyLoginState createState() => _EKeyLoginState();
}

class _EKeyLoginState extends State<EKeyLogin> {
  final ekeyController = TextEditingController();

  @override
  void dispose(){
    ekeyController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'E-Key Login',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

        ),
        backgroundColor: Colors.white,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: const Color.fromRGBO(32, 31, 30, 1),
          child: Stack(
            //alignment: AlignmentDirectional.topCenter,
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: (MediaQuery.of(context).size.height) * .05),

                    Container(

                      width: (MediaQuery.of(context).size.width) * 1,
                      height: (MediaQuery.of(context).size.height) * .5,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/smock_lock_bg.PNG"),
                        ),
                      ),
                    ),

                    TextField(

                      controller: ekeyController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.zero),
                        ),
                        label: Text(
                          'E-Key Number',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        fillColor: Color.fromRGBO(255, 255, 255, 1),
                        filled: true,
                      ),
                    ),
                    SizedBox(height: (MediaQuery.of(context).size.height) * .02),

                    SizedBox(height: (MediaQuery.of(context).size.height) * .02),

                    TextButton(
                      onPressed: () async {},
                      child: Container(
                        alignment: AlignmentDirectional.center,
                        height: (MediaQuery.of(context).size.height) * .04,
                        width: (MediaQuery.of(context).size.width) * .3,
                        decoration: const BoxDecoration(
                          color: const Color.fromRGBO(150, 150, 150, 1),

                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 1),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
    );
  }
}

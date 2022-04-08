import 'package:flutter/material.dart';

class AuthorizedUsers extends StatefulWidget {
  const AuthorizedUsers({Key? key}) : super(key: key);

  @override
  _AuthorizedUsersState createState() => _AuthorizedUsersState();
}

class _AuthorizedUsersState extends State<AuthorizedUsers> {
  List authorizedUser = [];
  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    authorizedUser = arguments['authorizedUser'];

    return Scaffold(
      appBar: AppBar(
        title: Text("authorized Users"),
      ),
      body: Column(
        children: [
          SizedBox(
            height: (MediaQuery.of(context).size.height) * .5,
            child: ListView.builder(
                itemCount: authorizedUser.length,
                itemBuilder: (context, index){
                  return Card(
                    child: ListTile(
                      onTap: () {

                      },
                      tileColor: Colors.lightBlueAccent.shade700,
                      minVerticalPadding: (MediaQuery.of(context).size.height) * .025,
                      title:  Row(
                        children: [
                          Text('${authorizedUser[index].firstName}'),
                          Text('${authorizedUser[index].lastName}'),
                          Text('${authorizedUser[index].email}'),

                        ],
                      ),
                      //leading: Text((index+1).toString(),style: const TextStyle(
                      // fontSize: 30.0,
                      // fontWeight: FontWeight.bold,
                      // ),),
                      trailing:  IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          /*
                          Navigator.pushNamed(
                            context,
                            '/editekeys',
                            arguments: {
                              'resultObjs' : resultObjs,
                              'index' : index,
                            },

                          );
                          */
                        },

                      ),


                    ),
                  );
                }
            ),
          ),

        ],
      ),
    );
  }
}

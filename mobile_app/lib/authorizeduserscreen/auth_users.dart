import 'package:flutter/material.dart';

class AuthorizedUsers extends StatefulWidget {
  const AuthorizedUsers({Key? key}) : super(key: key);

  @override
  _AuthorizedUsersState createState() => _AuthorizedUsersState();
}

class _AuthorizedUsersState extends State<AuthorizedUsers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("authorized Users"),
      ),
      /*body: Column(
        children: [
          SizedBox(
            height: (MediaQuery.of(context).size.height) * .5,
            child: ListView.builder(
                itemCount: resultObjs.length,
                itemBuilder: (context, index){
                  return Card(
                    child: ListTile(
                      onTap: () {

                      },
                      tileColor: Colors.lightBlueAccent.shade700,
                      minVerticalPadding: (MediaQuery.of(context).size.height) * .025,
                      title:  FittedBox(
                        fit: BoxFit.fill,
                        child: Row(
                          children: [
                            Text('${resultObjs[index].guestId}    '),
                            Text(resultObjs[index].tgo),
                            Text(resultObjs[index].firstname),
                            Text(resultObjs[index].lastname),
                            Text(resultObjs[index].email),

                          ],
                        ),
                      ),
                      //leading: Text((index+1).toString(),style: const TextStyle(
                      // fontSize: 30.0,
                      // fontWeight: FontWeight.bold,
                      // ),),
                      trailing:  IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/editekeys',
                            arguments: {
                              'resultObjs' : resultObjs,
                              'index' : index,
                            },

                          );
                        },

                      ),


                    ),
                  );
                }
            ),
          ),

        ],
      ),*/
    );
  }
}

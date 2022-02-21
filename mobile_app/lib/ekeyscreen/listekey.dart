import 'package:flutter/material.dart';
import 'package:mobile_app/API/api.dart';
import 'package:mobile_app/ekeyscreen/parse_json_ekey.dart';

class ListEKeys extends StatefulWidget {
  const ListEKeys({Key? key}) : super(key: key);

  @override
  _ListEKeysState createState() => _ListEKeysState();
}

class _ListEKeysState extends State<ListEKeys> {
  var res;
  var listylength = 0;
  late List<GetResults> resultObjs;

  @override
  Widget build(BuildContext context) {

    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    resultObjs = arguments['resultObjs'];
    return Scaffold(
        appBar: AppBar(),
        body: Column(
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
        ),



    );
  }
}

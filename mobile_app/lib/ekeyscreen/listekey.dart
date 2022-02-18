import 'package:flutter/material.dart';
import 'package:mobile_app/API/api.dart';

class ListEKeys extends StatefulWidget {
  const ListEKeys({Key? key}) : super(key: key);

  @override
  _ListEKeysState createState() => _ListEKeysState();
}

class _ListEKeysState extends State<ListEKeys> {
  var res;
  var listylength = 0;
  var resultObjs;

  @override
  Widget build(BuildContext context) {

    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    resultObjs = arguments['resultObjs'];
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                res = await Api.listEKey();
                listylength = res.body[0].length;
              },
              child: const Text('list'),
            ),
            ListView.builder(
                itemCount: resultObjs.length,
                itemBuilder: (context, index){
                  return Card(
                    child: ListTile(
                      onTap: () {

                      },
                      tileColor: Colors.lightBlueAccent.shade700,
                      minVerticalPadding: (MediaQuery.of(context).size.height) * .025,
                      title: const FittedBox(
                        fit: BoxFit.fill,
                        child: Text('fdgf'),
                      ),
                      //leading: Text((index+1).toString(),style: const TextStyle(
                      // fontSize: 30.0,
                      // fontWeight: FontWeight.bold,
                      // ),),
                      trailing: const Icon(Icons.arrow_forward_ios),


                    ),
                  );
                }
            ),

          ],
        ),



    );
  }
}

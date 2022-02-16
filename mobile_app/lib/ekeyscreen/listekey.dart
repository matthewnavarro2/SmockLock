import 'package:flutter/material.dart';
import 'package:mobile_app/API/api.dart';

class ListEKeys extends StatefulWidget {
  const ListEKeys({Key? key}) : super(key: key);

  @override
  _ListEKeysState createState() => _ListEKeysState();
}

class _ListEKeysState extends State<ListEKeys> {

  Future<List> getEKeys() async {
    var res = await Api.listEKey();



    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: ElevatedButton(
          onPressed: () async {
            var res = getEKeys();
            print(res);
          },
          child: const Text('list'),
        ),
     /* body: Container(
        //height: ,
        child: ListView.builder(
            itemCount: GlobalData.resultObjs.length,
            itemBuilder: (context, index){
              return Card(
                child: ListTile(
                  onTap: () {
                    RunData.index = index;
                    print(index);

                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OldRun2()));

                  },
                  tileColor: Colors.lightBlueAccent.shade700,
                  minVerticalPadding: (MediaQuery.of(context).size.height) * .025,
                  title: FittedBox(
                    fit: BoxFit.fill,
                    child: Text('${GlobalData.resultObjs[index].runName}           ${GlobalData.resultObjs[index].dateCreated}',style: const TextStyle(
                      fontSize: 20.7,
                      fontWeight: FontWeight.bold,
                    ),),
                  ),
                  //leading: Text((index+1).toString(),style: const TextStyle(
                  // fontSize: 30.0,
                  // fontWeight: FontWeight.bold,
                  // ),),
                  trailing: Icon(Icons.arrow_forward_ios),


                ),
              );
            }
        ),
      ),,*/


    );
  }
}

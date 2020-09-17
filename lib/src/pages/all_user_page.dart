import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nuevoproyecto/src/login_state.dart';
import 'package:provider/provider.dart';

class AllUsuerPage extends StatelessWidget {
  const AllUsuerPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
        return Consumer<LoginState>(builder: (BuildContext context, LoginState state, Widget child){
        
        //var user = Provider.of<LoginState>(context).currentUser();
        var _query = FirebaseFirestore.instance         
            .collection('users')
            .snapshots();
        
        return Scaffold(
          appBar: AppBar(
            title: Text('Usuarios'),
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream: _query,
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> data){
              if ( data.hasData){
              return ListView.builder(
                itemBuilder: (BuildContext context, int index){
                  var document = data.data.docs[index];
                  print(document);
                  return ListTile(
                      leading: Text(document.get('user').toString()),
                      title: Container(
                        decoration: BoxDecoration(
                          color: Colors.blueAccent.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(5.0)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("\$${document.get('value').toString()}",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold
                            ),  
                          ),
                        ),
                      ),
                  );
                },
                itemCount: data.data.docs.length,
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
            })
        );
    });
  }
}
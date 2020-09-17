import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nuevoproyecto/src/login_state.dart';
import 'package:provider/provider.dart';

class DetailsParams {
  final String name;
  final int month;

  DetailsParams(this.name, this.month);
}

class DetailsPage extends StatefulWidget {

  DetailsPage({Key key,}) : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
    

  @override
  Widget build(BuildContext context) {

    final DetailsParams params = ModalRoute.of(context).settings.arguments;
    return Consumer<LoginState>(builder: (BuildContext context, LoginState state, Widget child){
        
        var user = Provider.of<LoginState>(context).currentUser();
        var _query = FirebaseFirestore.instance         
            .collection('users')
            .doc(user.uid)
            .collection('services')
            .where('month', isEqualTo: params.month)
            .where('name', isEqualTo: params.name)
            .snapshots();
        
        return Scaffold(
          appBar: AppBar(
            title: Text(params.name),
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream: _query,
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> data){
              if ( data.hasData){
              return ListView.builder(
                itemBuilder: (BuildContext context, int index){
                  var document = data.data.docs[index];
                  print(document.id);
                  return Dismissible(
                    key: Key(document.id),
                    onDismissed: (direction) {
                      FirebaseFirestore.instance         
                      .collection('users')
                      .doc(user.uid)
                      .collection('services')
                      .doc(document.id)
                      .delete();
                    },
                    child: ListTile(
                      leading: Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(Icons.calendar_today, size: 40.0,),
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 8,
                            child: Text(document.get('day').toString(), textAlign: TextAlign.center,)
                          ),

                        ],
                      ), 
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

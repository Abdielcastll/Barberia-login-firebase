import 'package:flutter/material.dart';
import 'package:nuevoproyecto/src/login_state.dart';
import 'package:nuevoproyecto/src/pages/add_page.dart';
import 'package:nuevoproyecto/src/pages/all_user_page.dart';
import 'package:nuevoproyecto/src/pages/details_page.dart';
import 'package:nuevoproyecto/src/pages/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:nuevoproyecto/src/pages/login_page.dart';
import 'package:nuevoproyecto/src/utils/theme.dart';
import 'package:provider/provider.dart';
 
void main() { 
  runApp(MyApp());
}
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot){
        if (snapshot.hasError) {
          return Center(child: Text('ERROR'));
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return ChangeNotifierProvider<LoginState>(
            builder: (BuildContext context) => LoginState(),
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Material App',
              theme: miTema,
              routes: {
                '/': (BuildContext context) {
                    var state = Provider.of<LoginState>(context);
                    if(state.isLoggedIn()){ 
                      return HomePage();
                    } else {
                      return LoginPage();  
                    }
                },
                '/add'    : (BuildContext context) => AddPage(),
                '/details':(BuildContext context) => DetailsPage(),
                '/allUser':(BuildContext context) => AllUsuerPage(),
              },
            ),
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    ); 
  }
}


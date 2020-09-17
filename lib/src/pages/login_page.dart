import 'package:flutter/material.dart';
import 'package:nuevoproyecto/src/login_state.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer<LoginState>(
          builder: (context, value, child) {
            if(value.isLoading()){
              return CircularProgressIndicator();
            } else {
              return child;
            }
          },
          child: RaisedButton(
            child: Text('Sign In'),
            onPressed: (){
              Provider.of<LoginState>(context).login();
            }
          ),
        )
      ),
    );
  }
}
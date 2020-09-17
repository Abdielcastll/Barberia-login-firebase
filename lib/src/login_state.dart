import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginState with ChangeNotifier {
  
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  SharedPreferences _prefs;

  bool _loggedIn = false;
  bool isLoggedIn()=>_loggedIn;
  bool _loading = true;
  bool isLoading()=> _loading;
  User _user; 
  User currentUser()=> _user;
  
  LoginState(){
    loginState();
  }

  void login() async {
    _loading = true;
    notifyListeners();

    var user = await signInWithGoogle();
    _user = user.user;


    _loading = false;
    if(user!=null){
      _prefs.setBool('isLoggeIn', true);
      _loggedIn = true;
      notifyListeners();
    } else {
      _loggedIn = false;
      notifyListeners();
    }
  }
  void logout(){
    _prefs.clear();
    _googleSignIn.signOut();
    _loggedIn = false;
    notifyListeners();
  }

  Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

  // Create a new credential
  final GoogleAuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  void loginState() async {
     _prefs = await SharedPreferences.getInstance();
    if (_prefs.containsKey('isLoggeIn')){
      _user = _auth.currentUser;
      _loggedIn = _user != null;
      _loading = false;
      notifyListeners();
    } else {
      _loading = false;
      notifyListeners();
    }
  }
}

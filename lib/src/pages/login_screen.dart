import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();
  String _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            RaisedButton(
              onPressed: _signInWithGoogle,
              child: Text('Continue with google'),
            ),
            _errorMessage != null
                ? Text(_errorMessage, style: TextStyle(color: Colors.red))
                : Container(),
          ],
        ),
      ),
    );
  }

  void _signInWithGoogle() async {
    _setLogginIn();
    String errMsg;
    try {
      final googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.getCredential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
      await _auth.signInWithCredential(credential);
    } catch (e) {
      errMsg = 'Error, por favor intente mas tarde';
    } finally {
      _setLogginIn(false, errMsg);
    }
  }

  void _setLogginIn([bool logginIn = true, String errMsg]) {
    if (mounted) {
      setState(() {
        _loggingIn = logginIn;
        _errorMessage = errMsg;
      });
    }
  }
}

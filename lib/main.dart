import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'src/providers/current_user.dart';
import 'src/pages/login_screen.dart';
import 'src/pages/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      initialData: CurrentUser.initial,
      value: FirebaseAuth.instance.onAuthStateChanged.map(
        (user) => CurrentUser.create(user),
      ),
      child: Consumer<CurrentUser>(
        builder: (context, user, _) => MaterialApp(
          title: 'NW notes',
          debugShowCheckedModeBanner: false,
          home: user.isInitialValue
              ? Scaffold(body: CircularProgressIndicator())
              : user.data != null ? HomeScreen() : LoginScreen(),
        ),
      ),
    );
  }
}

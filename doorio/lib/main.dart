import 'package:doorio/login/root_page.dart';
import 'package:doorio/services/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<FirebaseUser>.value(
            value: FirebaseAuth.instance.onAuthStateChanged),
      ],
      child: MaterialApp(
        title: 'Door.io',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: RootPage(
          auth: new Auth(),
        ),
      ),
    );
  }
}

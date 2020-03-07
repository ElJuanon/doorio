import 'package:doorio/services/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.userId, this.auth, this.onSignedOut})
      : super(key: key);

  final String userId;
  final BaseAuth auth;
  final onSignedOut;
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);

    return Container(
      child: Scaffold(
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(user.displayName??''),
                accountEmail: Text(user.email??''),
              ),
              ListTile(
                title: Text('Entradas'),
                leading: Icon(Icons.insert_drive_file),
              ),
              ListTile(
                title: Text('Cerrar Sesion'),
                leading: Icon(Icons.cancel),
                onTap: () {
                  Navigator.of(context).pop();
                  widget.onSignedOut();
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: Text("Inicio"),
          centerTitle: true,
        ),
      ),
    );
  }
}

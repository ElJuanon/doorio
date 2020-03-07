import 'package:doorio/services/authentication.dart';
import 'package:doorio/services/db.dart';
import 'package:doorio/utils/models.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  HomePage({Key key, this.userId, this.auth, this.onSignedOut})
      : super(key: key);

  final String userId;
  final BaseAuth auth;
  final onSignedOut;

  void _signOut() {
    onSignedOut();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);

    return MultiProvider(
      providers: [
        StreamProvider<UserProfile>.value(
          value: DatabaseService().streamUserProfile(user.uid),
        )
      ],
      child: _HomePage(
        onSignedOut: _signOut,
      ),
    );
  }
}

class _HomePage extends StatelessWidget {
  _HomePage({Key key, this.onSignedOut}) : super(key: key);

  final onSignedOut;

  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    UserProfile _userProfile = Provider.of<UserProfile>(context);

    return Container(
      child: Scaffold(
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(user.displayName ?? ''),
                accountEmail: Text(user.email ?? ''),
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
                  onSignedOut();
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: Text("Inicio"),
          centerTitle: true,
        ),
        body: _showBody(_userProfile),
      ),
    );
  }

  _showBody(UserProfile _userProfile) {
    try {
      switch (_userProfile.type) {
        case "visitor":
          //cuando es visita mostramos lo sig
          return _guestPage();
          break;
        case "user":
          //cuando es usuario
          return _userPage();
          break;
        case "admin":
          //cuando es admin
          return _adminPage();
          break;
        case "super":
          //cuando es superAdmin
          return _superPage();
          break;
        default:
          Container();
      }
    } catch (e) {
      print(e);
      return Container();
    }
  }

  _guestPage() {
    return Container(
      child: Column(
        children: <Widget>[
          //aqui va la pagina de visita
          Text('visita'),
        ],
      ),
    );
  }

  _userPage() {
    return Container(
      child: Column(
        children: <Widget>[
          //aqui va la pagina de usuarios
          Text('usuario'),
        ],
      ),
    );
  }

  _adminPage() {
    return Container(
      child: Column(
        children: <Widget>[
          //aqui va la pagina de admin
          Text('admin'),
        ],
      ),
    );
  }

  _superPage() {
    return Container(
      child: Column(
        children: <Widget>[
          //aqui va la pagina de super usuarios
          Text('super user'),
        ],
      ),
    );
  }
}

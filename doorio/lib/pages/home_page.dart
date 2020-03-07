import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doorio/services/authentication.dart';
import 'package:doorio/services/db.dart';
import 'package:doorio/utils/colors.dart';
import 'package:doorio/utils/models.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  String _codigo = '';
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
        body: _showBody(_userProfile, context),
      ),
    );
  }

  _showBody(UserProfile _userProfile, BuildContext context) {
    if (_userProfile != null) {
      try {
        switch (_userProfile.type) {
          case "visitor":
            //cuando es visita mostramos lo sig
            return _guestPage(context);
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
    } else {
      return Container();
    }
  }

  _guestPage(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
            child: SizedBox(
              height: 40.0,
              child: new RaisedButton(
                elevation: 5.0,
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0)),
                color: AsterColors.buttons,
                child: Container(),
                onPressed: () {},
              ),
            ),
          ),
          //aqui va la pagina de visita
          Center(
            child: Text(
              'Crear pase nuevo',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: RaisedButton(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext bc) {
                      return StatefulBuilder(
                          builder: (BuildContext context, StateSetter state) {
                        return Container(
                          padding: EdgeInsets.all(16),
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Ingresa Codigo',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.black),
                              ),
                              Text(
                                'Pega el codigo que te envió un residente',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black),
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 0),
                                child: TextFormField(
                                  keyboardType: TextInputType.text,
                                  maxLength: 28,
                                  autofocus: true,
                                  // inputFormatters: [
                                  //   WhitelistingTextInputFormatter(
                                  //       RegExp("[0-9]")),
                                  // ],
                                  onChanged: (text) {
                                    _codigo = text;
                                  },
                                  decoration: InputDecoration(
                                    labelText: "Codigo para generar pase.",
                                  ),
                                  autovalidate: true,
                                  autocorrect: false,
                                  maxLengthEnforced: true,
                                  // validator: (value) {
                                  //   if (value.length == 0) {
                                  //     return null;
                                  //   } else {
                                  //     return !isValid
                                  //         ? 'Favor de proporcionar un numero celular de 10 digitos'
                                  //         : null;
                                  //   }
                                  // },
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(16),
                                child: Center(
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.85,
                                    child: RaisedButton(
                                      color: AsterColors.appColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(0.0)),
                                      child: Text(
                                        "CONTINUAR",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      onPressed: () {
                                        Firestore.instance
                                            .collection('pass')
                                            .document(_codigo)
                                            .get()
                                            .then((DocumentSnapshot _doc) {
                                          print('error: ');
                                          //si existe
                                        }).catchError((e) {
                                          print('error: '+e);

                                        });
                                        // if (isValid) {
                                        //   //validar que no exista una cuenta con el mismo numero
                                        //   if (_formMode == FormMode.SIGNUP) {
                                        //     _getUserAccount(
                                        //         int.parse(_phoneNumberController.text));
                                        //   } else {
                                        //     _getUserAccountSignIn(
                                        //         int.parse(_phoneNumberController.text));
                                        //   }
                                        // } else {
                                        //   validate(state);
                                        // }
                                      },
                                      padding: EdgeInsets.all(16.0),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                    });
              },
              child: Text(
                'Crear',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              color: AsterColors.appColor,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
          ),
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

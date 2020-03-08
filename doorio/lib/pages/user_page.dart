import 'package:doorio/pages/inv_person.dart';
import 'package:doorio/pages/open_gate.dart';
import 'package:doorio/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserPage extends StatefulWidget {
  UserPage({Key key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    FirebaseUser _user = Provider.of<FirebaseUser>(context);
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 25),
            child: Center(
              child: RaisedButton(
                color: AsterColors.buttons,
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Text(
                  "ENTRAR",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      actions: <Widget>[
                        FlatButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            'Cancelar',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        FlatButton(
                          onPressed: () {
                            //manda señal a firebase para abrir puerta
                            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=>OpenGate()),);
                          },
                          child: Text(
                            'Aceptar',
                            style: TextStyle(fontSize: 18),
                          ),
                        )
                      ],
                      title: Center(
                        child: Column(
                          children: <Widget>[
                            Text(
                                '¿Estas seguro de que quieres abrir la puerta?'),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                padding: EdgeInsets.all(16.0),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: RaisedButton(
              color: AsterColors.buttons,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Text(
                "INVITACION PERSONAL",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => InvitacionP(
                      user: _user,
                      qrI: true,
                    ),
                  ),
                );
              },
              padding: EdgeInsets.all(16.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(0),
            child: RaisedButton(
              color: AsterColors.buttons,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Text(
                "EVENTO",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => InvitacionP(
                      user: _user,
                      qrI: false,
                    ),
                  ),
                );
              },
              padding: EdgeInsets.all(16.0),
            ),
          ),
        ],
      ),
    );
  }
}

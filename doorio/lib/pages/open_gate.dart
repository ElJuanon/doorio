import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doorio/utils/colors.dart';
import 'package:flutter/material.dart';

class OpenGate extends StatefulWidget {
  OpenGate({Key key, this.pass}) : super(key: key);

  final DocumentSnapshot pass;

  @override
  _OpenGateState createState() => _OpenGateState();
}

class _OpenGateState extends State<OpenGate> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Abrir Puerta'),
          centerTitle: true,
          backgroundColor: AsterColors.appColor,
        ),
        body: Column(
          children: <Widget>[
            ListTile(
              title: Text(''),
            ),
          ],
        ),
      ),
    );
  }
}

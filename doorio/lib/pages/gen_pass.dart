import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doorio/utils/colors.dart';
import 'package:flutter/material.dart';

class GenPass extends StatefulWidget {
  GenPass({Key key, this.pass}) : super(key: key);

  final DocumentSnapshot pass;

  @override
  _GenPassState createState() => _GenPassState();
}

class _GenPassState extends State<GenPass> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Generar Pase'),
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

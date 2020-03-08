import 'package:doorio/utils/colors.dart';
import 'package:flutter/material.dart';

class SuperStuff extends StatefulWidget {
  SuperStuff({Key key}) : super(key: key);

  @override
  _SuperStuffState createState() => _SuperStuffState();
}

class _SuperStuffState extends State<SuperStuff> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Super Stuff'),
          centerTitle: true,
          backgroundColor: AsterColors.appColor,
        ),
        body: Center(
          child: Text('Coming Soon...', style: TextStyle(fontSize: 20)),
        ),
      ),
    );
  }
}

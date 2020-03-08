import 'package:doorio/utils/colors.dart';
import 'package:flutter/material.dart';

class AdminStuff extends StatefulWidget {
  AdminStuff({Key key}) : super(key: key);

  @override
  _AdminStuffState createState() => _AdminStuffState();
}

class _AdminStuffState extends State<AdminStuff> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Admin Stuff'),
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

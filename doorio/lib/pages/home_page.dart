import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
 HomePage({Key key}) : super(key: key);

  @override
   HomePageState createState() =>  HomePageState();
}

class  HomePageState extends State <HomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
       child: Scaffold(
         appBar: AppBar(
           title: Text("Inicio"),
         ),
       ),
    );
  }
}

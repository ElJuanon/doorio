import 'package:doorio/utils/colors.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';

class ShareCode extends StatefulWidget {
  ShareCode({Key key, @required this.docID, @required this.ref})
      : super(key: key);
  final String docID;
  final String ref;
  @override
  _ShareCodeState createState() => _ShareCodeState();
}

class _ShareCodeState extends State<ShareCode> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Compartir invitacion'),
          centerTitle: true,
          backgroundColor: DoorColors.appColor,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(20),
                  //color: Colors.white,
                  child: Text(
                    'Puedes compartir tu codigo con tus amigos y familiarias, quienes tambien deben tener la app.',
                    style: TextStyle(fontSize: 22),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(20),
                  color: Colors.white,
                  child: Text(
                    widget.ref,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                elevation: 5.0,
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0)),
                color: DoorColors.buttons,
                onPressed: () {
                  Share.text(
                      'my text title', widget.ref, 'text/plain');
                },
                child: Text(
                  'Compartir',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

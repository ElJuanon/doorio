import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doorio/pages/share_code.dart';
import 'package:doorio/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';

class InvitacionP extends StatefulWidget {
  InvitacionP({Key key, this.qrI, @required this.user}) : super(key: key);

  final bool qrI;
  final FirebaseUser user;
  @override
  _InvitacionPState createState() => _InvitacionPState();
}

class _InvitacionPState extends State<InvitacionP> {
  int _numAccesos = 0;
  String _fecha = '';
  DateTime _buffer;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);

    return Container(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: DoorColors.appColor,
          title: Text(widget.qrI ? 'Invitacion Personal' : 'Evento'),
          centerTitle: true,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          children: <Widget>[
            (widget.qrI) ? Container() : _getNumInv(),
            (widget.qrI) ? Container() : _getFecha(),
            (widget.qrI) ? Container() : _showFecha(),
            (widget.qrI) ? _showIndvMsg() : Container(),
            _genPass(user),
          ],
        ),
      ),
    );
  }

  _showIndvMsg() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Text(
          'Una invitación individual es vigente desde el momento en el que es creado, hasta las 23:59.',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  _getNumInv() {
    return ListTile(
      title: Text(
        'Numero de invitados:',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          RaisedButton(
            child: Text(
              '-',
              style: TextStyle(fontSize: 25),
            ),
            onPressed: () {
              if (_numAccesos > 0) {
                setState(() {
                  _numAccesos--;
                });
              }
            },
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            color: Colors.white,
            child: FlatButton(
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Numero de invitados',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black),
                            ),
                            Text(
                              'Ingresa la cantidad de invitados',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 0),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                onEditingComplete: () =>
                                    Navigator.of(context).pop(),
                                autofocus: true,
                                maxLength: 3,
                                inputFormatters: [
                                  WhitelistingTextInputFormatter(
                                      RegExp("[0-9]")),
                                ],
                                onChanged: (text) {
                                  if (text == '') {
                                    setState(() {
                                      _numAccesos = 0;
                                    });
                                  } else {
                                    setState(() {
                                      _numAccesos = int.parse(text);
                                    });
                                  }
                                },
                                maxLengthEnforced: true,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(16),
                              child: Center(
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.85,
                                  child: RaisedButton(
                                    color: DoorColors.buttons,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(0.0)),
                                    child: Text('OK'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
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
                  },
                );
              },
              child: Container(child: Text(_numAccesos.toString())),
            ),
          ),
          RaisedButton(
            child: Text(
              '+',
              style: TextStyle(fontSize: 20),
            ),
            onPressed: () {
              if (_numAccesos < 999) {
                setState(() {
                  _numAccesos++;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  _getFecha() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: FlatButton(
        padding: EdgeInsets.symmetric(vertical: 20),
        onPressed: () async {
          String _dayBuffer;
          String _monthBuffer;
          DateTime _buffer = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now().subtract(Duration(days: 1)),
            lastDate: DateTime(2030),
          );
          if (_buffer != null) {
            if (_buffer.day < 10) {
              _dayBuffer = "0" + _buffer.day.toString();
            } else {
              _dayBuffer = _buffer.day.toString();
            }
            if (_buffer.month < 10) {
              _monthBuffer = "0" + _buffer.month.toString();
            } else {
              _monthBuffer = _buffer.month.toString();
            }
            setState(() {
              _fecha = _dayBuffer + _monthBuffer + _buffer.year.toString();
              this._buffer = _buffer;
            });
            print(_fecha);
          }
        },
        child: Text(
          'Elige la fecha',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        color: DoorColors.appColor,
      ),
    );
  }

  _showFecha() {
    return (_fecha != null && _fecha != '')
        ? Center(
            child: Text(
              (_fecha.substring(0, 2) +
                  "/" +
                  _fecha.substring(2, 4) +
                  "/" +
                  _fecha.substring(4, 8)),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          )
        : Container();
  }

  Widget _genPass(FirebaseUser _user) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: RaisedButton(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          elevation: 5.0,
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0)),
          color: DoorColors.buttons,
          onPressed: () {
            if (widget.qrI) {
              //es una invitacion individual
              _giveINDCode(_user);
            } else {
              //es un evento
              _giveEVNTCode(_user);
            }
          },
          child: Text(
            'Generar Pase',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }

  _giveINDCode(FirebaseUser _user) {
    //fecha---------
    String _dayBuffer;
    String _monthBuffer;
    DateTime _buffer = DateTime.now();
    if (_buffer != null) {
      if (_buffer.day < 10) {
        _dayBuffer = "0" + _buffer.day.toString();
      } else {
        _dayBuffer = _buffer.day.toString();
      }
      if (_buffer.month < 10) {
        _monthBuffer = "0" + _buffer.month.toString();
      } else {
        _monthBuffer = _buffer.month.toString();
      }
      _fecha = _dayBuffer + _monthBuffer + _buffer.year.toString();

      print(_fecha);
    }
    //-------------------
    //subir a pase
    String _ref = randomAlphaNumeric(20);

    Firestore.instance.collection('pass').document(_ref).setData({
      "uid": _user.uid,
      "fechaCreacion": Timestamp.now(),
      "fechaAcceso": _buffer,
      "numeroAccesos": 1,
      "evento": false,
    });

    String _docID =
        Firestore.instance.collection('pass').document(_ref).documentID;

    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (BuildContext context) => ShareCode(
                docID: _docID,
                ref: _ref,
              )),
    );
  }

  _giveEVNTCode(FirebaseUser _user) {
    if (_numAccesos > 0) {
      if (_fecha != '') {
        //subir a pass
        String _ref = randomAlphaNumeric(20);
        Firestore.instance.collection('pass').document(_ref).setData({
          "uid": _user.uid,
          "fechaCreacion": Timestamp.now(),
          "fechaAcceso": _buffer,
          "numeroAccesos": _numAccesos,
          "evento": true,
        });

        String _docID =
            Firestore.instance.collection('pass').document(_ref).documentID;

        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (BuildContext context) => ShareCode(
                    docID: _docID,
                    ref: _ref,
                  )),
        );
      } else {
        //no ingresó fecha
        Fluttertoast.showToast(
            msg: "No ingresó fecha",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } else {
      //no ingresó el numero de invitados
      Fluttertoast.showToast(
          msg: "No ingresó el numero de invitados",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}

import 'package:doorio/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:doorio/services/authentication.dart';

class LoginSignUpPage extends StatefulWidget {
  LoginSignUpPage({this.auth, this.onSignedIn});

  final BaseAuth auth;
  final VoidCallback onSignedIn;

  @override
  State<StatefulWidget> createState() => new _LoginSignUpPageState();
}

enum FormMode { LOGIN, SIGNUP }

class _LoginSignUpPageState extends State<LoginSignUpPage> {
  final _formKey = new GlobalKey<FormState>();

  static const schools = <String>[
    'IT Culiacán',
    'UAdeO',
    'UAS C.U.',
    'Tec de Monterrey',
    'TecMilenio',
    'Universidad de Durango',
    'Casa Blanca',
    'Escuela Normal Sinaloa',
  ];

  final List<PopupMenuItem<String>> _popUpMenuSchools = schools
      .map(
        (String value) => PopupMenuItem<String>(
          value: value,
          child: Text(value),
        ),
      )
      .toList();

  String _userName;
  String _email = '';
  String _school;
  String _major;
  String _password = '';
  String _passwordConfirm = '';
  String _errorMessage;
  bool _passwordVisible = true;

  // Initial form is login form
  FormMode _formMode = FormMode.SIGNUP;
  bool _isIos;
  bool _isLoading;

  // void _getData() async {
  //   QuerySnapshot doc = await Firestore.instance
  //       .collection('schools')
  //       .where('city', isEqualTo: 'Culiacán')
  //       .getDocuments();

  //   DocumentSnapshot doc2 = await Firestore.instance
  //       .collection('majors')
  //       .document('Culiacán')
  //       .get();
  //   //record.colleges.
  // }

  // void _getMajor()async{

  // DocumentSnapshot doc2 = await Firestore.instance
  //     .collection('majors')
  //     .document('Culiacán')
  //     .get();

  // }

  // Check if form is valid before perform login or signup
  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  // Perform login or signup
  void _validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (_validateAndSave()) {
      String userId = "";
      try {
        if (_formMode == FormMode.LOGIN) {
          userId = await widget.auth.signIn(_email, _password);
          print('Signed in: $userId');
        } else {
          if (_userName != null && _school != null && _major != null) {
            userId = await widget.auth
                .signUp(_userName, _email, _school, _major, _password);
            //widget.auth.sendEmailVerification();
            //_showVerifyEmailSentDialog();
            print('Signed up user: $userId');
          } else {
            _errorMessage = 'Llena por completo el formulario.';
          }
        }
        setState(() {
          _isLoading = false;
        });

        if (userId.length > 0 &&
            userId != null &&
            _formMode == FormMode.LOGIN) {
          widget.onSignedIn();
        }

        if (userId.length > 0 &&
            userId != null &&
            _formMode == FormMode.SIGNUP) {
          widget.onSignedIn();
        }
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          if (_isIos) {
            _errorMessage = e.details;
          } else
            _errorMessage = e.message;
        });
      }
    } else {
      _isLoading = false;
    }
  }

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    super.initState();
  }

  void _changeFormToSignUp() {
    _formKey.currentState.reset();
    _errorMessage = "";
    setState(() {
      _formMode = FormMode.SIGNUP;
    });
  }

  void _changeFormToLogin() {
    _formKey.currentState.reset();
    _errorMessage = "";
    setState(() {
      _formMode = FormMode.LOGIN;
    });
  }

  @override
  Widget build(BuildContext context) {
    _isIos = Theme.of(context).platform == TargetPlatform.iOS;
    // if(Platform.isIOS){
    //   return CupertinoPageScaffold(
    //     navigationBar: CupertinoNavigationBar(
    //       middle: Text('Iniciar sesión'),
    //     ),
    //     child: Stack(
    //       children: <Widget>[
    //         _showBody(),
    //         _showCircularProgress(),
    //       ],
    //     ),
    //   );
    // }else if(Platform.isAndroid){
    return new Scaffold(
        appBar: new AppBar(
          backgroundColor: AsterColors.appColor,
          title: new Text(
              (_formMode == FormMode.LOGIN) ? 'Iniciar sesión' : 'Regístrate'),
          centerTitle: true,
        ),
        body: Stack(
          children: <Widget>[
            _showBody(),
            _showCircularProgress(),
          ],
        ));
    //}
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  // void _showVerifyEmailSentDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       // return object of type Dialog
  //       return AlertDialog(
  //         title: new Text("Verificar cuenta"),
  //         content:
  //             new Text("Link to verify account has been sent to your email"),
  //         actions: <Widget>[
  //           new FlatButton(
  //             child: new Text("Dismiss"),
  //             onPressed: () {
  //               //_changeFormToLogin();
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  Widget _showBody() {
    return new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              //_showLogo(),
              _showUserNameInput(),
              _showEmailInput(),
              _showPasswordInput(),
              _showConfirmPasswordInput(),
              Divider(),
              //_showUserSchoolInput(),
              //_showUserMajorInput(),
              _showErrorMessage(),
              _showPrimaryButton(),
              _showSecondaryButton(),
            ],
          ),
        ));
  }

  Widget _showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return new Text(
        _errorMessage,
        style: TextStyle(
            fontSize: 15.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  Widget _showLogo() {
    return new Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 100.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 48.1,
          child: Image.asset('assets/logo/astter_logo.png'),
        ),
      ),
    );
  }

  Widget _showUserNameInput() {
    if (_formMode == FormMode.SIGNUP) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        child: TextFormField(
          maxLines: 1,
          maxLength: 45,
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.words,
          decoration: new InputDecoration(
              hintText: 'Nombre Completo',
              icon: new Icon(
                Icons.account_circle,
                color: Colors.grey,
              )),
          validator: (value) {
            if (value.length < 35 && value != null && value.length >= 3) {
              return null;
            } else {
              return 'Introduzca un nombre valido. (> 3 & < 35 caracteres)';
            }
          },
          onSaved: (value) => _userName = value,
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        textCapitalization: TextCapitalization.sentences,
        maxLength: 45,
        decoration: new InputDecoration(
            hintText: 'Email',
            icon: new Icon(
              Icons.mail,
              color: Colors.grey,
            )),
        validator: (value) {
          if (value.contains('@') && value.length < 30 && value != null) {
            return null;
          } else {
            return 'Introduzca un email valido. (menor a 30 caracteres)';
          }
        },
        onSaved: (value) => _email = value,
      ),
    );
  }

  Widget _showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      child: new TextFormField(
        onChanged: (value) => _passwordConfirm = value,
        maxLines: 1,
        maxLength: 45,
        obscureText: _passwordVisible,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Contraseña',
            icon: new Icon(
              Icons.lock,
              color: Colors.grey,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                  (_passwordVisible) ? Icons.remove_red_eye : Icons.cancel),
              onPressed: () {
                setState(() {
                  if (_passwordVisible) {
                    _passwordVisible = false;
                  } else {
                    _passwordVisible = true;
                  }
                });
              },
            )),
        validator: (value) {
          if (value.length >= 6 && value.length < 30 && value != null) {
            return null;
          } else {
            return 'Introduzca una contraseña valida. (> 6 & < 30 caracteres)';
          }
        },
        onSaved: (value) {
          if (_formMode == FormMode.LOGIN) {
            _password = value;
          }
        },
      ),
    );
  }

  Widget _showConfirmPasswordInput() {
    if (_formMode == FormMode.SIGNUP) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        child: new TextFormField(
          maxLines: 1,
          maxLength: 45,
          obscureText: _passwordVisible,
          autofocus: false,
          decoration: new InputDecoration(
              hintText: 'Confirmar Contraseña',
              icon: new Icon(
                Icons.lock,
                color: Colors.grey,
              )),
          validator: (value) {
            if (value.length >= 6 && value.length < 30 && value != null) {
              if (value == _passwordConfirm) {
                return null;
              } else {
                return 'La contraseña no coincide.';
              }
            } else {
              return 'Introduzca una contraseña valida. (> 6 & < 30 caracteres)';
            }
          },
          onSaved: (value) => _password = value,
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _showPrimaryButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            color: AsterColors.appColor,
            child: _formMode == FormMode.LOGIN
                ? new Text('Iniciar sesión',
                    style: new TextStyle(fontSize: 20.0, color: Colors.white))
                : new Text('Crear cuenta',
                    style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: _validateAndSubmit,
          ),
        ));
  }

  Widget _showSecondaryButton() {
    return new FlatButton(
        child: _formMode == FormMode.LOGIN
            ? new Text('Crear una cuenta',
                style:
                    new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300))
            : new Text('Ya tiene cuenta? Iniciar sesión',
                style:
                    new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
        onPressed: () {
          setState(() {
            (_formMode == FormMode.LOGIN)
                ? _changeFormToSignUp()
                : _changeFormToLogin();
          });
        });
  }
}

class Record {
  final String city;
  final String type;

  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : city = map['city'],
        type = map['type'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$city:$type:$reference>";
}

class Record2 {
  final String campus;
  final String city;

  final DocumentReference reference;

  Record2.fromMap(Map<String, dynamic> map, {this.reference})
      : campus = map['campus'],
        city = map['city'];

  Record2.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$campus:$city:$reference>";
}

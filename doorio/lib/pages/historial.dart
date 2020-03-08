import 'package:doorio/services/db.dart';
import 'package:doorio/utils/colors.dart';
import 'package:doorio/utils/models.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Historial extends StatelessWidget {
  Historial({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    if (user != null) {
      return StreamProvider<List<HistorialInvitacion>>.value(
          value: DatabaseService().streamClaseList(user), child: _Historial());
    } else {
      return Container();
    }
  }
}

class _Historial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AsterColors.appColor,
          title: Text('Historial'),
          centerTitle: true,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    List<HistorialInvitacion> query;
    bool queryEmpty = false;

    query = Provider.of<List<HistorialInvitacion>>(context);

    if (query != null) {
      if (queryEmpty) {
        return ListView(
          padding: EdgeInsets.only(top: 100),
          children: <Widget>[
            Center(
              child: Text('No tienes historial'),
            ),
          ],
        );
      } else {
        return _buildList(context, query);
      }
    } else {
      return Container();
    }
  }

  Widget _buildList(BuildContext context, List<HistorialInvitacion> snapshot) {
    return ListView(
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, HistorialInvitacion data) {
    return ListTile(
      title: Text(
        (data.evento) ? 'Evento' : 'Pase Individual',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
          data.fechaAcceso.toString().substring(0, 10) +
              '   Hora: ' +
              data.fechaAcceso.hour.toString() +
              ':' +
              data.fechaAcceso.minute.toString(),
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }
}

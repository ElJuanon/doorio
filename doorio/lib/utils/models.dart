import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String userName;
  final String uid;
  final Timestamp created;
  final String type;

  UserProfile({this.userName, this.uid, this.created, this.type});

  factory UserProfile.fromMap(Map data) {
    return UserProfile(
      userName: data['userName'] ?? '',
      uid: data['uid'] ?? '',
      created: data['created'] ?? null,
      type: data['type'] ?? '',
    );
  }
}

class HistorialInvitacion {
  final String uid;
  final int numeroAccesos;
  final bool evento;
  final DateTime fechaAcceso;
  final DateTime fechaCreacion;

  final DocumentReference reference;

  HistorialInvitacion(
      {this.uid,
      this.numeroAccesos,
      this.evento,
      this.fechaAcceso,
      this.fechaCreacion,
      this.reference});

  factory HistorialInvitacion.fromMap(Map data) {
    return HistorialInvitacion(
      uid: data['uid'] ?? '',
      numeroAccesos: data['numeroAccesos'] ?? '',
      evento: data['evento'] ?? false,
      fechaAcceso: data['fechaAcceso'] ?? DateTime.now(),
      fechaCreacion: data['fechaCreacion'] ?? DateTime.now(),
    );
  }
  factory HistorialInvitacion.fromSnapshot(
      DocumentSnapshot data, DocumentReference reference) {
    return HistorialInvitacion(
        uid: data['uid'] ?? '',
        numeroAccesos: data['numeroAccesos'] ?? 0,
        evento: data['evento'] ?? false,
        fechaAcceso: data['fechaAcceso'] ?? DateTime.now(),
        fechaCreacion: data['fechaCreacion'] ?? DateTime.now(),
        reference: reference);
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doorio/utils/models.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final Firestore _db = Firestore.instance;

  //un stream de un solo documento
  Stream<UserProfile> streamUserProfile(String id) {
    return _db
        .collection('users')
        .document(id)
        .snapshots()
        .map((snap) => UserProfile.fromMap(snap.data));
  }

  //stream para lista de clases pendientes asesor
  Stream<List<HistorialInvitacion>> streamClaseList(FirebaseUser user) {
    var ref = _db
        .collection("pass")
        .orderBy("fechaAcceso", descending: true)
        .where('uid', isEqualTo: user.uid)
        .limit(20);

    return ref.snapshots().map((list) => list.documents
        .map((doc) => HistorialInvitacion.fromSnapshot(doc, doc.reference))
        .toList());
  }
}
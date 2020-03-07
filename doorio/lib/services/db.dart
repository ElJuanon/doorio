import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doorio/utils/models.dart';

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

}
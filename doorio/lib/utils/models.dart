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

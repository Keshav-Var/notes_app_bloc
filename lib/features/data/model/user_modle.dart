import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes_app/features/bussiness/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    super.name,
    super.email,
    super.uid,
    super.status,
    super.password,
  });

  factory UserModel.fromSnapshot(DocumentSnapshot documentSnapshot) {
    return UserModel(
      name: documentSnapshot.get('name'),
      status: documentSnapshot.get('status'),
      email: documentSnapshot.get('email'),
      uid: documentSnapshot.get('uid'),
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      "status": status,
      "uid": uid,
      "email": email,
      "name": name,
    };
  }
}

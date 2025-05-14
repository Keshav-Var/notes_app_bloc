import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? name;
  final String? email;
  final String? uid;
  final String? status;
  final String? password;

  const UserEntity({
    this.email,
    this.name,
    this.password,
    this.status = "Hello, there i'm using this name.",
    this.uid,
  });

  @override
  List<Object?> get props => [
        name,
        email,
        uid,
        status,
        password,
      ];
}

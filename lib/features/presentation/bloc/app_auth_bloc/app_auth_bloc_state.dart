import 'package:equatable/equatable.dart';

abstract class AppAuthState extends Equatable {
  const AppAuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AppAuthState {}

class Authenticated extends AppAuthState {
  final String uid;

  const Authenticated(this.uid);

  @override
  List<Object?> get props => [uid];
}

class Unauthenticated extends AppAuthState {}

import 'package:equatable/equatable.dart';

abstract class AppAuthEvent extends Equatable {
  const AppAuthEvent();

  @override
  List<Object?> get props => [];
}

class AppStarted extends AppAuthEvent {}

class SignedIn extends AppAuthEvent {}

class SignedOut extends AppAuthEvent {}

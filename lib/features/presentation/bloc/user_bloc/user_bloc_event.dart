import 'package:equatable/equatable.dart';
import 'package:notes_app/features/bussiness/entities/user_entity.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class SignInSubmitted extends UserEvent {
  final UserEntity user;

  const SignInSubmitted(this.user);

  @override
  List<Object?> get props => [user];
}

class SignUpSubmitted extends UserEvent {
  final UserEntity user;

  const SignUpSubmitted(this.user);

  @override
  List<Object?> get props => [user];
}

class ToggleUserEvent extends UserEvent {}

class ResetUserError extends UserEvent {}

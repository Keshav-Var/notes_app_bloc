import 'package:notes_app/features/bussiness/entities/user_entity.dart';
import 'package:notes_app/features/bussiness/repositories/firebase_repository.dart';

class SignUpUsecase {
  final FirebaseRepository repository;

  const SignUpUsecase({required this.repository});

  Future<void> call(UserEntity user) {
    return repository.signUp(user);
  }
}

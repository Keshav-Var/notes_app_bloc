import 'package:notes_app/features/bussiness/entities/user_entity.dart';
import 'package:notes_app/features/bussiness/repositories/firebase_repository.dart';

class SignInUsecase {
  final FirebaseRepository repository;

  SignInUsecase({required this.repository});

  Future<void> call(UserEntity user) async {
    return repository.signIn(user);
  }
}

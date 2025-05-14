import 'package:notes_app/features/bussiness/repositories/firebase_repository.dart';

class SignOutUsecase {
  final FirebaseRepository repository;

  SignOutUsecase({required this.repository});

  Future<void> call() {
    return repository.signOut();
  }
}

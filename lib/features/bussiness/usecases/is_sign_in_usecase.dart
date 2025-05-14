import 'package:notes_app/features/bussiness/repositories/firebase_repository.dart';

class IsSignInUsecase {
  final FirebaseRepository repository;

  IsSignInUsecase({required this.repository});

  Future<bool> call() async {
    return repository.isSignIn();
  }
}

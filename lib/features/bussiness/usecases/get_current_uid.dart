import 'package:notes_app/features/bussiness/repositories/firebase_repository.dart';

class GetCurrentUid {
  final FirebaseRepository repository;

  const GetCurrentUid({required this.repository});

  Future<String> call() {
    return repository.getCurrentUid();
  }
}

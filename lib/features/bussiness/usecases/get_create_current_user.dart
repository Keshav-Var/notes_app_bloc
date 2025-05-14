import 'package:notes_app/features/bussiness/entities/user_entity.dart';
import 'package:notes_app/features/bussiness/repositories/firebase_repository.dart';

class GetCreateCurrentUserUsecase {
  final FirebaseRepository repository;

  GetCreateCurrentUserUsecase({required this.repository});

  Future<void> call(UserEntity user) async {
    return repository.getCreateCurrentUser(user);
  }
}

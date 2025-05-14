import 'package:notes_app/features/bussiness/entities/note_entity.dart';
import 'package:notes_app/features/bussiness/repositories/firebase_repository.dart';

class GetNotesUsecase {
  final FirebaseRepository repository;

  GetNotesUsecase({required this.repository});

  Stream<List<NoteEntity>> call(String uid) {
    return repository.getNotes(uid);
  }
}

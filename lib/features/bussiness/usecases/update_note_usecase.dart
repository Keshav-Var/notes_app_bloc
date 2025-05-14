import 'package:notes_app/features/bussiness/entities/note_entity.dart';
import 'package:notes_app/features/bussiness/repositories/firebase_repository.dart';

class UpdateNoteUsecase {
  final FirebaseRepository repository;

  UpdateNoteUsecase({required this.repository});

  Future<void> call(NoteEntity note) {
    return repository.updateNote(note);
  }
}

import 'package:notes_app/features/bussiness/entities/note_entity.dart';
import 'package:notes_app/features/bussiness/repositories/firebase_repository.dart';

class DeleteNoteUseCase {
  final FirebaseRepository repository;

  DeleteNoteUseCase({required this.repository});

  Future<void> call(NoteEntity note) async {
    return repository.deleteNote(note);
  }
}

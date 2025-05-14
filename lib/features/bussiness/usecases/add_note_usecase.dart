import 'package:notes_app/features/bussiness/entities/note_entity.dart';
import 'package:notes_app/features/bussiness/repositories/firebase_repository.dart';

class AddNoteUseCase {
  final FirebaseRepository repository;

  AddNoteUseCase({required this.repository});

  Future<void> call(NoteEntity note) async {
    return repository.addNote(note);
  }
}

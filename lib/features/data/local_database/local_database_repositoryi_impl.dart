import 'package:hive/hive.dart';
import 'package:notes_app/features/data/local_database/local_database_repository.dart';
import 'package:notes_app/features/data/model/note_model.dart';

class LocalDatabaseRepositoryiImpl implements LocalDatabaseRepository{
  final Box<NoteModel> _noteBox;

  LocalDatabaseRepositoryiImpl({required Box<NoteModel> noteBox}) : _noteBox = noteBox;
  @override
  Future<void> deleteNote(String noteId) async{
    await _noteBox.delete(noteId);
  }

  @override
  Future<List<NoteModel>> fectchNotesFromLocalDatabase() async{
    return _noteBox.values.toList();
  }

  @override
  Future<void> saveNote(NoteModel note) async{
    if (note.noteId != null) {
      await _noteBox.put(note.noteId, note);
    } else {
      throw Exception("Note ID is null, cannot save to local DB");
    }
  }

  @override
  Future<void> updateNote(NoteModel note) async{
    if (note.noteId != null && _noteBox.containsKey(note.noteId)) {
      await _noteBox.put(note.noteId, note);
    } else {
      throw Exception("Note does not exist locally to update");
    }
  }
  
  @override
  Future<void> clearAllNotes() async{
    await _noteBox.clear();
  }

}
import 'package:notes_app/features/data/model/note_model.dart';

abstract class LocalDatabaseRepository {
  Future<List<NoteModel>> fectchNotesFromLocalDatabase();
  Future<void> saveNote(NoteModel note);
  Future<void> updateNote(NoteModel note);
  Future<void> deleteNote(String noteId);
  Future<void> clearAllNotes();

}
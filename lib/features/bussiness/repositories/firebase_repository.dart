import 'package:notes_app/features/bussiness/entities/note_entity.dart';
import 'package:notes_app/features/bussiness/entities/user_entity.dart';

abstract class FirebaseRepository {
  Future<bool> isSignIn();
  Future<void> signIn(UserEntity user);
  Future<void> signUp(UserEntity user);
  Future<void> signOut();
  Future<String> getCurrentUid();
  Future<void> getCreateCurrentUser(UserEntity user);
  Future<void> addNote(NoteEntity note);
  Future<void> updateNote(NoteEntity notes);
  Future<void> deleteNote(NoteEntity note);
  Stream<List<NoteEntity>> getNotes(String uid);
}

import 'package:notes_app/core/network/network_info.dart';
import 'package:notes_app/features/bussiness/entities/note_entity.dart';
import 'package:notes_app/features/bussiness/entities/user_entity.dart';
import 'package:notes_app/features/bussiness/repositories/firebase_repository.dart';
import 'package:notes_app/features/data/local_database/local_database_repository.dart';
import 'package:notes_app/features/data/model/note_model.dart';
import 'package:notes_app/features/data/remote/firebase_remote_data_source.dart';

class FirebaseRepositoryImpl implements FirebaseRepository {
  final LocalDatabaseRepository localDatabaseRepository;
  final FirebaseRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  FirebaseRepositoryImpl( {required this.networkInfo, required this.localDatabaseRepository, required this.remoteDataSource});
  @override
  Future<void> addNote(NoteEntity note)async{
    final isConnected = await networkInfo.isConnected();
    if(isConnected.isRight()){
      String noteId = await remoteDataSource.addNote(note);
    await localDatabaseRepository.saveNote(NoteModel(note: note.note,noteId: noteId, time: note.time,uid: note.uid));
    return;
    }
    else{
      throw Exception("Check your Internet connection.");
    }
  } 

  @override
  Future<void> deleteNote(NoteEntity note) async{
    final isConnected = await networkInfo.isConnected();
    if(isConnected.isRight()){
      await remoteDataSource.deleteNote(note);
      await localDatabaseRepository.deleteNote(note.noteId!);
    return;
    }
    else{
      throw Exception("Check your Internet connection.");
    }

  } 

  @override
  Future<void> getCreateCurrentUser(UserEntity user) =>
      remoteDataSource.getCreateCurrentUser(user);

  @override
  Future<String> getCurrentUid() async =>
      await remoteDataSource.getCurrentUid();

  @override
Stream<List<NoteEntity>> getNotes(String uid) async* {
  final isConnected = await networkInfo.isConnected();

  if (isConnected.isRight()) {
    yield* remoteDataSource.getNotes(uid).asyncMap((fetchedNotes) async {
      // Clear all local notes
      await localDatabaseRepository.clearAllNotes();

      // Save each note from Firebase to local DB with synced status
      for (final note in fetchedNotes) {
        await localDatabaseRepository.saveNote(
          NoteModel(note: note.note,noteId: note.noteId,uid: note.uid,time: note.time),
        );
      }

      return fetchedNotes;
    });
  } else {
    // Offline: return the locally stored notes
    final localNotes = await localDatabaseRepository.fectchNotesFromLocalDatabase();
    yield localNotes;
  }
}
      

  @override
  Future<bool> isSignIn() => remoteDataSource.isSignIn();

  @override
  Future<void> signIn(UserEntity user) => remoteDataSource.signIn(user);

  @override
  Future<void> signOut() async{
    await remoteDataSource.signOut();
    await localDatabaseRepository.clearAllNotes();
  } 

  @override
  Future<void> signUp(UserEntity user) => remoteDataSource.signUp(user);

  @override
  Future<void> updateNote(NoteEntity notes)async{
    final isConnected = await networkInfo.isConnected();
    if(isConnected.isRight()){
      remoteDataSource.updateNote(notes);
      await localDatabaseRepository.updateNote(NoteModel(note: notes.note,noteId: notes.noteId,uid: notes.uid, time: notes.time));
    return;
    }
    else{
      throw Exception("Check your Internet connection.");
    }
  } 
}

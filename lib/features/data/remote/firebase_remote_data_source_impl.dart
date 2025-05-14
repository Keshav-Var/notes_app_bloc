import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes_app/features/bussiness/entities/note_entity.dart';
import 'package:notes_app/features/bussiness/entities/user_entity.dart';
import 'package:notes_app/features/data/remote/firebase_remote_data_source.dart';
import 'package:notes_app/features/data/model/note_model.dart';
import 'package:notes_app/features/data/model/user_modle.dart';

class FirebaseRemoteDataSourceImpl implements FirebaseRemoteDataSource {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  FirebaseRemoteDataSourceImpl({required this.auth, required this.firestore});

  @override
  Future<String> addNote(NoteEntity noteEntity) async {
    try {
      final noteCollectionRef =
          firestore.collection("users").doc(noteEntity.uid).collection("notes");
      // Generate a new note ID
      final noteId = noteCollectionRef.doc().id;

      // Get the note document by its ID to check if it already exists
      final noteSnapshot = await noteCollectionRef.doc(noteId).get();

      final newNote = NoteModel(
        note: noteEntity.note,
        noteId: noteId,
        time: noteEntity.time,
        uid: noteEntity.uid,
      ).toDocument();

      if (!noteSnapshot.exists) {
        await noteCollectionRef.doc(noteId).set(newNote);
      }
      //else {
      //   print("\n note already exists\n");
      // }
      return noteId;
    } catch (e) {
      // print("\nexception in addNote function\n");
      throw "exception in addNote function ${e.toString}";
    }
  }

  @override
  Future<void> deleteNote(NoteEntity noteEntity) async {
    try {
      final noteCollectionRef =
          firestore.collection("users").doc(noteEntity.uid).collection("notes");
      final snapshot = await noteCollectionRef.doc(noteEntity.noteId).get();

      if (snapshot.exists) {
        await noteCollectionRef.doc(noteEntity.noteId).delete();
      }
      return;
    } catch (e) {
      // print(e.toString());
    }
    return;
  }

  @override
  Future<void> getCreateCurrentUser(UserEntity user) async {
    try {
      // Reference to the "users" collection in Firestore
      final userCollectionRef = firestore.collection("users");

      // Get the current user's UID
      final uid = await getCurrentUid();

      // Check if the user document already exists
      final userDoc = await userCollectionRef.doc(uid).get();

      // Create a new UserModel and convert it to a Firestore-compatible format
      final newUser = UserModel(
        uid: uid,
        status: user.status,
        email: user.email,
        name: user.name,
      ).toDocument();

      // If the user doesn't exist, create a new document for the user
      if (!userDoc.exists) {
        await userCollectionRef.doc(uid).set(newUser);
      } else {
        // print('User already exists');
      }
    } catch (e) {
      // Handle any errors that occur during Firestore operations
      // print('Error creating or retrieving user: $e');
    }
  }

  @override
  Future<String> getCurrentUid() async => auth.currentUser!.uid;

  @override
  Stream<List<NoteEntity>> getNotes(String uid) {
    final noteCollectionRef =
        firestore.collection("users").doc(uid).collection("notes");

    return noteCollectionRef.snapshots().map((querySnap) {
      return querySnap.docs
          .map((docSnap) => NoteModel.fromSnapshot(docSnap))
          .toList();
    });
  }

  @override
  Future<bool> isSignIn() async => auth.currentUser?.uid != null;

  @override
  Future<void> signIn(UserEntity user) async => auth.signInWithEmailAndPassword(
      email: user.email!, password: user.password!);

  @override
  Future<void> signOut() async => auth.signOut();

  @override
  Future<void> signUp(UserEntity user) async =>
      auth.createUserWithEmailAndPassword(
          email: user.email!, password: user.password!);

  @override
  Future<void> updateNote(NoteEntity note) async {
    Map<String, dynamic> noteMap = {};
    final noteCollectionRef =
        firestore.collection("users").doc(note.uid).collection("notes");

    if (note.note != null) noteMap['note'] = note.note;
    if (note.time != null) noteMap['time'] = note.time;

    noteCollectionRef.doc(note.noteId).update(noteMap);
  }
}

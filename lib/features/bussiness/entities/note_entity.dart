import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class NoteEntity extends Equatable {
  final String? note;
  final String? noteId;
  final String? uid;
  final Timestamp? time;

  const NoteEntity({
    this.uid,
    this.note,
    this.noteId,
    this.time,
  });
  @override
  List<Object?> get props => [
        note,
        noteId,
        uid,
        time,
      ];
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes_app/features/bussiness/entities/note_entity.dart';
import 'package:hive/hive.dart';
part 'note_model.g.dart';

@HiveType(typeId: 0)
class NoteModel extends NoteEntity {
  @HiveField(0)
  final String? _note;

  @HiveField(1)
  final String? _noteId;

  @HiveField(2)
  final DateTime? _time;

  @HiveField(3)
  final String? _uid;

  NoteModel({
    super.note,
    super.noteId,
    super.time,
    super.uid,
  })  : _note = note,
        _noteId = noteId,
        _time = time?.toDate(),
        _uid = uid;

  @override
  String? get note => _note;

  @override
  String? get noteId => _noteId;

  @override
  Timestamp? get time => _time != null? Timestamp.fromDate(_time) : null;

  @override
  String? get uid => _uid;

  factory NoteModel.fromSnapshot(DocumentSnapshot snapshot) {
    return NoteModel(
      note: snapshot.get('note'),
      noteId: snapshot.get('noteId'),
      uid: snapshot.get('uid'),
      time: snapshot.get('time'),
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      "note": note,
      "noteId": noteId,
      "time": _time != null? Timestamp.fromDate(_time) : null,
      "uid": uid,
    };
  }
} 
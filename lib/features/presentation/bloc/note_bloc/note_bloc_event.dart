import 'package:equatable/equatable.dart';
import 'package:notes_app/features/bussiness/entities/note_entity.dart';

abstract class NoteEvent extends Equatable {
  const NoteEvent();

  @override
  List<Object?> get props => [];
}

class LoadNotes extends NoteEvent {
  final String uid;

  const LoadNotes(this.uid);

  @override
  List<Object?> get props => [uid];
}

class AddNoteEvent extends NoteEvent {
  final NoteEntity note;

  const AddNoteEvent(this.note);

  @override
  List<Object?> get props => [note];
}

class UpdateNoteEvent extends NoteEvent {
  final NoteEntity note;

  const UpdateNoteEvent(this.note);

  @override
  List<Object?> get props => [note];
}

class DeleteNoteEvent extends NoteEvent {
  final NoteEntity note;

  const DeleteNoteEvent(this.note);

  @override
  List<Object?> get props => [note];
}

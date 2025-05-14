import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/features/bussiness/entities/note_entity.dart';
import 'package:notes_app/features/bussiness/usecases/add_note_usecase.dart';
import 'package:notes_app/features/bussiness/usecases/delete_note_usecase.dart';
import 'package:notes_app/features/bussiness/usecases/get_notes_usecase.dart';
import 'package:notes_app/features/bussiness/usecases/update_note_usecase.dart';
import 'package:notes_app/features/presentation/bloc/note_bloc/note_bloc_event.dart';
import 'package:notes_app/features/presentation/bloc/note_bloc/note_bloc_state.dart';


class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final AddNoteUseCase addNoteUseCase;
  final DeleteNoteUseCase deleteNoteUseCase;
  final UpdateNoteUsecase updateNoteUsecase;
  final GetNotesUsecase getNotesUsecase;

  StreamSubscription<List<NoteEntity>>? _notesSubscription;

  NoteBloc({
    required this.addNoteUseCase,
    required this.deleteNoteUseCase,
    required this.updateNoteUsecase,
    required this.getNotesUsecase,
  }) : super(NoteInitial()) {
    on<LoadNotes>(_onLoadNotes);
    on<AddNoteEvent>(_onAddNote);
    on<UpdateNoteEvent>(_onUpdateNote);
    on<DeleteNoteEvent>(_onDeleteNote);
     on<_InternalNoteStreamUpdated>(_onNoteStreamUpdated);
  }

void _onNoteStreamUpdated(
  _InternalNoteStreamUpdated event,
  Emitter<NoteState> emit,
) {
  emit(NoteLoaded(event.notes));
}


  Future<void> _onLoadNotes(LoadNotes event, Emitter<NoteState> emit) async {
  emit(NoteLoading());
  

  await _notesSubscription?.cancel();
  try {
    final stream = getNotesUsecase(event.uid);
    _notesSubscription = stream.listen(
      (notes) {
        
        add(_InternalNoteStreamUpdated(notes));
      },
      onError: (e) {
        
        emit(const NoteError('Failed to load notes.'));
      },
    );
  } catch (e) {
    
    emit(const NoteError('An error occurred while fetching notes.'));
  }
}


  Future<void> _onAddNote(AddNoteEvent event, Emitter<NoteState> emit) async {
    try {
      await addNoteUseCase(event.note);
    } catch (e) {
      emit(const NoteError('Failed to add note.'));
    }
  }

  Future<void> _onUpdateNote(UpdateNoteEvent event, Emitter<NoteState> emit) async {
    try {
      await updateNoteUsecase(event.note);
    } catch (e) {
      emit(const NoteError('Failed to update note.'));
    }
  }

  Future<void> _onDeleteNote(DeleteNoteEvent event, Emitter<NoteState> emit) async {
    try {
      await deleteNoteUseCase(event.note);
    } catch (e) {
      emit(const NoteError('Failed to delete note.'));
    }
  }

  // Internal event to update UI from note stream

  @override
  Future<void> close() {
    _notesSubscription?.cancel();
    return super.close();
  }
}


// 🔒 Private internal event to handle stream updates
class _InternalNoteStreamUpdated extends NoteEvent {
  final List<NoteEntity> notes;

  const _InternalNoteStreamUpdated(this.notes);

  @override
  List<Object?> get props => [notes];
}

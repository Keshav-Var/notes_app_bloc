import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:notes_app/features/bussiness/entities/note_entity.dart';
import 'package:notes_app/features/bussiness/usecases/add_note_usecase.dart';
import 'package:notes_app/features/bussiness/usecases/delete_note_usecase.dart';
import 'package:notes_app/features/bussiness/usecases/get_notes_usecase.dart';
import 'package:notes_app/features/bussiness/usecases/update_note_usecase.dart';

class NoteProvider with ChangeNotifier {
  final UpdateNoteUsecase updateNoteUsecase;
  final DeleteNoteUseCase deleteNoteUseCase;
  final GetNotesUsecase getNotesUsecase;
  final AddNoteUseCase addNoteUseCase;

  bool _isLoading = false;
  String? _errorMessage;
  Stream<List<NoteEntity>>? _noteStream;

  NoteProvider({
    required this.updateNoteUsecase,
    required this.deleteNoteUseCase,
    required this.getNotesUsecase,
    required this.addNoteUseCase,
  });

  Stream<List<NoteEntity>>? get noteStream => _noteStream;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> addNote(NoteEntity note) async {
    try {
      await addNoteUseCase.call(note);
    } on SocketException {
      _errorMessage = 'Failed to add note.';
      notifyListeners();
    } catch (_) {
      _errorMessage = 'An error occurred.';
      notifyListeners();
    }
  }

  Future<void> deleteNote(NoteEntity note) async {
    try {
      await deleteNoteUseCase.call(note);
    } on SocketException {
      _errorMessage = 'Failed to delete note.';
      notifyListeners();
    } catch (_) {
      _errorMessage = 'An error occurred.';
      notifyListeners();
    }
  }

  Future<void> updateNote(NoteEntity note) async {
    try {
      await updateNoteUsecase.call(note);
    } on SocketException {
      _errorMessage = 'Failed to update note.';
      notifyListeners();
    } catch (_) {
      _errorMessage = 'An error occurred.';
      notifyListeners();
    }
  }

  Future<void> fetchNotes(String uid) async {
    try {
      _noteStream = getNotesUsecase.call(uid);
    } on SocketException {
      _errorMessage = 'Failed to fetch notes.';
    } catch (_) {
      _errorMessage = 'An error occurred.';
    } finally {
      _isLoading = false;
      // notifyListeners();
    }
  }
}

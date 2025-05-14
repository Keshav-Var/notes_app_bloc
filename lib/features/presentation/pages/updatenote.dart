import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/features/bussiness/entities/note_entity.dart';
import 'package:notes_app/features/presentation/bloc/note_bloc/note_bloc.dart';
import 'package:notes_app/features/presentation/bloc/note_bloc/note_bloc_event.dart';
import 'package:notes_app/features/presentation/widgets/snake_bar.dart';

class Updatenote extends StatefulWidget {
  final int index;
  final NoteEntity note;
  const Updatenote({
    super.key,
    required this.index,
    required this.note,
  });

  @override
  State<Updatenote> createState() => _UpdatenoteState();
}

class _UpdatenoteState extends State<Updatenote> {
  late TextEditingController noteTextController;
  bool isDisabled = false;

  @override
  void initState() {
    super.initState();
    noteTextController = TextEditingController(text: widget.note.note);
    noteTextController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    noteTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Note"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${DateFormat("dd MMM hh:mm a").format(DateTime.now())} | ${noteTextController.text.length} Characters",
              style: TextStyle(
                fontSize: 14,
                color: Colors.black.withAlpha(120),
              ),
            ),
            Expanded(
              child: Scrollbar(
                child: TextFormField(
                  controller: noteTextController,
                  maxLines: null,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Start typing...",
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: isDisabled ? null : _submitUpdatedNote,
              child: Container(
                height: 45,
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isDisabled
                      ? Colors.deepOrange.withAlpha(100)
                      : Colors.deepOrange,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "Save",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _submitUpdatedNote() {
    final updatedNoteText = noteTextController.text.trim();

    if (updatedNoteText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar("Type something"));
      return;
    }

    setState(() => isDisabled = true);

    final updatedNote = NoteEntity(
      uid: widget.note.uid,
      noteId: widget.note.noteId,
      note: updatedNoteText,
      time: Timestamp.now(),
    );

    context.read<NoteBloc>().add(UpdateNoteEvent(updatedNote));

    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) Navigator.pop(context);
    });
  }
}

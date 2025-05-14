import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/features/bussiness/entities/note_entity.dart';
import 'package:notes_app/features/presentation/bloc/note_bloc/note_bloc.dart';
import 'package:notes_app/features/presentation/bloc/note_bloc/note_bloc_event.dart';
import 'package:notes_app/features/presentation/widgets/snake_bar.dart';

class Addnote extends StatefulWidget {
  final String uid;
  const Addnote({super.key, required this.uid});

  @override
  State<Addnote> createState() => _AddnoteState();
}

class _AddnoteState extends State<Addnote> {
  final TextEditingController noteTextController = TextEditingController();
  final GlobalKey scaffoldStateKey = GlobalKey();
  bool isDisabled = false;

  @override
  void initState() {
    super.initState();
    noteTextController.addListener(() {
      setState(() {}); // Triggers rebuild on input change
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
      key: scaffoldStateKey,
      appBar: AppBar(
        title: const Text("Note"),
      ),
      body: Container(
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
              onTap: isDisabled ? null : _submitNewNote,
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

  void _submitNewNote() {
    if (noteTextController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(snackBar("Type something"));
      return;
    }

    setState(() => isDisabled = true);

    final newNote = NoteEntity(
      uid: widget.uid,
      note: noteTextController.text.trim(),
      time: Timestamp.now(),
    );

    context.read<NoteBloc>().add(AddNoteEvent(newNote));

    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) Navigator.pop(context);
    });
  }
}

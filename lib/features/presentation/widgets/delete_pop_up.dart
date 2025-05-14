import 'package:flutter/material.dart';
import 'package:notes_app/features/bussiness/entities/note_entity.dart';
import 'package:notes_app/features/presentation/provider/note_provider.dart';
import 'package:provider/provider.dart';

Future<void> dialogBuilder(BuildContext context, NoteEntity note) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Delete Note'),
        content: const Text(
          'are you sure you want to delete this note',
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Delete'),
            onPressed: () {
              Provider.of<NoteProvider>(context, listen: false)
                  .deleteNote(note);
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: const Text('Cancle'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/features/bussiness/entities/note_entity.dart';
import 'package:notes_app/features/presentation/bloc/app_auth_bloc/app_auth_bloc.dart';
import 'package:notes_app/features/presentation/bloc/app_auth_bloc/app_auth_bloc_event.dart';
import 'package:notes_app/features/presentation/bloc/app_auth_bloc/app_auth_bloc_state.dart';
import 'package:notes_app/features/presentation/bloc/note_bloc/note_bloc.dart';
import 'package:notes_app/features/presentation/bloc/note_bloc/note_bloc_event.dart';
import 'package:notes_app/features/presentation/bloc/note_bloc/note_bloc_state.dart';
import 'package:notes_app/features/presentation/pages/addnote.dart';
import 'package:notes_app/features/presentation/pages/updatenote.dart';
import 'package:notes_app/features/presentation/widgets/delete_pop_up.dart';
import 'package:notes_app/features/presentation/widgets/no_entity_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

@override
void initState() {
  super.initState();
  final authState = context.read<AppAuthBloc>().state;
  if (authState is Authenticated) {
    context.read<NoteBloc>().add(LoadNotes(authState.uid));
  }
}


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppAuthBloc, AppAuthState>(

      builder: (context, authState) {
        if (authState is! Authenticated) {
          return const Scaffold(
            body: Center(child: Text('User not authenticated')),
          );
        }
        context.read<NoteBloc>().add(LoadNotes(authState.uid));
        final uid = authState.uid;
    
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.deepOrange,
            centerTitle: true,
            title: const Text(
              "Notes",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  context.read<AppAuthBloc>().add(SignedOut());
                },
                icon: const Icon(
                  Icons.logout_outlined,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => Addnote(uid: uid),
                ),
              );
            },
            backgroundColor: Colors.deepOrange,
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
          body: BlocBuilder<NoteBloc, NoteState>(
      builder: (context, noteState) {
        if (noteState is NoteInitial) {
    return const Center(child: CircularProgressIndicator());
        } else if (noteState is NoteLoading) {
    return const Center(child: CircularProgressIndicator());
        } else if (noteState is NoteError) {
    return Center(child: Text('Error: ${noteState.message}'));
        } else if (noteState is NoteLoaded) {
    final notes = noteState.notes;
    if (notes.isEmpty) {
      return const NoEntityWidget();
    }
    return _bodyWidget(context, notes);
        } else {
    return const Center(child: Text('Unexpected state'));
        }
      },
    )
    
        );
      },
    );
  }

  Widget _bodyWidget(BuildContext context, List<NoteEntity> notes) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: GridView.builder(
        itemCount: notes.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemBuilder: (context, index) {
          final note = notes[index];
          return GestureDetector(
            onLongPress: () => dialogBuilder(context, note),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => Updatenote(index: index, note: note),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 2,
                    spreadRadius: 2,
                    offset: const Offset(0, 1.5),
                  )
                ],
              ),
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    note.note ?? '',
                    maxLines: 6,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    DateFormat("dd MMM yyyy hh:mm a")
                        .format(note.time!.toDate()),
                    style: const TextStyle(fontSize: 10),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

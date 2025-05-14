import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:notes_app/features/presentation/bloc/app_auth_bloc/app_auth_bloc.dart';
import 'package:notes_app/features/presentation/bloc/app_auth_bloc/app_auth_bloc_event.dart';
import 'package:notes_app/features/presentation/bloc/app_auth_bloc/app_auth_bloc_state.dart';
import 'package:notes_app/features/presentation/bloc/note_bloc/note_bloc.dart';
import 'package:notes_app/features/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:notes_app/features/presentation/bloc/user_bloc/user_bloc_state.dart';
import 'package:notes_app/features/presentation/pages/home_page.dart';
import 'package:notes_app/features/presentation/pages/sign_in.dart';
import 'package:notes_app/features/presentation/pages/sign_up.dart';
import 'package:notes_app/injection_container.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Firebase.initializeApp();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
    BlocProvider(create: (_) => di.sl<AppAuthBloc>()),
    BlocProvider(create: (_) => di.sl<UserBloc>()),
    BlocProvider(create: (_) => di.sl<NoteBloc>()),
  ],

      child: MaterialApp(
        title: 'Notes app',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const BridgePage(),
      ),
    );
  }
}

class BridgePage extends StatefulWidget {
  const BridgePage({super.key});

  @override
  State<BridgePage> createState() => _BridgePageState();
}

class _BridgePageState extends State<BridgePage> {
  @override
  void initState() {
    super.initState();
    context.read<AppAuthBloc>().add(AppStarted());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppAuthBloc, AppAuthState>(
      builder: (context, authState) {
        if (authState is Authenticated) {
          return const HomePage();
        } else if (authState is Unauthenticated) {
          return BlocBuilder<UserBloc, UserState>(
            builder: (context, userState) {
              if (userState.isSignInPage) {
                return const SignIn();
              } else {
                return const SignUp();
              }
            },
          );
        } else {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
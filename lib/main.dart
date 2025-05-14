import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:notes_app/features/presentation/bloc/app_auth_bloc/app_auth_bloc.dart';
import 'package:notes_app/features/presentation/bloc/app_auth_bloc/app_auth_bloc_state.dart';
import 'package:notes_app/features/presentation/bloc/note_bloc/note_bloc.dart';
import 'package:notes_app/features/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:notes_app/features/presentation/bloc/user_bloc/user_bloc_state.dart';
import 'package:notes_app/features/presentation/pages/home_page.dart';
import 'package:notes_app/features/presentation/pages/sign_in.dart';
import 'package:notes_app/features/presentation/pages/sign_up.dart';
import 'package:notes_app/features/presentation/provider/user_provider.dart';
import 'package:notes_app/features/presentation/provider/authentication_provider.dart';
import 'package:provider/provider.dart';
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

class BridgePage extends StatelessWidget {
  const BridgePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppAuthBloc, AppAuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          // Optional: You could navigate to a home page or another screen here
          Navigator.pushReplacementNamed(context, '/home');
        } else if (state is Unauthenticated) {
          // Optional: Navigate to the sign-in or sign-up page when unauthenticated
          Navigator.pushReplacementNamed(context, '/auth');
        }
      },
      child: BlocBuilder<AppAuthBloc, AppAuthState>(
        builder: (context, authState) {
          if (authState is AppAuthState) {
            // Show loading indicator while checking authentication state
            return const Center(child: CircularProgressIndicator());
          } else if (authState is Authenticated) {
            // Return home page if authenticated
            return const HomePage();
          } else if (authState is Unauthenticated) {
            // Show the appropriate page based on user sign-in status
            return BlocBuilder<UserBloc, UserState>(
              builder: (context, userState) {
                if (userState.isSignInPage) {
                  // Show sign-in page if in sign-in mode
                  return const SignIn();
                } else {
                  // Show sign-up page if in sign-up mode
                  return const SignUp();
                }
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

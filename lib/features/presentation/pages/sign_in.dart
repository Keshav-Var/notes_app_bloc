import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/features/bussiness/entities/user_entity.dart';
import 'package:notes_app/features/presentation/bloc/app_auth_bloc/app_auth_bloc.dart';
import 'package:notes_app/features/presentation/bloc/app_auth_bloc/app_auth_bloc_event.dart';
import 'package:notes_app/features/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:notes_app/features/presentation/bloc/user_bloc/user_bloc_event.dart';
import 'package:notes_app/features/presentation/bloc/user_bloc/user_bloc_state.dart';
import 'package:notes_app/features/presentation/widgets/input_text_field.dart';
import 'package:notes_app/features/presentation/widgets/snake_bar.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String error = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<UserBloc, UserState>(
        listener: (context, state) {
          if (state.hasError) {
            ScaffoldMessenger.of(context).showSnackBar(snackBar(state.errorMsg ?? 'An error occurred.'));
          }

          if (state.isSuccessful) {
            // Trigger the authentication check after a successful sign in
            BlocProvider.of<AppAuthBloc>(context, listen: false).add(AppStarted());
          }
        },
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            // Render different UI based on whether it's the sign-in or sign-up page
            return _bodyWidget(context, state);
          },
        ),
      ),
    );
  }

  Widget _bodyWidget(BuildContext context, UserState state) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 150),
            const Image(
              image: AssetImage("assets/images/notebook.png"),
              height: 150,
            ),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 30),
                  InputTextField(
                    hintText: "Enter your email",
                    controller: _emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  InputTextField(
                    hintText: "Enter your password",
                    controller: _passwordController,
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: submitSignIn,
              child: Container(
                height: 45,
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width / 2,
                decoration: BoxDecoration(
                  color: Colors.deepOrange.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  "Login",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 15),
            GestureDetector(
              onTap: () {
                // Toggle between SignIn and SignUp screen
                BlocProvider.of<UserBloc>(context).add(ToggleUserEvent());
              },
              child: Container(
                height: 45,
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width / 2,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  "Sign up",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void submitSignIn() {
    if (_formKey.currentState!.validate()) {
      // Trigger the sign-in event
      BlocProvider.of<UserBloc>(context).add(
        SignInSubmitted(
           UserEntity(
            email: _emailController.text,
            password: _passwordController.text,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        snackBar("Please check email and password."),
      );
    }
  }
}
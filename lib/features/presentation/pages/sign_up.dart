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

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          if (state.hasError && state.errorMsg != null) {
            ScaffoldMessenger.of(context).showSnackBar(snackBar(state.errorMsg!));
          }

          if (state.isSuccessful) {
            BlocProvider.of<AppAuthBloc>(context).add(SignedIn());
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return _bodyWidget(context);
        },
      ),
    );
  }

  Widget _bodyWidget(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 100),
          const Image(
            image: AssetImage("assets/images/notebook.png"),
            height: 150,
          ),
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 30),
                InputTextField(
                  hintText: "Enter username",
                  controller: _usernameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
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
                const SizedBox(height: 20),
                InputTextField(
                  hintText: "Enter confirm password",
                  controller: _confirmPassword,
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter confirm password';
                    } else if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          GestureDetector(
            onTap: _submitSignUp,
            child: Container(
              height: 45,
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width / 2,
              decoration: BoxDecoration(
                color: Colors.deepOrange.withOpacity(.8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                "Sign up",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          GestureDetector(
            onTap: () => BlocProvider.of<UserBloc>(context).add(ToggleUserEvent()),
            child: Container(
              height: 45,
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width / 2,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(.8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                "Login",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submitSignUp() {
    if (_formKey.currentState!.validate()) {
      final user = UserEntity(
        name: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      BlocProvider.of<UserBloc>(context).add(SignUpSubmitted(user));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        snackBar("Please check your input."),
      );
    }
  }
}

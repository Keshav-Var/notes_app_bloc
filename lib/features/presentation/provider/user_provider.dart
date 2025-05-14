import 'package:flutter/material.dart';
import 'package:notes_app/features/bussiness/entities/user_entity.dart';
import 'package:notes_app/features/bussiness/usecases/get_create_current_user.dart';
import 'package:notes_app/features/bussiness/usecases/sign_in_usecase.dart';
import 'package:notes_app/features/bussiness/usecases/sign_up_usecase.dart';

class UserProvider extends ChangeNotifier {
  final SignInUsecase signInUsecase;
  final GetCreateCurrentUserUsecase getCreateCurrentUserUsecase;
  final SignUpUsecase signUpUsecase;

  UserProvider({
    required this.signInUsecase,
    required this.getCreateCurrentUserUsecase,
    required this.signUpUsecase,
  });
  bool _isSigninPage = true;
  bool _isSuceesful = false;
  bool _hasError = false;
  bool _isLoading = false;
  String? errorMsg;

  bool get isSigninPage => _isSigninPage;
  bool get isSucessful => _isSuceesful;
  bool get hasError => _hasError;
  bool get isLoading => _isLoading;

  Future<void> submitSignIn({required UserEntity user}) async {
    _isLoading = true;
    _hasError = false;
    errorMsg = null;
    try {
      await signInUsecase.call(user);
      _isSuceesful = true;
    } catch (e) {
      _isSuceesful = false;
      _hasError = true;
      errorMsg = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> submitSignUp({required UserEntity user}) async {
    _isLoading = true;
    _hasError = false;
    errorMsg = null;
    try {
      await signUpUsecase.call(user);
      await getCreateCurrentUserUsecase(user);
      _isSuceesful = true;
      _isLoading = false;
    } catch (e) {
      _isSuceesful = false;
      _hasError = true;
      errorMsg = e.toString();
      _isLoading = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void toggle() {
    _hasError = false;
    errorMsg = null;
    _isSigninPage = !_isSigninPage;
    notifyListeners();
  }

  void reset() {
    _hasError = false;
    errorMsg = null;
  }
}

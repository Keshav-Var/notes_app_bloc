import 'package:flutter/material.dart';
import 'package:notes_app/features/bussiness/usecases/get_current_uid.dart';
import 'package:notes_app/features/bussiness/usecases/is_sign_in_usecase.dart';
import 'package:notes_app/features/bussiness/usecases/sign_out_usecase.dart';

class AuthenticationProvider extends ChangeNotifier {
  final IsSignInUsecase isSignInUsecase;
  final GetCurrentUid getCurrentUid;
  final SignOutUsecase signOutUsecase;

  AuthenticationProvider({
    required this.isSignInUsecase,
    required this.getCurrentUid,
    required this.signOutUsecase,
  });
  bool _isAuthenticated = false;
  String? uid;

  bool get isAuthenticated => _isAuthenticated;

  Future<void> appStarted() async {
    try {
      _isAuthenticated = await isSignInUsecase.call();
      if (_isAuthenticated) {
        uid = await getCurrentUid.call();
      }
    } catch (e) {
      _isAuthenticated = false;
    }
    notifyListeners();
  }

  Future<void> signedIn() async {
    try {
      if (await isSignInUsecase.call()) {
        uid = await getCurrentUid.call();
        _isAuthenticated = true;
      }
      notifyListeners();
    } catch (e) {
      _isAuthenticated = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await signOutUsecase.call();
    _isAuthenticated = false;
    uid = null;
    notifyListeners();
  }
}

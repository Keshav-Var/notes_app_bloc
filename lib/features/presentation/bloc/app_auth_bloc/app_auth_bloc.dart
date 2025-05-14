import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/features/bussiness/usecases/get_current_uid.dart';
import 'package:notes_app/features/bussiness/usecases/is_sign_in_usecase.dart';
import 'package:notes_app/features/bussiness/usecases/sign_out_usecase.dart';

import 'app_auth_bloc_event.dart';
import 'app_auth_bloc_state.dart';

class AppAuthBloc extends Bloc<AppAuthEvent, AppAuthState> {
  final IsSignInUsecase isSignInUsecase;
  final GetCurrentUid getCurrentUid;
  final SignOutUsecase signOutUsecase;

  AppAuthBloc({
    required this.isSignInUsecase,
    required this.getCurrentUid,
    required this.signOutUsecase,
  }) : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<SignedIn>(_onSignedIn);
    on<SignedOut>(_onSignedOut);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AppAuthState> emit) async {
    try {
      final isSignedIn = await isSignInUsecase();
      if (isSignedIn) {
        final uid = await getCurrentUid();
        emit(Authenticated(uid));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(Unauthenticated());
    }
  }

  Future<void> _onSignedIn(SignedIn event, Emitter<AppAuthState> emit) async {
    try {
      final uid = await getCurrentUid();
      emit(Authenticated(uid));
    } catch (e) {
      emit(Unauthenticated());
    }
  }

  Future<void> _onSignedOut(SignedOut event, Emitter<AppAuthState> emit) async {
    await signOutUsecase();
    emit(Unauthenticated());
  }
}

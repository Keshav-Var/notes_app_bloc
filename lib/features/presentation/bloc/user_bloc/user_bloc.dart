import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/features/bussiness/usecases/get_create_current_user.dart';
import 'package:notes_app/features/bussiness/usecases/sign_in_usecase.dart';
import 'package:notes_app/features/bussiness/usecases/sign_up_usecase.dart';
import 'package:notes_app/features/presentation/bloc/user_bloc/user_bloc_event.dart';
import 'package:notes_app/features/presentation/bloc/user_bloc/user_bloc_state.dart';


class UserBloc extends Bloc<UserEvent, UserState> {
  final SignInUsecase signInUsecase;
  final SignUpUsecase signUpUsecase;
  final GetCreateCurrentUserUsecase getCreateCurrentUserUsecase;

  UserBloc({
    required this.signInUsecase,
    required this.signUpUsecase,
    required this.getCreateCurrentUserUsecase,
  }) : super(const UserState()) {
    on<ToggleUserEvent>(_onToggleUserMode);
    on<SignInSubmitted>(_onSignInSubmitted);
    on<SignUpSubmitted>(_onSignUpSubmitted);
    on<ResetUserError>(_onResetError);
  }

  void _onToggleUserMode(ToggleUserEvent event, Emitter<UserState> emit) {
    emit(state.copyWith(
      isSignInPage: !state.isSignInPage,
      hasError: false,
      errorMsg: null,
      isSuccessful: false,
    ));
  }

  Future<void> _onSignInSubmitted(
      SignInSubmitted event, Emitter<UserState> emit) async {
    emit(state.copyWith(isLoading: true, hasError: false, errorMsg: null));
    try {
      await signInUsecase(event.user);
      emit(state.copyWith(
        isLoading: false,
        isSuccessful: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        hasError: true,
        errorMsg: e.toString(),
      ));
    }
  }

  Future<void> _onSignUpSubmitted(
      SignUpSubmitted event, Emitter<UserState> emit) async {
    emit(state.copyWith(isLoading: true, hasError: false, errorMsg: null));
    try {
      await signUpUsecase(event.user);
      await getCreateCurrentUserUsecase(event.user);
      emit(state.copyWith(
        isLoading: false,
        isSuccessful: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        hasError: true,
        errorMsg: e.toString(),
      ));
    }
  }

  void _onResetError(ResetUserError event, Emitter<UserState> emit) {
    emit(state.copyWith(hasError: false, errorMsg: null));
  }
}

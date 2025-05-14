import 'package:equatable/equatable.dart';

class UserState extends Equatable {
  final bool isSignInPage;
  final bool isLoading;
  final bool isSuccessful;
  final bool hasError;
  final String? errorMsg;

  const UserState({
    this.isSignInPage = true,
    this.isLoading = false,
    this.isSuccessful = false,
    this.hasError = false,
    this.errorMsg,
  });

  UserState copyWith({
    bool? isSignInPage,
    bool? isLoading,
    bool? isSuccessful,
    bool? hasError,
    String? errorMsg,
  }) {
    return UserState(
      isSignInPage: isSignInPage ?? this.isSignInPage,
      isLoading: isLoading ?? this.isLoading,
      isSuccessful: isSuccessful ?? this.isSuccessful,
      hasError: hasError ?? this.hasError,
      errorMsg: errorMsg,
    );
  }

  @override
  List<Object?> get props => [
        isSignInPage,
        isLoading,
        isSuccessful,
        hasError,
        errorMsg,
      ];
}

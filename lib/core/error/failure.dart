abstract class Failure {
  String message;
  Failure({required this.message});
}

class ServerFailure extends Failure {
  ServerFailure(String message) : super(message: message);
}

class ChacheFailure extends Failure {
  ChacheFailure(String message) : super(message: message);
}

class NoInternetFailure extends Failure {
  NoInternetFailure({required super.message});
}

class AuthFailure extends Failure{
  AuthFailure(String message) : super(message: message);
}

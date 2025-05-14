import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:notes_app/core/error/exception.dart';
import 'package:notes_app/core/error/failure.dart';

abstract class NetworkInfo {
  Future<Either<Failure, bool>> isConnected();
}

class NetworkInfoImpl extends NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl({required this.connectivity});

  @override
  Future<Either<Failure, bool>> isConnected() async {
    try {
      final result = await connectivity.checkConnectivity();
      return right(!result.contains(ConnectivityResult.none));
    } on NoInternetExpection {
      return left(NoInternetFailure(message: "You are offline."));
    } catch (e) {
      return left(NoInternetFailure(message: "You are offline."));
    }
  }
}

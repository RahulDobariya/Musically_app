import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure(this.errorMsg);
  final String errorMsg;

  @override
  List<Object> get props => [errorMsg];
}

// General failures
class ServerFailure extends Failure {
  const ServerFailure(super.errorMessage);
}

class CacheFailure extends Failure {
  const CacheFailure(super.errorMessage);
}

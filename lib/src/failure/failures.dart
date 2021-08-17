import 'package:equatable/equatable.dart';

import '../models/response_model.dart';
import 'enum.dart';

export 'enum.dart';
export 'exceptions.dart';
export 'failure_handler.dart';
export 'status_checker.dart';

abstract class Failure extends Equatable {}

abstract class Failures extends Failure {
  Failures._();

  factory Failures.errorFailure(
      {required ErrorStatus errorStatus,
      required ResponseModel error}) = ErrorFailure;
  factory Failures.sessionEndedFailure() = SessionEndedFailure;
  factory Failures.connectionFailure() = ConnectionFailure;
  factory Failures.serviceNotAvailableFailure() = ServiceNotAvailableFailure;
  factory Failures.unkownFailure(dynamic exception) = UnkownFailure;
  factory Failures.cacheFailure() = CacheFailure;
  factory Failures.requestCanceledFailure() = RequestCanceledFailure;
  factory Failures.validationFailure(String value) = ValidationFailure;
}

class ValidationFailure extends Failures implements Failure {
  ValidationFailure(this.valueKey) : super._();

  final String valueKey;

  @override
  List<Object?> get props => [valueKey];
}

class ErrorFailure extends Failures {
  ErrorFailure({required this.errorStatus, required this.error}) : super._();

  final ErrorStatus errorStatus;
  final ResponseModel error;

  @override
  List<Object?> get props => [errorStatus, error];
}

class ConnectionFailure extends Failures {
  ConnectionFailure() : super._();
  @override
  List<Object?> get props => [];
}

class ServiceNotAvailableFailure extends Failures {
  ServiceNotAvailableFailure() : super._();

  @override
  List<Object?> get props => [];
}

class SessionEndedFailure extends Failures {
  SessionEndedFailure() : super._();

  @override
  List<Object?> get props => [];
}

class RequestCanceledFailure extends Failures {
  RequestCanceledFailure() : super._();

  @override
  List<Object?> get props => [];
}

class UnkownFailure extends Failures {
  UnkownFailure(this.exception) : super._();
  final dynamic exception;

  @override
  List<Object?> get props => [exception];
}

class CacheFailure extends Failures {
  CacheFailure() : super._();

  @override
  List<Object?> get props => [];
}

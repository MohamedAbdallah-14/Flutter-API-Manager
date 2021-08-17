import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import '../models/response_model.dart';

abstract class Exceptions extends Equatable implements Exception {
  const Exceptions._();

  const factory Exceptions.serverException(Response? response) =
      ServerException;
  const factory Exceptions.errorException(int statusCode, ResponseModel error) =
      ErrorException;
  const factory Exceptions.cacheException() = CacheException;
  const factory Exceptions.validationException(String value) =
      ValidationException;
}

class ErrorException extends Exceptions {
  const ErrorException(this.statusCode, this.error) : super._();

  final int statusCode;
  final ResponseModel error;

  @override
  List<Object?> get props => [statusCode, error];
}

class ServerException extends Exceptions {
  const ServerException(this.response) : super._();

  final Response? response;

  @override
  List<Object?> get props => [response];
}

class CacheException extends Exceptions {
  const CacheException() : super._();

  @override
  List<Object?> get props => [];
}

class ValidationException extends Exceptions {
  const ValidationException(this.value) : super._();

  final String value;

  @override
  List<Object?> get props => [value];
}

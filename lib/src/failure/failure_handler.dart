import 'dart:io';

import 'package:dio/dio.dart';

import 'enum.dart';
import 'exceptions.dart';
import 'failures.dart';
import 'status_checker.dart';

class FailureHandler {
  FailureHandler();
  final StatusChecker _statusChecker = StatusChecker();
  // final prettyDioLogger = PrettyDioLogger(
  //     requestHeader: true,
  //     requestBody: true,
  //     responseBody: true,
  //     responseHeader: false,
  //     error: true,
  //     compact: true,
  //     maxWidth: 300,
  //     logPrint: (text) => FirebaseCrashlytics.instance.log(text));

  Failure handle(dynamic exception, Response? response) {
    if (exception is ErrorException) {
      return Failures.errorFailure(
        errorStatus: _statusChecker.getErrorState(exception.statusCode),
        error: exception.error,
      );
    } else if (exception is DioError) {
      switch (exception.type) {
        case DioErrorType.connectTimeout:
        case DioErrorType.sendTimeout:
        case DioErrorType.receiveTimeout:
          return Failures.connectionFailure();
        case DioErrorType.cancel:
          return Failures.requestCanceledFailure();
        case DioErrorType.response:
        case DioErrorType.other:
          {
            if (exception.message.contains('SocketException')) {
              return Failures.connectionFailure();
            }
            return unkownFailure(response, exception, 'Unknown DioError');
          }
      }
    } else if (exception is ServerException) {
      final status = _statusChecker(exception.response?.statusCode);
      switch (status) {
        case HTTPCodes.invaildToken:
          return Failures.sessionEndedFailure();
        case HTTPCodes.serviceNotAvailable:
          recordError(exception.response, exception, 'Service Not Available',
              allReponse: false);
          return Failures.serviceNotAvailableFailure();
        case HTTPCodes.unknown:
          return unkownFailure(response, exception, 'Unknown ServerException');
        default:
          break;
      }
    } else if (exception is SocketException) {
      return Failures.connectionFailure();
    } else if (exception is FormatException) {
      recordError(response, exception, 'Service Not Available Failure');
      return Failures.serviceNotAvailableFailure();
    } else if (exception is CacheException) {
      return Failures.cacheFailure();
    } else if (exception is ValidationException) {
      return Failures.validationFailure(exception.value);
    } else if (exception is TypeError) {
      recordError(response, exception, 'TypeError');
      return Failures.serviceNotAvailableFailure();
    }
    return unkownFailure(response, exception, 'Unkown Failure');
  }

  void recordError(Response? response, dynamic exception, String type,
      {bool allReponse = true}) {
    // if (Firebase.apps.isNotEmpty) {
    //   FirebaseCrashlytics.instance.setCustomKey('Type', type);
    //   FirebaseCrashlytics.instance
    //       .setCustomKey('URL', response?.request?.uri?.toString() ?? '');
    //   FirebaseCrashlytics.instance
    // ignore: lines_longer_than_80_chars
    //       .setCustomKey('Method', response?.request?.method?.toString() ?? '');
    //   FirebaseCrashlytics.instance.setCustomKey('Query Parameters',
    //       response?.request?.queryParameters?.toString() ?? '');
    //   FirebaseCrashlytics.instance.setCustomKey(
    //       'Request data', response?.request?.data?.toString() ?? '');
    //   FirebaseCrashlytics.instance.setCustomKey(
    //       'Request Headers', response?.request?.headers?.toString() ?? '');
    //   FirebaseCrashlytics.instance
    //       .setCustomKey('Response', response?.data?.toString() ?? '');
    //   prettyDioLogger.onRequest(response?.request ?? '');
    //   prettyDioLogger.onResponse(response ?? '');
    //   FirebaseCrashlytics.instance.recordError(exception, null);
    // }
  }

  UnkownFailure unkownFailure(
      Response? response, dynamic exception, String type) {
    recordError(response, exception, type);
    return UnkownFailure(exception);
  }
}

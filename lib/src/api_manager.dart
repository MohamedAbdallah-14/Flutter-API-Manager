library api_manager;

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'failure/enum.dart';
import 'failure/failures.dart';
import 'models/message_response.dart';
import 'models/response_model.dart';
import 'request/base_request.dart';

class APIsManager {
  APIsManager() {
    _dio.interceptors
        .add(PrettyDioLogger(requestHeader: true, requestBody: true));
  }

  final StatusChecker _statusChecker = StatusChecker();
  final FailureHandler _failureHandler = FailureHandler();
  final Dio _dio = Dio();

  Future<Either<Failure, R>> send<R, ER extends ResponseModel>({
    required Request request,
    required R Function(Map<String, dynamic> map) responseFromMap,
    ER Function(Map<String, dynamic> map)? errorResponseFromMap,
  }) async {
    Response<Map<String, dynamic>>? response;
    try {
      response = await _dio.request(
        request.url,
        data: await request.data,
        queryParameters: await request.queryParameters,
        cancelToken: request.cancelToken,
        onSendProgress: request.requestModel.progressListener?.onSendProgress,
        onReceiveProgress:
            request.requestModel.progressListener?.onReceiveProgress,
        options: Options(
          headers: request.headers,
          method: request.method,
        ),
      );
      return Right(responseFromMap(response.data!));
    } on DioError catch (error) {
      if (error.type == DioErrorType.response) {
        if (error.response?.statusCode != null &&
            _statusChecker(error.response!.statusCode) == HTTPCodes.error) {
          return Left(_failureHandler.handle(
            Exceptions.errorException(
              error.response!.statusCode!,
              errorResponseFromMap != null
                  ? errorResponseFromMap(
                      error.response!.data as Map<String, dynamic>)
                  : MessageResponse.fromMap(
                      error.response!.data as Map<String, dynamic>),
            ),
            error.response,
          ));
        } else {
          return Left(_failureHandler.handle(
              Exceptions.serverException(error.response), error.response));
        }
      }
      return Left(_failureHandler.handle(error, error.response));
    } catch (exception) {
      return Left(_failureHandler.handle(exception, response));
    }
  }
}

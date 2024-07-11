import 'package:chatbot/core/data/remote/responses/error_response.dart';
import 'package:chatbot/core/domain/models/error_dto.dart';
import 'package:chatbot/core/domain/models/error_type.dart';
import 'package:chatbot/core/utils/typedef_util.dart';
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';

FutureOrError<T> callOrError<T>(
  Future<T> Function() block,
) async {
  try {
    return Right(await block());
  } on DioException catch (e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Left(ErrorDto(
          message: 'Connection timeout',
          errorType: ErrorType.connectionTimeout,
        ));
      case DioExceptionType.badResponse:
        var statusCode = e.response?.statusCode ?? 0;
        var message = '';
        try {
          var r = ErrorResponse.fromJson(e.response?.data);
          message = r.message ?? '';
        } catch (e) {
          message = 'Unknown Error';
        }

        switch (statusCode) {
          case 400:
            return Left(ErrorDto(
              message: message,
              errorType: ErrorType.badRequest,
            ));
          case 401:
            return Left(ErrorDto(
              message: message,
              errorType: ErrorType.unauthorized,
            ));
          case 404:
            return Left(ErrorDto(
              message: message,
              errorType: ErrorType.notFound,
            ));
          case 500:
            return Left(ErrorDto(
              message: message,
              errorType: ErrorType.internalServerError,
            ));
          default:
            return Left(ErrorDto(
              message: message,
              errorType: ErrorType.unknown,
            ));
        }
      default:
        return Left(ErrorDto(
          message: 'Unknown Error',
        ));
    }
  } on Exception catch (e) {
    return Left(ErrorDto(
      message: e.toString(),
    ));
  } on ArgumentError catch (e) {
    return Left(ErrorDto(
      message: e.message,
    ));
  }
}

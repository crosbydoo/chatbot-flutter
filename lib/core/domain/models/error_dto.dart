import 'package:chatbot/core/domain/models/error_type.dart';

class ErrorDto {
  String message;
  String errorCode;
  ErrorType errorType;

  ErrorDto({
    required this.message,
    this.errorCode = '-',
    this.errorType = ErrorType.unknown,
  });
}

import 'package:chatbot/core/domain/models/error_dto.dart';
import 'package:either_dart/either.dart';

typedef EitherError<T> = Either<ErrorDto, T>;

typedef FutureOrError<T> = Future<EitherError<T>>;

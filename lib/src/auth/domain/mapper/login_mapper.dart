import 'package:chatbot/src/auth/data/remote/responses/login_response.dart';
import 'package:chatbot/src/auth/domain/models/login_dto.dart';

extension LoginResponseExt on LoginResponse? {
  LoginDto toDto() {
    return LoginDto(
      uid: this?.uid ?? 0,
      token: this?.token ?? '',
    );
  }
}

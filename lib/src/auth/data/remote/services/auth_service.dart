import 'package:chatbot/src/auth/data/remote/requests/login_request.dart';
import 'package:chatbot/src/auth/data/remote/responses/login_response.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

part 'auth_service.g.dart';

@RestApi()
abstract class AuthService {
  factory AuthService(Dio dio) => _AuthService(dio);

  @POST('/login')
  Future<LoginResponse> login(@Body() LoginRequest request);
}

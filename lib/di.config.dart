// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:chatbot/core/data/local/app_preferences.dart' as _i5;
import 'package:chatbot/core/data/remote/interceptors/auth_interceptor.dart'
    as _i4;
import 'package:chatbot/core/di/local_module.dart' as _i11;
import 'package:chatbot/core/di/network_module.dart' as _i12;
import 'package:chatbot/src/auth/data/remote/services/auth_service.dart' as _i7;
import 'package:chatbot/src/auth/data/repository/auth_repository.dart' as _i8;
import 'package:chatbot/src/auth/data/repository/auth_repository_impl.dart'
    as _i14;
import 'package:chatbot/src/auth/di/auth_di_module.dart' as _i13;
import 'package:chatbot/src/auth/domain/usecases/login_usecase.dart' as _i9;
import 'package:chatbot/src/auth/presentation/bloc/login_bloc.dart' as _i10;
import 'package:dio/dio.dart' as _i6;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_preferences/shared_preferences.dart' as _i3;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final localModule = _$LocalModule();
    final networkModule = _$NetworkModule();
    final authDiModule = _$AuthDiModule(this);
    gh.singletonAsync<_i3.SharedPreferences>(() => localModule.prefs);
    gh.singleton<_i4.AuthInterceptor>(() => networkModule.authInterceptor);
    gh.singleton<String>(
      () => networkModule.baseUrl,
      instanceName: 'base_url',
    );
    gh.singletonAsync<_i5.AppPreferences>(() async =>
        localModule.appPreferences(await getAsync<_i3.SharedPreferences>()));
    gh.singleton<_i6.Dio>(() => networkModule.dio(
          gh<String>(instanceName: 'base_url'),
          gh<_i4.AuthInterceptor>(),
        ));
    gh.singleton<_i7.AuthService>(
        () => authDiModule.authService(gh<_i6.Dio>()));
    gh.singleton<_i8.AuthRepository>(() => authDiModule.authRepository);
    gh.factory<_i9.LoginUseCase>(
        () => authDiModule.loginUseCase(gh<_i8.AuthRepository>()));
    gh.factory<_i10.LoginBloc>(
        () => authDiModule.loginBloc(gh<_i9.LoginUseCase>()));
    return this;
  }
}

class _$LocalModule extends _i11.LocalModule {}

class _$NetworkModule extends _i12.NetworkModule {}

class _$AuthDiModule extends _i13.AuthDiModule {
  _$AuthDiModule(this._getIt);

  final _i1.GetIt _getIt;

  @override
  _i14.AuthRepositoryImpl get authRepository =>
      _i14.AuthRepositoryImpl(_getIt<_i7.AuthService>());
}

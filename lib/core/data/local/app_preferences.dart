import 'package:chatbot/core/utils/pref_extension.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  final SharedPreferences _sharedPreferences;

  AppPreferences(this._sharedPreferences);

  Future<bool> setToken(String? token) {
    return _sharedPreferences.setStringOrClear(_keyToken, token);
  }

  String? getToken() {
    return _sharedPreferences.getString(_keyToken);
  }

  Future<bool> setUID(String? uid) {
    return _sharedPreferences.setStringOrClear(_uid, uid);
  }

  String? getUID() {
    return _sharedPreferences.getString(_uid);
  }

  /// Preferences Keys
  static const String _keyToken = 'token';
  static const String _uid = 'U1d';
}

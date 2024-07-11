class LoginDto {
  final int uid;
  final String token;

  const LoginDto({
    this.uid = 0,
    this.token = '',
  });

  @override
  String toString() {
    return 'LoginDto{id: $uid, token: $token}';
  }
}

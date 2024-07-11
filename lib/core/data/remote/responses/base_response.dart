import 'package:json_annotation/json_annotation.dart';

part 'base_response.g.dart';

///
/// {
///   "status": <bool>,
///   "code": <int>,
///   "message": <string>,
///   "data": <T>
/// }
///
@JsonSerializable(genericArgumentFactories: true)
class BaseResponse<T> {
  @JsonKey(name: 'status')
  final bool? status;
  @JsonKey(name: 'code')
  final int? code;
  @JsonKey(name: 'message')
  final String? message;
  @JsonKey(name: 'data')
  final T? data;

  BaseResponse({
    this.status,
    this.code,
    this.message,
    this.data,
  });

  factory BaseResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$BaseResponseFromJson(json, fromJsonT);
}

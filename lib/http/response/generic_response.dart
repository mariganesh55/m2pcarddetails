import 'package:json_annotation/json_annotation.dart';
import 'package:m2pcarddetails/http/response/base_response.dart';

part 'generic_response.g.dart';

@JsonSerializable()
class GenericResponse extends BaseResponse {
  GenericResponse(bool result) : super(result);

  factory GenericResponse.fromJson(Map<String, dynamic> json) =>
      _$GenericResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GenericResponseToJson(this);
}

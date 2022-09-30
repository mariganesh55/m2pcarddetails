import 'package:json_annotation/json_annotation.dart';
import 'package:m2pcarddetails/http/model/card_detail_result.dart';
import 'package:m2pcarddetails/http/response/base_response.dart';
import 'package:m2pcarddetails/utils/base_equitable.dart';

part 'card_detail_response.g.dart';

@JsonSerializable()
class CardDetailResponse {
  @JsonKey(name: "result")
  CardDetailResult? result;

  @JsonKey(name: "exception")
  dynamic? exception;

  CardDetailResponse(this.result);

  factory CardDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$CardDetailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CardDetailResponseToJson(this);
}

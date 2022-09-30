import 'package:json_annotation/json_annotation.dart';

part 'card_detail_result.g.dart';

@JsonSerializable()
class CardDetailResult {
  @JsonKey(name: "cardDetails")
  late String detailMessage;

  @JsonKey(name: "publicKey")
  late String publicKey;

  CardDetailResult(this.detailMessage, this.publicKey);

  factory CardDetailResult.fromJson(Map<String, dynamic> json) =>
      _$CardDetailResultFromJson(json);

  Map<String, dynamic> toJson() => _$CardDetailResultToJson(this);
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_detail_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CardDetailResponse _$CardDetailResponseFromJson(Map<String, dynamic> json) {
  return CardDetailResponse(
    json['result'] == null
        ? null
        : CardDetailResult.fromJson(json['result'] as Map<String, dynamic>),
  )..exception = json['exception'];
}

Map<String, dynamic> _$CardDetailResponseToJson(CardDetailResponse instance) =>
    <String, dynamic>{
      'result': instance.result,
      'exception': instance.exception,
    };

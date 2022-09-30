// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_detail_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CardDetailResult _$CardDetailResultFromJson(Map<String, dynamic> json) {
  return CardDetailResult(
    json['cardDetails'] as String,
    json['publicKey'] as String,
  );
}

Map<String, dynamic> _$CardDetailResultToJson(CardDetailResult instance) =>
    <String, dynamic>{
      'cardDetails': instance.detailMessage,
      'publicKey': instance.publicKey,
    };

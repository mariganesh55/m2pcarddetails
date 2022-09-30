// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generic_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GenericResponse _$GenericResponseFromJson(Map<String, dynamic> json) {
  return GenericResponse(
    json['result'] as bool,
  )..statusCode = json['statusCode'] as int?;
}

Map<String, dynamic> _$GenericResponseToJson(GenericResponse instance) =>
    <String, dynamic>{
      'result': instance.result,
      'statusCode': instance.statusCode,
    };

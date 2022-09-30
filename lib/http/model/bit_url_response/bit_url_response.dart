import 'result.dart';

class BitUrlResponse {
  Result? result;
  dynamic exception;
  dynamic pagination;

  BitUrlResponse({this.result, this.exception, this.pagination});

  factory BitUrlResponse.fromJson(Map<String, dynamic> json) {
    return BitUrlResponse(
      result: json['result'] == null
          ? null
          : Result.fromJson(json['result'] as Map<String, dynamic>),
      exception: json['exception'] as dynamic,
      pagination: json['pagination'] as dynamic,
    );
  }

  Map<String, dynamic> toJson() => {
        'result': result?.toJson(),
        'exception': exception,
        'pagination': pagination,
      };
}

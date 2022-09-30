abstract class BaseResponse {
  bool result;
  int? statusCode;

  BaseResponse(this.result);

  Future<void> setStatuscode(int code) async {
    statusCode = code;
  }
}

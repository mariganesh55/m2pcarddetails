import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:m2pcarddetails/http/model/bit_url_response/bit_url_response.dart';
import 'package:m2pcarddetails/http/response/card_detail_response.dart';
import 'package:m2pcarddetails/http/response/generic_response.dart';
import 'package:m2pcarddetails/utils/apputils.dart';
import 'package:m2pcarddetails/utils/constants.dart';

import '../dio.dart';
import '../httpurls.dart';

class HomeRepository {
  static Future<GenericResponse?> pairPublicKey(
      String publicKey, String deviceId) async {
    final String url = HttpUrl.pairPublicKey;

    GenericResponse? genericResponse;
    final Response response = await dio().post(
      url,
      data: {
        "entityId": Constants.EntityId,
        "publicKey": publicKey,
        "appGuid": deviceId
      },
    ).catchError((error) async {
      print(error);
    });

    if (response != null) {
      genericResponse =
          GenericResponse.fromJson(response.data as Map<String, dynamic>);
    }

    return genericResponse;
  }

  static Future<GenericResponse?> depairPublicKey() async {
    final String url = HttpUrl.depairPublicKey;

    GenericResponse? genericResponse;
    final Response response = await dio().post(
      url,
      data: {
        "entityId": Constants.EntityId,
      },
    ).catchError((error) async {
      print(error);
    });

    if (response != null) {
      genericResponse =
          GenericResponse.fromJson(response.data as Map<String, dynamic>);
    }

    return genericResponse;
  }

  static Future<BitUrlResponse?> generateBitUrl() async {
    final String url = HttpUrl.generateBitUrl;

    BitUrlResponse? bitUrlResponse;
    final Response response = await dio().post(
      url,
      data: {
        "token":
            "AL4ZPi9f9oQ+L7FNdDN8HyrZl7FXU2TbJyP4+LP9MmSgBIom7EopA7w4Vvu28TbrpEoIsW3XHgl4Cs3ZFNt0aSKTciqZ98G8C6Xdr0Gmd3kR5yM6lGZXKLKSggRZqYBcbfOAAjQ0pwlhZsywWG3U4B3BHHp+EwbH5AIpfwNfGJk=",
        "kitNo": "100000017",
        "entityId": Constants.EntityId,
        "business": Constants.tenant,
        "iFrame": false,
        "callbackUrl": "https://www.google.com",
        "dob": "05041994",
        "endPoint": true
      },
    ).catchError((error) async {
      print(error);
    });

    if (response != null) {
      bitUrlResponse =
          BitUrlResponse.fromJson(response.data as Map<String, dynamic>);
    }

    return bitUrlResponse;
  }

  static Future<BitUrlResponse?> fetchTenantConfig() async {
    final String url = Constants.dynamicUrl;

    var jsonData = json.encode({
      "request": {
        "entityId": Constants.EntityId,
        "requestId": DateTime.now().millisecondsSinceEpoch,
      },
      "endPoint": "fetchTenantConfig",
      "deviceId": Constants.deviceId,
    });

    BitUrlResponse? bitUrlResponse;
    final Response response = await dio()
        .post(url,
            data: {
              "encryptedReq":
                  AppUtils.encryptAES(jsonData, Constants.serverPublicKey)
            },
            options: Options(
                headers: {"randomtoken": Constants.dynamicUrl.split("|")[1]}))
        .catchError((error) async {
      print(error);
    });

    if (response != null) {
      bitUrlResponse =
          BitUrlResponse.fromJson(response.data as Map<String, dynamic>);
    }

    return bitUrlResponse;
  }

  static Future<CardDetailResponse?> getCardDetails() async {
    final String url = HttpUrl.getCardDetails;

    CardDetailResponse? cardDetailResponse;

    final Response response = await dio().post(
      url,
      data: {
        "token":
            "AL4ZPi9f9oQ+L7FNdDN8HyrZl7FXU2TbJyP4+LP9MmSgBIom7EopA7w4Vvu28TbrpEoIsW3XHgl4Cs3ZFNt0aSKTciqZ98G8C6Xdr0Gmd3kR5yM6lGZXKLKSggRZqYBcbfOAAjQ0pwlhZsywWG3U4B3BGOp+EwbH5AIpfwNfGJk=",
        "kitNo": "900009959",
        "entityId": "5f2b705e267fdf12e2749f39",
        "business": "RBLPENCILTON",
        "iFrame": false,
        "callbackUrl": "https://www.google.com",
        "dob": "17012006"
      },
    ).catchError((error) async {
      print(error);
    });

    if (response != null) {
      cardDetailResponse =
          CardDetailResponse.fromJson(response.data as Map<String, dynamic>);
    }

    return cardDetailResponse;
  }
}

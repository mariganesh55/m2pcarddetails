import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:m2pcarddetails/utils/apputils.dart';
import 'package:m2pcarddetails/utils/constants.dart';

import 'httpurls.dart';

class DioHelper {
  Dio dio = Dio();

  bool isMaintanence = false;

  DioHelper() {
    dio.options.baseUrl = HttpUrl.baseurl;
    dio.options.followRedirects = true;
    // dio.options.receiveDataWhenStatusError = true;

    dio.options.headers[HttpHeaders.acceptHeader] = "application/json";
    dio.options.validateStatus = (status) {
      return status! < 400;
    };

    dio.transformer = JsonTransformer();
    //setup auth interceptor
    _setupAuthInterceptor();
    //setup log interceptor
    _setupLogInterceptor();
    // _setupRetryInterceptor();
  }

  // ignore: always_declare_return_types
  _setupAuthInterceptor() async {
    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (options, handler) async {
      // final String accessToken = await PreferenceHelper.getAccessToken();
      // final String refreshToken = await PreferenceHelper.getRefreshToken();

      options.headers["TENANT"] = Constants.tenant;
      return handler.next(options);
    }, onResponse: (Response response, handler) async {
      isMaintanence = false;

      return handler.next(response);
    }, onError: (DioError error, handler) async {
      return handler.next(error);
    }));
  }

  static FutureOr<bool> checkDioRetry(DioError error) {
    // AppUtils.showErrorToast(error.message);
    return error.type == DioErrorType.other;
  }

  // ignore: always_declare_return_types
  _showToast(String text) {
    // WidgetsBinding.instance.addObserver(LifecycleEventHandler(
    //     pausedCallBack: onPauseCallBack, resumeCallBack: onResumeCallBack));
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 14.0);
  }

  // ignore: always_declare_return_types
  _setupLogInterceptor() {
    if (DebugMode.isInDebugMode) {
      // ignore: avoid_redundant_argument_values
      dio.interceptors.add(LogInterceptor(responseBody: false));
    }
  }
}

//This transformer runs the json decoding in a background thread.
//Thus returing a Future of Map
class JsonTransformer extends DefaultTransformer {
  JsonTransformer() : super(jsonDecodeCallback: _parseJson);
}

Map<String, dynamic> _parseAndDecode(String response) {
  return jsonDecode(response) as Map<String, dynamic>;
}

Future<Map<String, dynamic>> _parseJson(String text) {
  return compute(_parseAndDecode, text);
}

Dio dio() {
  final Dio dio = DioHelper().dio;
  return dio;
}

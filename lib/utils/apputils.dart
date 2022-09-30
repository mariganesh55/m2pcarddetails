import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:convert';

class AppUtils {
  static final iv = encrypt.IV.fromLength(0);
  static final Random _random = Random.secure();

  static void hideKeyBoard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  static void showErrorToast(String text) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 14.0);
  }

  static void showToast(String text) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 14.0);
  }

  static String encryptAES(String text, String key) {
    final encrypter = encrypt.Encrypter(
        encrypt.AES(encrypt.Key.fromUtf8(key), mode: encrypt.AESMode.ecb));
    return encrypter.encrypt(text, iv: iv).base64;
  }

  static String decryptAES(String encrypted, String key) {
    final Uint8List encryptedBytesWithSalt = base64.decode(encrypted);

    final Uint8List encryptedBytes =
        encryptedBytesWithSalt.sublist(0, encryptedBytesWithSalt.length);

    final encrypter = encrypt.Encrypter(
        encrypt.AES(encrypt.Key.fromUtf8(key), mode: encrypt.AESMode.ecb));

    final decrypted =
        encrypter.decrypt64(base64.encode(encryptedBytes), iv: iv);

    return decrypted;
  }
}

class DebugMode {
  static bool get isInDebugMode {
    const bool inDebugMode = true;
    //assert(inDebugMode = true);
    return inDebugMode;
  }
}

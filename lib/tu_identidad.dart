import 'dart:async';

import 'package:flutter/services.dart';

class TuIdentidad {
  static const String INE = "INE";
  static const String IDVAL = "IDVAL";
  static const String ONLYOCR = "ONLYOCR";

  static const MethodChannel _channel = const MethodChannel('tu_identidad');

  static Future<dynamic> ine(
    String apiKey,
    String method, {
    bool showTutorial = false,
    bool showResults = false,
    bool INEValidationInfo = true,
    bool INEValidationQuality = true,
    bool INEValidationPatterns = true,
    bool INEValidationCurp = true,
    bool INEValidationFace = true,
  }) async {
    final Map<String, dynamic> args = {
      "method": method ?? INE,
      "apiKey": apiKey ?? "",
      "showTutorial": showTutorial ?? false,
      "showResults": showResults ?? false,
      "INEValidationInfo": INEValidationInfo ?? true,
      "INEValidationQuality": INEValidationQuality ?? true,
      "INEValidationPatterns": INEValidationPatterns ?? true,
      "INEValidationCurp": INEValidationCurp ?? true,
      "INEValidationFace": INEValidationFace ?? true,
    };
    final result = await _channel.invokeMethod('ine', args);
    return result;
  }

  static Future<dynamic> address(
    String apiKey,
  ) async {
    final Map<String, dynamic> args = {
      "apiKey": apiKey ?? "",
    };
    final result = await _channel.invokeMethod('address', args);
    return result;
  }
}

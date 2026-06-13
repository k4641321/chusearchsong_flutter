import 'dart:developer';

import 'package:flutter/services.dart';

class V2rayService {
  static const platform = MethodChannel(
    'com.k4641321.chusearchsong_flutter.maimaiproxy/controller',
  );

  static Future<void> start(String configJson) async {
    await platform.invokeMethod('start', {'config': configJson});
  }

  static Future<void> stop() async {
    await platform.invokeMethod('stop');
  }
}

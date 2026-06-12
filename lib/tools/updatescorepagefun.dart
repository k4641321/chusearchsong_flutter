import 'dart:developer';

import 'package:flutter_v2ray_client/flutter_v2ray.dart';

Future<void> connect(String shareLink, v2ray) async {
  try {
    final parser = V2ray.parseFromURL(shareLink);
    // final config = parser.getFullConfiguration();

    // await flutterVless.initializeVless(
    //   providerBundleIdentifier: 'com.k4641321.chusearchsong_flutter',
    //   groupIdentifier: 'group.com.k4641321.chusearchsong_flutter',
    // );

    await v2ray.startV2Ray(
      remark: parser.remark,
      // The use of parser.getFullConfiguration() is not mandatory,
      // and you can enter the desired V2Ray configuration in JSON format
      config: parser.getFullConfiguration(),
      blockedApps: null,
      bypassSubnets: null,
      proxyOnly: false,
    );
  } catch (e) {
    log('$e', name: 'updatescorepagefun.dart', level: 1000);
  }
}

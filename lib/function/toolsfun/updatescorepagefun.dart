import 'dart:developer';
import 'package:flutter_singbox_client/flutter_singbox_client.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;

Future<void> connect({required SingboxClient client}) async {
  try {
    if (!await client.requestVPNPermission()) return;
    final config = await rootBundle.loadString('res/maimaiproxy_copy.json');
    // final config = await rootBundle.loadString('res/maimai-prober-proxy.yaml');
    try {
      await client.checkConfig(config);
    } catch (e) {
      log('$e', name: 'updatescorepagefun.dart', level: 1000);
      return;
    }
    await client.connect(
      SessionOptions(
        config: config,
        networkMode: NetworkMode.vpn,
        systemProxyEnabled: true,
        // perAppProxy: PerAppProxyOptions(
        //   mode: PerAppProxyMode.include,
        //   packages: [
        //     'com.k4641321.chusearchsong_flutter',
        //     'com.tencent.mm',
        //     'com.android.chromium',
        //   ],
        // ),
        notification: NotificationConfig(
          title: 'MaimaiProxy',
          showTrafficStats: true,
          showStopButton: false,
        ),
      ),
    );
  } catch (e) {
    log('$e', name: 'updatescorepagefun.dart', level: 1000);
  }
}
// weixin://dl/officialaccounts?scene=117&need_open_rich=1&url=<URL>

Future<void> getlxnssynchtml() async {
  final response = await get(Uri.parse('https://blog.4641321.xyz/oldhtml/'));
  // log(response.body);
  try {
    var document = parse(response.body);
    var oauth = document.querySelector('input')!.text;
    log(oauth.toString());
  } catch (e) {
    log('$e');
  }
  return;
}

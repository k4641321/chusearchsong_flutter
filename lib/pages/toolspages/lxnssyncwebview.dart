import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_v2ray_client/flutter_v2ray.dart';
import '../../tools/updatescorepagefun.dart';

class LxnsSyncWebView extends StatefulWidget {
  const LxnsSyncWebView({super.key});

  @override
  State<LxnsSyncWebView> createState() => _LxnsSyncWebViewState();
}

class _LxnsSyncWebViewState extends State<LxnsSyncWebView> {
  bool _switchValue = false;
  final V2ray v2ray = V2ray(
    onStatusChanged: (status) {
      // Handle status changes: connected, disconnected, etc.
      print('V2Ray status: ${status.state}');
    },
  );

  final controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // Update loading bar.
        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onHttpError: (HttpResponseError error) {},
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          if (request.url.startsWith('https://maimai.lxns.net/sync')) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    )
    ..loadRequest(Uri.parse('https://maimai.lxns.net/sync'));

  @override
  void initState() {
    super.initState();
    v2ray.initialize(
      notificationIconResourceType: 'com.k4641321.chusearchsong_flutter',
      notificationIconResourceName: 'group.com.k4641321.chusearchsong_flutter',
    );
  }

  @override
  void dispose() {
    v2ray.stopV2Ray();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('打开代理'),
            Switch(
              value: _switchValue,
              onChanged: (value) async {
                String link =
                    "vmess://ew0KICAidiI6ICIyIiwNCiAgInBzIjogIjEiLA0KICAiYWRkIjogInByb3h5Lm1haW1haS5seG5zLm5ldCIsDQogICJwb3J0IjogIjgwODAiLA0KICAiaWQiOiAiZGNjM2UzZmYtNjlmNC00NDk0LWI1NDgtMTc0ZWY1ODQ5OWE5IiwNCiAgImFpZCI6ICIwIiwNCiAgInNjeSI6ICJhdXRvIiwNCiAgIm5ldCI6ICJ0Y3AiLA0KICAidHlwZSI6ICJub25lIiwNCiAgInRscyI6ICIiLA0KICAiYWxwbiI6ICIiLA0KICAiaW5zZWN1cmUiOiAiMCINCn0=";
                //await rootBundle.loadString(
                //   'res/maimaiproxy.json',
                // );
                print(link);
                if (value) {
                  final allowed = await v2ray.requestPermission();
                  if (allowed) {
                    await connect(link, v2ray);
                  } else {
                    print('权限请求失败');
                    return;
                  }
                } else {
                  await v2ray.stopV2Ray();
                }
                setState(() {
                  _switchValue = value;
                });
              },
            ),
          ],
        ),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}

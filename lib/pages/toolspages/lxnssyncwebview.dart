import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../tools/updatescorepagefun.dart';
import 'package:flutter/services.dart';

class LxnsSyncWebView extends StatefulWidget {
  const LxnsSyncWebView({super.key});

  @override
  State<LxnsSyncWebView> createState() => _LxnsSyncWebViewState();
}

class _LxnsSyncWebViewState extends State<LxnsSyncWebView> {
  bool _switchValue = false;

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
  }

  @override
  void dispose() {
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
                // String link =
                //     "vmess://ew0KICAidiI6ICIyIiwNCiAgInBzIjogIjEiLA0KICAiYWRkIjogInByb3h5Lm1haW1haS5seG5zLm5ldCIsDQogICJwb3J0IjogIjgwODAiLA0KICAiaWQiOiAiZGNjM2UzZmYtNjlmNC00NDk0LWI1NDgtMTc0ZWY1ODQ5OWE5IiwNCiAgImFpZCI6ICIwIiwNCiAgInNjeSI6ICJhdXRvIiwNCiAgIm5ldCI6ICJ0Y3AiLA0KICAidHlwZSI6ICJub25lIiwNCiAgInRscyI6ICIiLA0KICAiYWxwbiI6ICIiLA0KICAiaW5zZWN1cmUiOiAiMCINCn0=";
                String link = await rootBundle.loadString(
                  'res/maimaiproxy.json',
                );
                // print(link);
                if (value) {
                  await V2rayService.start(link);
                } else {
                  await V2rayService.stop();
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

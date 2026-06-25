import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LxnsSyncWebView extends StatefulWidget {
  const LxnsSyncWebView({super.key});

  @override
  State<LxnsSyncWebView> createState() => _LxnsSyncWebViewState();
}

class _LxnsSyncWebViewState extends State<LxnsSyncWebView> {
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

  // final SingboxClient singbox = SingboxClient();

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
      appBar: AppBar(title: Row(children: [Text('落雪成绩更新')])),
      body: WebViewWidget(controller: controller),
    );
  }
}

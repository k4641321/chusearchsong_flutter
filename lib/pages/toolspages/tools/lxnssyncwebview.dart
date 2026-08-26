import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LxnsSyncWebView extends StatefulWidget {
  const LxnsSyncWebView({super.key});

  @override
  State<LxnsSyncWebView> createState() => _LxnsSyncWebViewState();
}

class _LxnsSyncWebViewState extends State<LxnsSyncWebView> {
  // Future<void> getOAuth() async {
  //   while (true) {
  //     var result = await controller.runJavaScriptReturningResult(
  //       "(function() {var inputs = document.querySelectorAll('input[readonly]');for (var i = 0; i < inputs.length; i++) {if (inputs[i].value && inputs[i].value.includes('wechat/auth')) {return inputs[i].value;}}return '';})()",
  //     );
  //     final url = result.toString().replaceAll('"', '');
  //     log(url);
  //     if (url.isNotEmpty) {
  //       log('退出');
  //       await Clipboard.setData(ClipboardData(text: url));
  //       await launchUrl(
  //         Uri.parse('weixin://'),
  //         mode: LaunchMode.externalApplication,
  //       );
  //       break;
  //     }
  //     log('继续');
  //     await Future.delayed(Duration(seconds: 2));
  //   }
  // }

  final controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // Update loading bar.
        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) async {},
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
  void didChangeDependencies() {
    // getOAuth();
    super.didChangeDependencies();
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

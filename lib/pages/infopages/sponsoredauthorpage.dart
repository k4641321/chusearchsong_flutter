import 'package:chusearchsong_flutter/function/infopagefun/infopagefun.dart';
import 'package:flutter/material.dart';

class Sponsoredauthorpage extends StatefulWidget {
  const Sponsoredauthorpage({super.key});

  @override
  State<Sponsoredauthorpage> createState() => _SponsoredauthorpageState();
}

class _SponsoredauthorpageState extends State<Sponsoredauthorpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('赞助作者')),
      body: Center(
        child: Column(
          children: [
            Text('你可以通过以下方式赞助作者，我更喜欢微信直接给我😋'),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () async {
                      try {
                        await lanuchifdian(context: context);
                      } catch (e) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text('打开爱发电链接失败')));
                      }
                    },
                    child: Text('使用爱发电'),
                  ),
                ),
              ],
            ),
            const Divider(),
            Expanded(child: Image.asset('res/zsm.png')),
          ],
        ),
      ),
    );
  }
}

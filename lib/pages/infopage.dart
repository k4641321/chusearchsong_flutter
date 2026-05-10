import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Info extends StatelessWidget {
  const Info({super.key});

  Future<void> _launchUrl({required BuildContext context}) async {
    final githuburl = Uri.parse(
      'https://github.com/k4641321/chusearchsong_flutter',
    );
    try {
      if (!await launchUrl(githuburl)) {
        if (!context.mounted) return;

        throw Exception('Could not launch $githuburl');
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('无法打开链接')));
    }
  }

  Future<void> _openQQ({required BuildContext context}) async {
    final Uri qqurl = Uri.parse(
      'myqqapi://card/show_pslcard?src_type=internal&version=1&card_type=group&uin=309546141',
    );
    final Uri qqurl2 = Uri.parse(
      'mqq://card/show_pslcard?src_type=internal&version=1&card_type=group&uin=309546141',
    );
    try {
      if (!await canLaunchUrl(qqurl)) {
        if (!context.mounted) return;

        throw Exception('Could not launch $qqurl');
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('无法打开链接，尝试第二种')));
      try {
        if (!await launchUrl(qqurl2)) {
          throw Exception('Could not launch $qqurl2');
        }
      } catch (e) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('无法打开链接')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  '一个由史山代码构成的答辩查歌软件，更多功能低赞开发中',
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.center,
                ),
                const Divider(),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: InkWell(
                    customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      ),
                    ),
                    onTap: () => _launchUrl(context: context),
                    child: Card(
                      color: const Color.fromARGB(255, 250, 231, 125),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '在Github关注此项目',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: InkWell(
                    customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0),
                      ),
                    ),
                    onTap: () => _openQQ(context: context),
                    child: Card(
                      color: const Color.fromARGB(255, 250, 231, 125),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '加入交流群',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ),
                const Divider(),
                Text('还没写完，下次再写'),
              ],
            ),
            Text('Mady by k4641321'),
          ],
        ),
      ),
    );
  }
}

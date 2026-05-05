import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Info extends StatelessWidget {
  const Info({super.key});

  Future<void> _launchUrl() async {
    final githuburl = Uri.parse(
      'https://github.com/k4641321/chusearchsong_flutter',
    );
    if (!await launchUrl(githuburl)) {
      throw Exception('Could not launch $githuburl');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text(
                '一个由史山代码构成的答辩查歌软件，更多功能低赞开发中',
                style: TextStyle(fontSize: 15),
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
                  onTap: _launchUrl,
                  child: Card(
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

              const Divider(),
              Text('还没写完，下次再写'),
            ],
          ),
          Text('Mady by k4641321'),
        ],
      ),
    );
  }
}

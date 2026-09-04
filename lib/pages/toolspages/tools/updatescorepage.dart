import 'package:chusearchsong_flutter/pages/toolspages/tools/proxyupdatescorepage.dart';
import 'package:flutter/material.dart';

class Updatescorepage extends StatefulWidget {
  const Updatescorepage({super.key});

  @override
  State<Updatescorepage> createState() => _UpdatescorepageState();
}

class _UpdatescorepageState extends State<Updatescorepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('更新成绩')),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    final platform = Theme.of(context).platform;
                    if (platform != TargetPlatform.android) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('不是目标平台，不给予打开')));
                      return;
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: ((context) => Proxyupdatescorepage()),
                      ),
                    );
                  },
                  child: Text('安卓代理更新入口'),
                ),
              ),
            ],
          ),
          Text('后面可能会更新OCR识别更新成绩，界面先这样'),
        ],
      ),
    );
  }
}

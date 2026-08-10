import 'package:chusearchsong_flutter/function/fun.dart';
import 'package:flutter/material.dart';

class FriendBattlePage extends StatefulWidget {
  const FriendBattlePage({super.key});

  @override
  State<StatefulWidget> createState() => _FriendBattlePageState();
}

class _FriendBattlePageState extends State<FriendBattlePage> {
  int mychart = 0;
  int friendchart = 0;
  int commonchart = 0;

  int win = 0;
  int lose = 0;
  int draw = 0;

  int myRating = 0;
  int friendRating = 0;

  List myscore = [];

  Future<void> readAgreement() async {
    Map<String, dynamic> config = await loadConfig();
    if (!config.containsKey('readfriendbattleagreement')) {
      if (!mounted) return;
      showDialog(
        context: (context),
        builder: (b) => AlertDialog(
          title: Text('提示'),
          content: Text(
            '由于落雪开发者无法获取玩家完整的所有成绩，您的数据将被上传到作者的数据库，点击确定同意使用，点击取消退出友人对战',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(b);
                Navigator.pop(context);
              },
              child: Text('取消'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(b);
                setState(() {
                  config['readfriendbattleagreement'] = true;
                  saveConfig(config);
                });
              },
              child: Text('确定'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    readAgreement();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("友人对战")),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(hint: Text('输入对方好友码')),
                ),
              ),
              TextButton(onPressed: () {}, child: Text('开始对比')),
            ],
          ),
          Card(
            child: Padding(
              padding: EdgeInsetsGeometry.all(8),
              child: Column(
                children: [
                  Text('结果', style: TextStyle(fontSize: 25)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text.rich(
                        TextSpan(
                          text: '$mychart\n',
                          children: [TextSpan(text: '我的谱面')],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text.rich(
                        TextSpan(
                          text: '$friendchart\n',
                          children: [TextSpan(text: '好友谱面')],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text.rich(
                        TextSpan(
                          text: '$commonchart\n',
                          children: [TextSpan(text: '共同谱面')],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Card(
                        color: const Color.fromARGB(255, 88, 216, 65),
                        child: Padding(
                          padding: EdgeInsetsGeometry.only(
                            top: 10,
                            bottom: 10,
                            right: 25,
                            left: 25,
                          ),
                          child: Text.rich(
                            TextSpan(
                              text: '$win\n',
                              children: [TextSpan(text: '胜')],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Card(
                        color: const Color.fromARGB(255, 244, 196, 64),
                        child: Padding(
                          padding: EdgeInsetsGeometry.only(
                            top: 10,
                            bottom: 10,
                            right: 25,
                            left: 25,
                          ),
                          child: Text.rich(
                            TextSpan(
                              text: '$draw\n',
                              children: [TextSpan(text: '平')],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Card(
                        color: const Color.fromARGB(255, 255, 68, 68),
                        child: Padding(
                          padding: EdgeInsetsGeometry.only(
                            top: 10,
                            bottom: 10,
                            right: 25,
                            left: 25,
                          ),
                          child: Text.rich(
                            TextSpan(
                              text: '$lose\n',
                              children: [TextSpan(text: '输')],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text('Rating: $myRating - $friendRating'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

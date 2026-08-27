import 'package:flutter/material.dart';

class ThankYouListPage extends StatelessWidget {
  const ThankYouListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('感谢名单')),
      body: Center(
        child: Column(
          children: [
            Text('排名不分前后'),
            const Divider(),
            Text('ChiffonOwO\n为B50生成，成绩的生成提供了优秀的方案，为IOS设备测试提供了支持'),
            const Divider(),
            Text('Komaeda\n为播放器界面改进提供了建议'),
            const Divider(),
            Text('宇文夕阳\n为不支持动态配色的设备测试提供帮助'),
            const Divider(),
            Text('耄耋鱼鱼\n为搜索筛选提供按音符查找的建议'),
            const Divider(),
            Text('Namis_0322\n为搜索筛选提供精确到小数的建议'),
            const Divider(),
            Text('3GHV3R.4NY1\n发现了各种B50生成称号超出范围的Bug'),
            const Divider(),
            Text('𝓨𝓾𝓻𝓲𝓬𝓲𝓪\n发现了在角色为null时无法生成B50与无法查看玩家信息'),
            const Divider(),
            Text('fu\n发现了在等级划分与判定的输入错误'),
            const Divider(),
            Text('不可发送单个标点符号\n为随机歌曲美化提供建议'),
            const Divider(),
            Text('以及使用这个软件的你'),
          ],
        ),
      ),
    );
  }
}

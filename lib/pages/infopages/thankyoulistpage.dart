import 'package:flutter/material.dart';

class ThankYouListPage extends StatelessWidget {
  const ThankYouListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('感谢名单')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // 头部
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                Icon(
                  Icons.favorite,
                  color: theme.colorScheme.primary,
                  size: 32,
                ),
                const SizedBox(height: 8),
                Text(
                  '感谢以下人员对本项目的贡献',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  '排名不分先后',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const Divider(),

          _buildThanksItem(
            context,
            name: 'ChiffonOwO',
            description: '为B50生成、成绩的生成提供了优秀的方案，为iOS设备测试提供了支持',
          ),
          _buildThanksItem(
            context,
            name: 'Komaeda',
            description: '为播放器界面改进提供了建议',
          ),
          _buildThanksItem(
            context,
            name: '宇文夕阳',
            description: '为不支持动态配色的设备测试提供帮助',
          ),
          _buildThanksItem(
            context,
            name: '耄耋鱼鱼',
            description: '为搜索筛选提供按音符查找的建议',
          ),
          _buildThanksItem(
            context,
            name: 'Namis_0322',
            description: '为搜索筛选提供精确到小数的建议',
          ),
          _buildThanksItem(
            context,
            name: '3GHV3R.4NY1',
            description: '发现了各种B50生成称号超出范围的Bug',
          ),
          _buildThanksItem(
            context,
            name: '𝓨𝓾𝓻𝓲𝓬𝓲𝓪',
            description: '发现了在角色为null时无法生成B50与无法查看玩家信息',
          ),
          _buildThanksItem(
            context,
            name: 'fu',
            description: '发现了在等级划分与判定的输入错误',
          ),
          _buildThanksItem(
            context,
            name: '不可发送单个标点符号',
            description: '为随机歌曲美化提供建议',
          ),
          _buildThanksItem(
            context,
            name: 'NANY',
            description: '发现单曲Rating计算器 苹果端无法输入小数点的问题',
          ),

          const Divider(),
          // 尾部
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.favorite_border,
                  size: 18,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    '以及使用这个软件的你',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.favorite_border,
                  size: 18,
                  color: theme.colorScheme.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThanksItem(
    BuildContext context, {
    required String name,
    required String description,
  }) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.star, size: 18, color: theme.colorScheme.primary),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

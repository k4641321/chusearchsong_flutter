import 'package:chusearchsong_flutter/pages/toolspages/other/generateimages/bingo.dart';
import 'package:chusearchsong_flutter/pages/toolspages/other/generateimages/chartsharepage.dart';
import 'package:flutter/material.dart';

class Generateimagesindexpage extends StatelessWidget {
  const Generateimagesindexpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('选择类型')),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildTile(
                  _ToolItem(
                    title: 'Bingo',
                    icon: Icons.photo_size_select_actual_rounded,
                    pageBuilder: (_) => Bingo(),
                  ),
                  context,
                ),
              ),
              Expanded(
                child: _buildTile(
                  _ToolItem(
                    title: '谱面分享',
                    icon: Icons.photo_size_select_actual_rounded,
                    pageBuilder: (_) => Chartsharepage(),
                  ),
                  context,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ToolItem {
  final String title;
  final IconData icon;
  final WidgetBuilder pageBuilder;
  final Future<void> Function(BuildContext)? onTap;

  const _ToolItem({
    required this.title,
    required this.icon,
    required this.pageBuilder,
  }) : onTap = null;
}

Widget _buildTile(_ToolItem item, BuildContext context) {
  return Card(
    color: Theme.of(context).colorScheme.secondaryContainer.withAlpha(200),
    child: TextButton.icon(
      onPressed: item.onTap != null
          ? () => item.onTap!(context)
          : () => Navigator.push(
              context,
              MaterialPageRoute(builder: item.pageBuilder),
            ),
      icon: Icon(item.icon, color: Theme.of(context).colorScheme.onSurface),
      label: Text(
        item.title,
        style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
      ),
    ),
  );
}

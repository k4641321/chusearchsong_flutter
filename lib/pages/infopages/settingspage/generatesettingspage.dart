import 'package:chusearchsong_flutter/function/writeandreadfun.dart';
import 'package:flutter/material.dart';

class Generatesettingspage extends StatefulWidget {
  const Generatesettingspage({super.key});

  @override
  State<Generatesettingspage> createState() => _GeneratesettingspageState();
}

class _GeneratesettingspageState extends State<Generatesettingspage> {
  Map<String, dynamic> config = {};

  Future<void> _loadConfig() async {
    config = await (await ReadData.create()).readConfig();
    setState(() {});
  }

  Widget _buildNavItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required bool isFirst,
    required bool isLast,
    required String value,
  }) {
    final borderRadius = BorderRadius.vertical(
      top: isFirst ? const Radius.circular(15) : Radius.zero,
      bottom: isLast ? const Radius.circular(15) : Radius.zero,
    );

    return Material(
      color: Theme.of(context).colorScheme.primaryContainer.withAlpha(120),
      borderRadius: borderRadius,
      child: InkWell(
        borderRadius: borderRadius,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(icon, size: 28),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Text(value),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('生成设置')),
      body: Padding(
        padding: EdgeInsetsGeometry.all(10),
        child: Column(
          children: [
            _buildNavItem(
              icon: Icons.high_quality,
              title: '清晰度',
              subtitle: '数值越高，越清晰，反之越小越糊',
              onTap: () async {
                double value = config['generatesettings']?['value'] ?? 1.0;
                await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('输入数值'),
                    content: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: value.toString(),
                            onChanged: (v) {
                              if (double.tryParse(v) != null) {
                                value = double.parse(v);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('取消'),
                      ),
                      TextButton(
                        onPressed: () async {
                          if (!config.containsKey('generatesettings')) {
                            config['generatesettings'] = {};
                          }
                          config['generatesettings']['value'] = value;
                          await (await WriteData.create()).writeConfig(config);
                          _loadConfig();
                          if (!context.mounted) return;
                          Navigator.pop(context);
                        },
                        child: Text('确定'),
                      ),
                    ],
                  ),
                );
              },
              isFirst: true,
              isLast: false,
              value: '${config['generatesettings']?['value'] ?? 1.0}',
            ),
            _buildNavItem(
              icon: Icons.perm_media,
              title: '首选格式',
              subtitle: '选择图片输出的格式',
              onTap: () async {
                if (!config.containsKey('generatesettings')) {
                  config['generatesettings'] = {};
                }
                await showDialog(
                  context: context,
                  builder: (context) => SimpleDialog(
                    title: Text('选择类型'),
                    children: [
                      ListTile(
                        title: Text('PNG'),
                        onTap: () async {
                          config['generatesettings']['preferredformat'] =
                              '.png';
                          await (await WriteData.create()).writeConfig(config);
                          _loadConfig();
                          if (!context.mounted) return;
                          Navigator.of(context).pop();
                        },
                      ),
                      ListTile(
                        title: Text('JPG'),
                        onTap: () async {
                          config['generatesettings']['preferredformat'] =
                              '.jpg';
                          await (await WriteData.create()).writeConfig(config);
                          _loadConfig();
                          if (!context.mounted) return;
                          Navigator.of(context).pop();
                        },
                      ),
                      ListTile(
                        title: Text('Webp'),
                        onTap: () async {
                          config['generatesettings']['preferredformat'] =
                              '.webp';
                          await (await WriteData.create()).writeConfig(config);
                          _loadConfig();
                          if (!context.mounted) return;
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                );
              },
              isFirst: false,
              isLast: true,
              value:
                  '${config['generatesettings']?['preferredformat'] ?? '.png'}',
            ),
          ],
        ),
      ),
    );
  }
}

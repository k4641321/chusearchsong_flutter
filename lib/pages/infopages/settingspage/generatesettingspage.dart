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
                double value = 1.0;
                await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('输入数值'),
                    content: Row(children: [Expanded(child: TextFormField())]),
                  ),
                );
              },
              isFirst: true,
              isLast: false,
              value: config[''],
            ),
          ],
        ),
      ),
    );
  }
}

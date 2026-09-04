import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:chusearchsong_flutter/function/infopagefun/settingspagefun.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'settingspage/lxnssettingspage.dart';
import 'settingspage/texttranslatesettingspage.dart';
import 'settingspage/mapsettingspage.dart';

class SettingsPage extends StatefulWidget {
  final VoidCallback? onThemeChanged;

  const SettingsPage({super.key, this.onThemeChanged});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final ScrollController _scrollController = ScrollController();
  bool chartproxy = false;
  bool autocheckupdate = false;
  String darkmode = 'light';

  Future<void> darkmodechange() async {
    final path = await getApplicationSupportDirectory();
    final config = File('${path.path}/config.json');
    final configStr = config.readAsStringSync();
    final configJson = json.decode(configStr);
    if (darkmode == 'light') {
      darkmode = 'dark';
      try {
        configJson['theme'] = 'dark';
        config.writeAsStringSync(json.encode(configJson));
      } catch (e) {
        log('$e', name: 'infopage', level: 500);
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('切换失败')));
      }
    } else if (darkmode == 'dark') {
      darkmode = 'light';
      try {
        configJson['theme'] = 'light';
        config.writeAsStringSync(json.encode(configJson));
      } catch (e) {
        log('$e', name: 'infopage', level: 500);
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('切换失败')));
      }
    }
    if (!mounted) return;
    setState(() {});
    widget.onThemeChanged?.call();
  }

  Future<void> confirmdarkmode() async {
    final path = await getApplicationSupportDirectory();
    try {
      String configStr = await File('${path.path}/config.json').readAsString();
      Map<String, dynamic> config = json.decode(configStr);
      if (config['theme'] == 'light') {
        darkmode = 'light';
      } else if (config['theme'] == 'dark') {
        darkmode = 'dark';
      }
      if (!mounted) return;
      setState(() {});
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('错误，配置文件不存在')));
    }
  }

  Future<void> init() async {
    try {
      final path = await getApplicationSupportDirectory();
      Map<String, dynamic> config = jsonDecode(
        await File('${path.path}/config.json').readAsString(),
      );
      setState(() {
        chartproxy = config['chartproxy'];
        if (!config.containsKey('autocheckupdate')) {
          return;
        } else {
          autocheckupdate = config['autocheckupdate'];
        }
      });
    } catch (e, strack) {
      log('$e\n$strack', name: 'settingspage.dart', level: 1000);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('错误：$e\$strack')));
    }
  }

  @override
  void initState() {
    super.initState();
    init();
    confirmdarkmode();
  }

  /// 导航类菜单项
  Widget _buildNavItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required bool isFirst,
    required bool isLast,
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
              Icon(
                Icons.chevron_right,
                size: 20,
                color: Theme.of(context).colorScheme.onSurface.withAlpha(100),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 开关类菜单项
  Widget _buildSwitchItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required bool isFirst,
    required bool isLast,
  }) {
    final borderRadius = BorderRadius.vertical(
      top: isFirst ? const Radius.circular(15) : Radius.zero,
      bottom: isLast ? const Radius.circular(15) : Radius.zero,
    );

    return Material(
      color: Theme.of(context).colorScheme.primaryContainer.withAlpha(120),
      borderRadius: borderRadius,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 8),
        child: SwitchListTile(
          contentPadding: EdgeInsets.zero,
          secondary: Icon(icon, size: 28),
          title: Text(title, style: const TextStyle(fontSize: 16)),
          subtitle: Text(
            subtitle,
            style: TextStyle(
              fontSize: 13,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          value: value,
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 0,
      indent: 58,
      color: Theme.of(context).colorScheme.onSurface.withAlpha(30),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('设置')),
      body: Scrollbar(
        controller: _scrollController,
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 16),

              // ── 第一组：翻译 + 落雪 ──
              _buildNavItem(
                icon: Icons.translate,
                title: '翻译设置',
                subtitle: '配置阿里云机器翻译参数',
                isFirst: true,
                isLast: false,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TextTranslateSettingsPage(),
                  ),
                ),
              ),
              _buildDivider(),
              _buildNavItem(
                icon: Icons.token,
                title: '落雪设置',
                subtitle: '配置落雪 Token',
                isFirst: false,
                isLast: true,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LxnsSettingsPage(),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ── 第二组：开关项 ──
              _buildSwitchItem(
                icon: Icons.vpn_key,
                title: '谱面预览加速（实验性）',
                subtitle: 'Vercel 代理，不确定是否可用',
                value: chartproxy,
                isFirst: true,
                isLast: false,
                onChanged: (value) async {
                  try {
                    setState(() => chartproxy = value);
                    await changeChartProxy(state: chartproxy);
                  } catch (e, stack) {
                    log('$e\n$stack');
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('错误：$e')));
                  }
                },
              ),
              _buildDivider(),
              _buildSwitchItem(
                icon: Icons.update_outlined,
                title: '自动检查更新',
                subtitle: '启动时是否自动检查更新',
                value: autocheckupdate,
                isFirst: false,
                isLast: true,
                onChanged: (value) async {
                  try {
                    setState(() => autocheckupdate = value);
                    final path = await getApplicationSupportDirectory();
                    final config = jsonDecode(
                      await File('${path.path}/config.json').readAsString(),
                    );
                    config['autocheckupdate'] = autocheckupdate;
                    await File(
                      '${path.path}/config.json',
                    ).writeAsString(jsonEncode(config));
                  } catch (e, stack) {
                    log('$e\n$stack');
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('错误：$e')));
                  }
                },
              ),

              const SizedBox(height: 24),

              // ── 第三组：主题 + 地图 ──
              _buildNavItem(
                icon: Icons.brightness_4,
                title: '主题模式',
                subtitle: '当前为：$darkmode',
                isFirst: true,
                isLast: false,
                onTap: darkmodechange,
              ),
              _buildDivider(),
              _buildNavItem(
                icon: Icons.map,
                title: '地图设置',
                subtitle: '设置首选地图',
                isFirst: false,
                isLast: true,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MapSettingsPage(),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

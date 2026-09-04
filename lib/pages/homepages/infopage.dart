import 'package:chusearchsong_flutter/function/infopagefun/infopagefun.dart';
import 'package:chusearchsong_flutter/pages/infopages/changeslogpage.dart';
import 'package:chusearchsong_flutter/pages/infopages/sponsoredauthorpage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:developer';
import '../../function/fun.dart';
import '../infopages/settingspage.dart';
import '../infopages/thankyoulistpage.dart';
import 'package:package_info_plus/package_info_plus.dart';

//页面扔给AI美化了一下

class Info extends StatefulWidget {
  const Info({super.key, this.onThemeChanged});

  final VoidCallback? onThemeChanged;

  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info> {
  Future<void> loadversion() async {
    try {
      final packageinfo = await PackageInfo.fromPlatform();
      if (!mounted) return;
      setState(() {
        version = packageinfo.version;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('获取版本号失败')));
      setState(() {
        version = '获取失败';
      });
    }
  }

  @override
  void initState() {
    super.initState();

    loadversion();
  }

  final ScrollController _controller = ScrollController();
  String version = '加载中';

  /// 构建单个菜单项
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isFirst = false,
    bool isLast = false,
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(icon, size: 22),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Scrollbar(
        controller: _controller,
        child: SingleChildScrollView(
          controller: _controller,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 40),

              // ── 头部：图标 + 标题 ──
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.asset(
                  'res/icon.png',
                  width: 90,
                  height: 90,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Icon(Icons.music_note, size: 40),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '中二查歌',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '一个由史山代码构成的答辩查歌软件',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withAlpha(160),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                'v$version',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withAlpha(120),
                ),
              ),

              // ── 社交图标 ──
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () => launchgithub(context: context),
                    icon: FaIcon(FontAwesomeIcons.github),
                    tooltip: 'GitHub',
                  ),
                  IconButton(
                    onPressed: () => openQQ(context: context),
                    icon: FaIcon(FontAwesomeIcons.qq),
                    tooltip: 'QQ 群',
                  ),
                  IconButton(
                    onPressed: () => lanuchhelpdocs(context: context),
                    icon: Icon(Icons.description),
                    tooltip: '帮助文档',
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // ── ChiffonMai 推广卡片 ──
              Card(
                elevation: 0,
                surfaceTintColor: Colors.transparent,
                color: theme.colorScheme.primaryContainer.withAlpha(120),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: () async {
                    final uri = Uri.parse(
                      'https://github.com/ChiffonOwO/ChiffonMai',
                    );
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(
                        uri,
                        mode: LaunchMode.externalApplication,
                      );
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        Icon(
                          Icons.open_in_new,
                          size: 20,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '功能最全的舞萌工具，尽在 ChiffonMai !',
                            style: TextStyle(
                              color: theme.colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ── 菜单分组 ──
              _buildMenuItem(
                icon: Icons.settings,
                title: '设置',
                isFirst: true,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SettingsPage(onThemeChanged: widget.onThemeChanged),
                  ),
                ),
              ),
              _buildDivider(),
              _buildMenuItem(
                icon: Icons.update,
                title: '检查更新',
                onTap: () async {
                  try {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(const SnackBar(content: Text('开始检查')));
                    final result = await checkforupdates();
                    if (!context.mounted) return;
                    if (result) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          content: const Text('发现新版本，是否前往下载？'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('取消'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                lanuchdownload(context: context);
                              },
                              child: const Text('确认'),
                            ),
                          ],
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(const SnackBar(content: Text('已经是最新版本')));
                    }
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
              _buildMenuItem(
                icon: Icons.favorite,
                title: '感谢名单',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ThankYouListPage(),
                  ),
                ),
              ),
              _buildDivider(),
              _buildMenuItem(
                icon: Icons.volunteer_activism,
                title: '赞助作者',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Sponsoredauthorpage(),
                  ),
                ),
              ),
              _buildDivider(),
              _buildMenuItem(
                icon: Icons.newspaper,
                title: '更新日志与公告',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Changeslogpage(),
                  ),
                ),
              ),
              _buildDivider(),
              _buildMenuItem(
                icon: Icons.upgrade,
                title: '更新数据',
                isLast: true,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (dialogContext) => SimpleDialog(
                      title: const Text('选择更新的数据'),
                      children: [
                        ListTile(
                          title: const Text('所有数据'),
                          onTap: () {
                            Navigator.of(dialogContext).pop();
                            Dataupdate.updateAllData(context: context);
                          },
                        ),
                        ListTile(
                          title: const Text('仅成绩'),
                          onTap: () {
                            Navigator.of(dialogContext).pop();
                            Dataupdate.updateScore(context: context);
                          },
                        ),
                        ListTile(
                          title: const Text('仅机厅数据(新)'),
                          onTap: () {
                            Navigator.of(dialogContext).pop();
                            Dataupdate.updateNearcadeShopData(context: context);
                          },
                        ),
                        ListTile(
                          title: const Text('仅基础数据'),
                          onTap: () {
                            Navigator.of(dialogContext).pop();
                            Dataupdate.updateBaseData(context: context);
                          },
                        ),
                        ListTile(
                          title: const Text('仅最新最热数据'),
                          onTap: () {
                            Navigator.of(dialogContext).pop();
                            Dataupdate.updatezxzrsongsData(context: context);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              // ── 底部 ──
              Text(
                '还没写完，下次再写',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withAlpha(100),
                ),
              ),
              Text(
                'Made by k4641321',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withAlpha(100),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  /// 菜单项之间的分割线
  Widget _buildDivider() {
    return Divider(
      height: 0,
      indent: 52,
      color: Theme.of(context).colorScheme.onSurface.withAlpha(30),
    );
  }
}

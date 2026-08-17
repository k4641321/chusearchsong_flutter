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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Scrollbar(
          controller: _controller,
          child: SingleChildScrollView(
            controller: _controller,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Image.asset(
                      'res/icon.png',
                      width: 150,
                      height: 150,
                      errorBuilder: (context, error, stackTrace) {
                        return const Text('图片加载失败');
                      },
                    ),
                    Text(
                      '一个由史山代码构成的答辩查歌软件，更多功能低赞开发中',
                      style: TextStyle(fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      '当前版本号：$version',
                      style: TextStyle(fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () => launchgithub(context: context),
                          icon: FaIcon(FontAwesomeIcons.github),
                        ),
                        IconButton(
                          onPressed: () => openQQ(context: context),
                          icon: FaIcon(FontAwesomeIcons.qq),
                        ),
                        IconButton(
                          onPressed: () => lanuchhelpdocs(context: context),
                          icon: Icon(Icons.description),
                        ),
                      ],
                    ),
                    const Divider(),
                    InkWell(
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
                      child: Text('功能最全的舞萌工具，尽在 ChiffonMai !\n（点击文字即可跳转到项目页面）'),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            customBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0),
                              ),
                            ),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SettingsPage(
                                  onThemeChanged: widget.onThemeChanged,
                                ),
                              ),
                            ),
                            child: Card(
                              color: Theme.of(
                                context,
                              ).colorScheme.primaryContainer.withAlpha(150),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.settings, size: 25),
                                    Text(
                                      '设置',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            customBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0),
                              ),
                            ),
                            onTap: () async {
                              try {
                                ScaffoldMessenger.of(
                                  context,
                                ).showSnackBar(SnackBar(content: Text('开始检查')));
                                bool result = await checkforupdates();
                                if (result) {
                                  if (!context.mounted) return;
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      content: Text('发现新版本，是否前往下载？'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          child: Text('取消'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            // 执行操作
                                            Navigator.of(context).pop();
                                            await lanuchdownload(
                                              context: context,
                                            );
                                          },
                                          child: Text('确认'),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('已经是最新版本')),
                                  );
                                }
                              } catch (e, strack) {
                                log('$e\n$strack');
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('错误：$e\n$strack')),
                                );
                              }
                            },
                            child: Card(
                              color: Theme.of(
                                context,
                              ).colorScheme.primaryContainer.withAlpha(150),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(0.0),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.update, size: 25),
                                    Text(
                                      '检查更新',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            customBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0),
                              ),
                            ),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ThankYouListPage(),
                              ),
                            ),
                            child: Card(
                              color: Theme.of(
                                context,
                              ).colorScheme.primaryContainer.withAlpha(150),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(0.0),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.favorite),
                                    Text(
                                      '感谢名单',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            customBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0),
                              ),
                            ),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Sponsoredauthorpage(),
                              ),
                            ),
                            child: Card(
                              color: Theme.of(
                                context,
                              ).colorScheme.primaryContainer.withAlpha(150),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(0.0),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.volunteer_activism),
                                    Text(
                                      '赞助作者',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            customBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0),
                              ),
                            ),
                            onTap: () async {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => Changeslogpage(),
                                ),
                              );
                            },
                            child: Card(
                              color: Theme.of(
                                context,
                              ).colorScheme.primaryContainer.withAlpha(150),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(0.0),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.newspaper),
                                    Text(
                                      '更新日志与公告',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            customBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0),
                              ),
                            ),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (dialogContext) => AlertDialog(
                                  title: Text('选择更新的数据'),
                                  content: Column(
                                    children: [
                                      ListTile(
                                        title: Text('所有数据'),
                                        onTap: () {
                                          Navigator.of(dialogContext).pop();
                                          Dataupdate.updateAllData(
                                            context: context,
                                          );
                                        },
                                      ),
                                      ListTile(
                                        title: Text('仅成绩'),
                                        onTap: () {
                                          Navigator.of(dialogContext).pop();
                                          Dataupdate.updateScore(
                                            context: context,
                                          );
                                        },
                                      ),
                                      ListTile(
                                        title: Text('仅机厅数据(新)'),
                                        onTap: () {
                                          Navigator.of(dialogContext).pop();
                                          Dataupdate.updateNearcadeShopData(
                                            context: context,
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              color: Theme.of(
                                context,
                              ).colorScheme.primaryContainer.withAlpha(150),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(15),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.upgrade, size: 25),
                                    Text(
                                      '更新数据',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    Text('还没写完，下次再写'),
                  ],
                ),
                Text('Mady by k4641321'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:developer';
import '../tools/fun.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'infopages/settingspage.dart';
import '../pages/infopages/thankyoulistpage.dart';

class Info extends StatefulWidget {
  const Info({super.key, this.onThemeChanged});

  final VoidCallback? onThemeChanged;

  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info> {
  Future<void> _launchUrl({required BuildContext context}) async {
    final githuburl = Uri.parse(
      'https://github.com/k4641321/chusearchsong_flutter',
    );
    try {
      if (!await launchUrl(githuburl)) {
        if (!context.mounted) return;

        throw Exception('Could not launch $githuburl');
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('无法打开链接')));
    }
  }

  Future<void> _openQQ({required BuildContext context}) async {
    final Uri qqurl = Uri.parse(
      'myqqapi://card/show_pslcard?src_type=internal&version=1&card_type=group&uin=309546141',
    );
    final Uri qqurl2 = Uri.parse(
      'mqq://card/show_pslcard?src_type=internal&version=1&card_type=group&uin=309546141',
    );
    try {
      if (await canLaunchUrl(qqurl)) {
        await launchUrl(qqurl);
        return;
      }
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('无法打开链接，尝试第二种')));
      if (await canLaunchUrl(qqurl2)) {
        log('尝试第二种');
        await launchUrl(qqurl2);
      } else if (!await canLaunchUrl(qqurl2)) {
        throw Exception('Could not launch $qqurl2');
      }
    } catch (e) {
      log('$e', name: 'infopage', level: 500);
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('无法打开链接')));
    }
  }

  String darkmode = 'light';
  void darkmodechange() async {
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

  @override
  void initState() {
    super.initState();
    confirmdarkmode();
  }

  final ScrollController _controller = ScrollController();

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
                      '当前版本号：0.13.0',
                      style: TextStyle(fontSize: 15),
                      textAlign: TextAlign.center,
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
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: InkWell(
                        customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0),
                          ),
                        ),
                        onTap: () => _launchUrl(context: context),
                        child: Card(
                          color: Theme.of(context).colorScheme.primaryFixedDim,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '在Github关注此项目',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: InkWell(
                        customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                          ),
                        ),
                        onTap: () => _openQQ(context: context),
                        child: Card(
                          color: Theme.of(context).colorScheme.primaryFixedDim,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(0.0),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '加入交流群',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: InkWell(
                        customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                          ),
                        ),
                        onTap: darkmodechange,
                        child: Card(
                          color: Theme.of(context).colorScheme.primaryFixedDim,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(0.0),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '主题模式: $darkmode',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
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
                            builder: (context) => SettingsPage(),
                          ),
                        ),
                        child: Card(
                          color: Theme.of(context).colorScheme.primaryFixedDim,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(0.0),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '设置',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: InkWell(
                        customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                          ),
                        ),
                        onTap: () => ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text('别急，在做了'))),
                        child: Card(
                          color: Theme.of(context).colorScheme.primaryFixedDim,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(0.0),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '检查更新',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
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
                          color: Theme.of(context).colorScheme.primaryFixedDim,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(0.0),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '感谢名单',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: InkWell(
                        customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                          ),
                        ),
                        onTap: () => updateData(context: context),
                        child: Card(
                          color: Theme.of(context).colorScheme.primaryFixedDim,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10.0),
                              bottomRight: Radius.circular(10.0),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '更新数据',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ),
                      ),
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

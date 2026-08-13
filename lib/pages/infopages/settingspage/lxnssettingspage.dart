import 'dart:convert';

import 'package:chusearchsong_flutter/function/request.dart';
import 'package:flutter/material.dart';
import '../../../function/infopagefun/settingspagefun.dart';

class LxnsSettingsPage extends StatefulWidget {
  const LxnsSettingsPage({super.key});

  @override
  State<LxnsSettingsPage> createState() => _LxnsSettingsPageState();
}

class _LxnsSettingsPageState extends State<LxnsSettingsPage> {
  final TextEditingController tokenController = TextEditingController();

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textEditingController = TextEditingController();

  Future<void> loadtextfield() async {
    Map<String, dynamic> result = await loadlxnsconfig(context);
    if (result.isEmpty) return;
    if (!mounted) return;
    setState(() {
      tokenController.text = result['token'];
    });
  }

  //YboiNUUXK0v4RR7GlOgvzF9Th44nAJ8_-mgf2aZ-I9A=
  @override
  void initState() {
    super.initState();
    loadtextfield();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('落雪设置')),
      body: Scrollbar(
        controller: _scrollController,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Center(
            child: Column(
              children: [
                Row(
                  children: [
                    Text('Token（个人 API 密钥）'),
                    Expanded(child: TextField(controller: tokenController)),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        child: TextButton(
                          onPressed: () async {
                            try {
                              String token = tokenController.text;
                              await savelxnstokenconfig(
                                lxnstoken: token,
                                context: context,
                              );
                            } catch (e) {
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(SnackBar(content: Text('错误: $e')));
                            }
                          },
                          child: Text(
                            '保存设置',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(),
                TextButton(
                  onPressed: () async {
                    await openlxnsprofile();
                  },
                  child: Text('点击按钮前往落雪个人界面复制token'),
                ),
                const Divider(),
                Text('当然，你也可以选择使用授权自动填充Token,自动填充完后记得点保存'),
                TextButton(
                  onPressed: () async {
                    await openlxnsAuthorization();
                  },
                  child: Text('前往授权'),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textEditingController,
                        decoration: InputDecoration(hintText: '授权码'),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text('正在获取，请稍等')));
                        try {
                          Map<String, dynamic> result = jsonDecode(
                            await requestOAuthCallbackToken(
                              _textEditingController.text,
                            ),
                          );
                          if (!mounted) return;
                          setState(() {
                            tokenController.text = result['data']['token'];
                          });
                        } catch (e) {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('请检查授权码是否输错\n错误: $e')),
                          );
                        }
                      },
                      child: Text('确定'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

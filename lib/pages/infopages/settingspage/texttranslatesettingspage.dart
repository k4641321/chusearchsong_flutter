import 'package:flutter/material.dart';
import '../../../tools/settingspagefun.dart';

class TextTranslateSettingsPage extends StatefulWidget {
  const TextTranslateSettingsPage({super.key});

  @override
  State<TextTranslateSettingsPage> createState() =>
      _TextTranslateSettingsPageState();
}

class _TextTranslateSettingsPageState extends State<TextTranslateSettingsPage> {
  final TextEditingController secretIdController = TextEditingController();
  final TextEditingController secretKeyController = TextEditingController();
  final TextEditingController projectIdController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Future<void> loadtextfield() async {
    Map<String, dynamic> result = await loadtexttranslateconfig(context);
    if (result.isEmpty) return;
    setState(() {
      secretIdController.text = result['secretId'];
      secretKeyController.text = result['secretKey'];
      projectIdController.text = result['projectId'];
    });
  }

  @override
  void initState() {
    super.initState();
    loadtextfield();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('翻译设置')),
      body: Scrollbar(
        controller: _scrollController,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Center(
            child: Column(
              children: [
                Row(
                  children: [
                    Text('SecretId  '),
                    Expanded(child: TextField(controller: secretIdController)),
                  ],
                ),
                Row(
                  children: [
                    Text('SecretKey  '),
                    Expanded(child: TextField(controller: secretKeyController)),
                  ],
                ),
                Row(
                  children: [
                    Text('ProjectId  '),
                    Expanded(child: TextField(controller: projectIdController)),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        child: TextButton(
                          onPressed: () async {
                            try {
                              String secretId = secretIdController.text;
                              String secretKey = secretKeyController.text;
                              String projectId = projectIdController.text;
                              await savetexttranslateconfig(
                                secretId: secretId,
                                secretKey: secretKey,
                                projectId: projectId,
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
                Text('翻译采用腾讯云的机器翻译，请自行申请相关密钥，个人版每月的免费额度够用了'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../tools/settingspagefun.dart';

class LxnsSettingsPage extends StatefulWidget {
  const LxnsSettingsPage({super.key});

  @override
  State<LxnsSettingsPage> createState() => _LxnsSettingsPageState();
}

class _LxnsSettingsPageState extends State<LxnsSettingsPage> {
  final TextEditingController tokenController = TextEditingController();

  final ScrollController _scrollController = ScrollController();
  Future<void> loadtextfield() async {
    Map<String, dynamic> result = await loadlxnsconfig(context);
    if (result.isEmpty) return;
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
                    Text('Token  '),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

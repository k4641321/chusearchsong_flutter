import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

Future<void> savetexttranslateconfig({
  required String secretId,
  required String secretKey,
  required String projectId,
  required BuildContext context,
}) async {
  final Directory directory = await getApplicationSupportDirectory();
  final File file = File('${directory.path}/config.json');
  try {
    final String configstr = await file.readAsString();
    Map<String, dynamic> config = json.decode(configstr);
    if (!config.containsKey('texttranslate')) {
      config['texttranslate'] = {};
    }
    config['texttranslate']['secretId'] = secretId;
    config['texttranslate']['secretKey'] = secretKey;
    config['texttranslate']['projectId'] = projectId;
    await file.writeAsString(json.encode(config));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('成功')));

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('成功')));
  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('错误，保存SecretId和SecretKey失败，请检查是否配置正确')),
    );
  }
}

Future<Map<String, dynamic>> loadconfig(BuildContext context) async {
  final Directory directory = await getApplicationSupportDirectory();
  final File file = File('${directory.path}/config.json');
  try {
    final String configstr = await file.readAsString();
    Map<String, dynamic> config = json.decode(configstr);
    // print(config);
    Map<String, dynamic> texttranslate = config['texttranslate'];
    return texttranslate;
  } catch (e) {
    if (!context.mounted) return {};
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('错误，读取配置文件失败，请检查是否配置正确')));
    return {};
  }
}

import 'dart:developer';
import 'request.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:package_info_plus/package_info_plus.dart';

Future<void> savetexttranslateconfig({
  required String secretId,
  required String secretKey,
  required String projectId,
  required BuildContext context,
}) async {
  try {
    final Directory directory = await getApplicationSupportDirectory();
    final File file = File('${directory.path}/config.json');
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
  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('错误，保存SecretId和SecretKey失败，请检查是否配置正确 $e')),
    );
  }
}

Future<Map<String, dynamic>> loadtexttranslateconfig(
  BuildContext context,
) async {
  try {
    final Directory directory = await getApplicationSupportDirectory();
    final File file = File('${directory.path}/config.json');
    final String configstr = await file.readAsString();
    Map<String, dynamic> config = json.decode(configstr);
    // print(config);
    Map<String, dynamic> texttranslate = config['texttranslate'];
    return texttranslate;
  } catch (e) {
    if (!context.mounted) return {};
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('错误，读取配置文件失败，请检查是否配置正确 $e')));
    return {};
  }
}

Future<void> savelxnstokenconfig({
  required String lxnstoken,
  required BuildContext context,
}) async {
  try {
    final Directory directory = await getApplicationSupportDirectory();
    final File file = File('${directory.path}/config.json');
    final String configstr = await file.readAsString();
    Map<String, dynamic> config = json.decode(configstr);
    if (!config.containsKey('lxns')) {
      config['lxns'] = {};
    }
    config['lxns']['token'] = lxnstoken;
    await file.writeAsString(json.encode(config));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('成功')));
  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('错误，保存Token失败，请检查是否配置正确 $e')));
  }
  try {
    await saveAllScore();
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('获取成绩成功')));
  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('错误，获取成绩失败 $e')));
    log('$e', name: 'settingspagefun.dart', level: 1000);
  }
  try {
    await saveTrend();
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('获取Rating趋势成功')));
  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('错误，获取Rating趋势失败 $e')));
    log('$e', name: 'settingspagefun.dart', level: 1000);
  }
  try {
    await saveB50();
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('获取B50成功')));
  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('错误，获取B50失败 $e')));
    log('$e', name: 'settingspagefun.dart', level: 1000);
  }
  try {
    await savePlayerInfo();
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('获取玩家信息成功')));
  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('错误，获取玩家信息失败 $e')));
    log('$e', name: 'settingspagefun.dart', level: 1000);
  }
}

Future<Map<String, dynamic>> loadlxnsconfig(BuildContext context) async {
  try {
    final Directory directory = await getApplicationSupportDirectory();
    final File file = File('${directory.path}/config.json');
    final String configstr = await file.readAsString();
    Map<String, dynamic> config = json.decode(configstr);
    // print(config);
    Map<String, dynamic> lxns = config['lxns'];
    return lxns;
  } catch (e) {
    if (!context.mounted) return {};
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('错误，读取配置文件失败，请检查是否配置正确 $e')));
    return {};
  }
}

Future<void> updateconfig() async {
  final path = await getApplicationSupportDirectory();
  final configstr = File('${path.path}/config.json').readAsStringSync();
  final packageinfo = await PackageInfo.fromPlatform();
  Map<String, dynamic> config = json.decode(configstr);
  if (!config.containsKey('map')) config['map'] = 'amap';
  if (!config.containsKey('init')) config['init'] = true;
  if (!config.containsKey('chartproxy')) config['chartproxy'] = false;
  if (!config.containsKey('changeslogread')) config['changeslogread'] = false;
  if (packageinfo.version != config['version']) {
    config['changeslogread'] = false;
  }
  config['version'] = packageinfo.version;
  File('${path.path}/config.json').writeAsStringSync(json.encode(config));
  await saveLatestVersion();
}

Future<String> loadmapconfig(BuildContext context) async {
  try {
    final Directory directory = await getApplicationSupportDirectory();
    final File file = File('${directory.path}/config.json');
    final String configstr = await file.readAsString();
    Map<String, dynamic> config = json.decode(configstr);
    // print(config);
    String mapconfig = config['map'];
    return mapconfig;
  } catch (e) {
    if (!context.mounted) return 'amap';
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('错误，读取配置文件失败，请检查是否配置正确 $e')));
    return 'amap';
  }
}

Future<void> saveMapConfig(String map, BuildContext context) async {
  try {
    final Directory directory = await getApplicationSupportDirectory();
    final File file = File('${directory.path}/config.json');
    final String configstr = await file.readAsString();
    Map<String, dynamic> config = json.decode(configstr);
    config['map'] = map;
    await file.writeAsString(json.encode(config));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('成功')));
  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('错误，保存配置文件失败，请检查是否配置正确 $e')));
  }
}

Future<void> changeChartProxy({required bool state}) async {
  final Directory directory = await getApplicationSupportDirectory();
  final File file = File('${directory.path}/config.json');
  final String configstr = await file.readAsString();
  Map<String, dynamic> config = json.decode(configstr);
  config['chartproxy'] = state;
  await file.writeAsString(json.encode(config));
}

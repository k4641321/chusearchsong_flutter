import 'package:chusearchsong_flutter/function/writeandreadfun.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

Future<void> savetexttranslateconfig({
  required String secretId,
  required String secretKey,
  // required String projectId,
  required BuildContext context,
}) async {
  try {
    Map<String, dynamic> config = await (await ReadData.create()).readConfig();
    if (!config.containsKey('texttranslate')) {
      config['texttranslate'] = {};
    }
    config['texttranslate']['accessKeyId'] = secretId;
    config['texttranslate']['accessKeySecret'] = secretKey;
    // config['texttranslate']['projectId'] = projectId;
    await (await WriteData.create()).writeConfig(config);
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
    Map<String, dynamic> config = await (await ReadData.create()).readConfig();
    // print(config);
    if (!config.containsKey('texttranslate')) return {};
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
    Map<String, dynamic> config = await (await ReadData.create()).readConfig();
    if (!config.containsKey('lxns')) {
      config['lxns'] = {};
    }
    config['lxns']['token'] = lxnstoken;
    await (await WriteData.create()).writeConfig(config);
  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('错误，保存Token失败，请检查是否配置正确 $e')));
  }
}

Future<Map<String, dynamic>> loadlxnsconfig(BuildContext context) async {
  try {
    Map<String, dynamic> config = await (await ReadData.create()).readConfig();
    // print(config);
    if (!config.containsKey('lxns')) return {};
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

Future<String> loadmapconfig(BuildContext context) async {
  try {
    Map<String, dynamic> config = await (await ReadData.create()).readConfig();
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
    Map<String, dynamic> config = await (await ReadData.create()).readConfig();
    config['map'] = map;
    await (await WriteData.create()).writeConfig(config);
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
  Map<String, dynamic> config = await (await ReadData.create()).readConfig();
  config['chartproxy'] = state;
  await (await WriteData.create()).writeConfig(config);
}

Future<void> openlxnsprofile() async {
  launchUrl(Uri.parse('https://maimai.lxns.net/user/profile?tab=thirdparty'));
}

Future<void> openlxnsAuthorization() async {
  launchUrl(
    Uri.parse(
      'https://maimai.lxns.net/oauth/authorize?response_type=code&client_id=522e68e2-c7eb-4a46-b55d-2e8331297ced&redirect_uri=urn%3Aietf%3Awg%3Aoauth%3A2.0%3Aoob&scope=read_user_token',
    ),
  );
}

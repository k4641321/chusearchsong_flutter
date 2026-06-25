import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:chusearchsong_flutter/tools/fun.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:developer';

Future<void> openmap({
  required Map<String, dynamic> i,
  required BuildContext context,
}) async {
  final String myapp = 'com.k4641321.chusearchsong_flutter';
  Future<void> openamap() async {
    final Uri url = Uri.parse(
      'androidamap://poi?sourceApplication=$myapp&keywords=${i['address']}',
    );
    final Uri url2 = Uri.parse(
      'amapuri://keywordsearch?keywords=${i['address']}&sourceApplication=$myapp',
    );
    final Uri url3 = Uri.parse(
      'amapuri://poi?sourceApplication=$myapp&keywords=${i['address']}',
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('打开高德地图，尝试第一种'),
        duration: Duration(milliseconds: 500),
      ),
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
      return;
    }
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('无法打开高德地图，尝试第二种'),
        duration: Duration(milliseconds: 500),
      ),
    );
    if (await canLaunchUrl(url2)) {
      await launchUrl(url2);
      return;
    }
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('无法打开高德地图，尝试第三种'),
        duration: Duration(milliseconds: 500),
      ),
    );
    if (await canLaunchUrl(url3)) {
      await launchUrl(url3);
      return;
    } else {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('无法打开高德地图，我没招了'),
          duration: Duration(milliseconds: 500),
        ),
      );
    }
  }

  Future<void> openbaidu() async {
    final Uri url = Uri.parse(
      'baidumap://map/place/search?query=${i['address']}&src=$myapp',
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('打开百度地图，尝试'),
        duration: Duration(milliseconds: 500),
      ),
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
      return;
    } else {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('无法打开百度地图'),
          duration: Duration(milliseconds: 500),
        ),
      );
    }
  }

  Future<void> opentencent() async {
    final Uri url = Uri.parse(
      'qqmap://map/search?keyword=${i['address']}&sourceApp=$myapp',
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('开个屁腾讯地图，还要key，麻烦'),
        duration: Duration(milliseconds: 1500),
      ),
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
      return;
    } else {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('不开'), duration: Duration(milliseconds: 1500)),
      );
    }
  }

  try {
    final path = await getApplicationSupportDirectory();
    final configstr = await File('${path.path}/config.json').readAsString();
    final config = json.decode(configstr) as Map<String, dynamic>;
    if (config['map'] == 'amap') {
      openamap();
    } else if (config['map'] == 'baidu') {
      openbaidu();
    } else if (config['map'] == 'tencent') {
      opentencent();
    }
  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('无法打开地图')));
    log('$e', name: 'searchLobbyPage', level: 1000);
  }
}

Future<List<Widget>> search({
  required List<Widget> searchResults,
  required TextEditingController controller,
  required String initialSelection,
  required BuildContext context,
}) async {
  final dataPath = await getApplicationSupportDirectory();
  String lobbyDataStr = await File(
    '${dataPath.path}/res/location.json',
  ).readAsString();
  final lobbyDataJson = json.decode(lobbyDataStr) as List;
  List searchResults2 = [];
  List<Widget> searchResults3 = [];
  searchResults.clear();
  for (var i in lobbyDataJson) {
    if (i['arcadeName'].toLowerCase().contains(controller.text.toLowerCase())) {
      searchResults2.add(i);
    }
  }
  // print(searchResults2);
  if (initialSelection == '全部') {
    log('跳过地区筛选');
    for (var i in searchResults2) {
      searchResults3.add(
        InkWell(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                '${i['province']} - ${i['arcadeName']}\n${i['address']}',
              ),
            ),
          ),
          onTap: () => openmap(i: i, context: context),
          onLongPress: () => copytext(text: i['address'], context: context),
        ),
      );
    }
  } else {
    for (var i in searchResults2) {
      if (i['province'] == initialSelection) {
        searchResults3.add(
          InkWell(
            onLongPress: () => copytext(text: i['address'], context: context),
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  '${i['province']} - ${i['arcadeName']}\n${i['address']}',
                ),
              ),
            ),
            onTap: () => openmap(i: i, context: context),
          ),
        );
      }
    }
  }
  // print(searchResults);
  log('搜索完成');
  return searchResults3;
}

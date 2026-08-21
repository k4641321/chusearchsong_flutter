import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chusearchsong_flutter/function/toolsfun/playerinfopagefun.dart';
import 'package:chusearchsong_flutter/pages/toolspages/collectibleinfopage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

//收藏品搜索
Future<List<Widget>> searchCollectibles({
  required String searchtext,
  required BuildContext context,
  required String searchtype,
  required bool isSonginfo,
}) async {
  List<Widget> collectibles = [];
  final directory = await getApplicationSupportDirectory();
  final path = Directory('${directory.path}/res/');

  Widget returnWidget({
    required Map<String, dynamic> data,
    required String type,
  }) {
    String entype = '';
    switch (type) {
      case '头像':
        entype = 'icon';
        break;
      case '名牌版':
        entype = 'plate';
        break;
      case '称号':
        entype = 'trophy';
        break;
      case '角色':
        entype = 'character';
        break;
    }
    if (isSonginfo == true) {
      // print('$data');
      return InkWell(
        onTap: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  CollectibleInfoPage(data: data, type: entype),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: returnTrophyBackgroundColor(data['color']),
            border: Border.all(color: returnTrophyColor(data['color'])),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          padding: EdgeInsets.all(4),

          child: Text('${data['id']} - ${data['name']} - $type'),
        ),
      );
    } else {
      Widget image = SizedBox.shrink();
      if (entype != 'trophy') {
        double width = 75;
        if (entype == 'plate') {
          width = 150;
        }
        image = CachedNetworkImage(
          width: width,
          imageUrl:
              'https://assets2.lxns.net/chunithm/$entype/${data['id']}.png',
          errorWidget: (context, url, error) => SizedBox.shrink(),
        );
      }
      return Row(
        children: [
          Expanded(
            child: InkWell(
              // key: ValueKey(data['id']),
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CollectibleInfoPage(data: data, type: entype),
                  ),
                );
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      image,
                      Expanded(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '${data['name']}',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    type,
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '#${data['id']}',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }
  }

  //头像搜索
  if ((searchtype == 'icon' ||
          searchtype == 'all' ||
          searchtype == 'required') &&
      isSonginfo == false) {
    String iconJsonStr = await File('${path.path}/icons.json').readAsString();
    Map<String, dynamic> iconJson = json.decode(iconJsonStr);
    for (var i in iconJson['icons']) {
      if (i['name'].toLowerCase().contains(searchtext.toLowerCase()) ||
          i['description'].toLowerCase().contains(searchtext.toLowerCase()) ||
          i['id'].toString().contains(searchtext)) {
        if (searchtype == 'required' &&
            !(i as Map<String, dynamic>).containsKey('required')) {
          continue;
        }
        collectibles.add(returnWidget(data: i, type: '头像'));
      }
    }
  } else if (searchtype == 'icon' && isSonginfo == true) {
    String iconJsonStr = await File('${path.path}/icons.json').readAsString();
    Map<String, dynamic> iconJson = json.decode(iconJsonStr);
    for (var i in iconJson['icons']) {
      if (i['id'] == int.parse(searchtext)) {
        collectibles.add(returnWidget(data: i, type: '头像'));
      }
    }
  }

  //名牌版搜索
  if ((searchtype == 'plate' ||
          searchtype == 'all' ||
          searchtype == 'required') &&
      isSonginfo == false) {
    String plateJsonStr = await File('${path.path}/plates.json').readAsString();
    Map<String, dynamic> plateJson = json.decode(plateJsonStr);
    for (var i in plateJson['plates']) {
      if (i['name'].toLowerCase().contains(searchtext.toLowerCase()) ||
          i['description'].toLowerCase().contains(searchtext.toLowerCase()) ||
          i['id'].toString().contains(searchtext)) {
        if (searchtype == 'required' &&
            !(i as Map<String, dynamic>).containsKey('required')) {
          continue;
        }
        collectibles.add(returnWidget(data: i, type: '名牌版'));
      }
    }
  } else if (searchtype == 'plate' && isSonginfo == true) {
    String plateJsonStr = await File('${path.path}/plates.json').readAsString();
    Map<String, dynamic> plateJson = json.decode(plateJsonStr);
    for (var i in plateJson['plates']) {
      if (i['id'] == int.parse(searchtext)) {
        collectibles.add(returnWidget(data: i, type: '名牌版'));
      }
    }
  }

  //称号搜索
  if ((searchtype == 'trophy' ||
          searchtype == 'all' ||
          searchtype == 'required') &&
      isSonginfo == false) {
    String trophyJsonStr = await File(
      '${path.path}/trophies.json',
    ).readAsString();
    Map<String, dynamic> trophyJson = json.decode(trophyJsonStr);
    for (var i in trophyJson['trophies']) {
      if ((i['name'].toLowerCase().contains(searchtext.toLowerCase()) ||
          i['description'].toLowerCase().contains(searchtext.toLowerCase()) ||
          i['color'].toString().contains(searchtext) ||
          i['id'].toString().contains(searchtext))) {
        if (searchtype == 'required' &&
            !(i as Map<String, dynamic>).containsKey('required')) {
          continue;
        }
        collectibles.add(returnWidget(data: i, type: '称号'));
      }
    }
  } else if (searchtype == 'trophy' && isSonginfo == true) {
    String trophyJsonStr = await File(
      '${path.path}/trophies.json',
    ).readAsString();
    Map<String, dynamic> trophyJson = json.decode(trophyJsonStr);
    for (var i in trophyJson['trophies']) {
      // print(int.parse(searchtext));
      if (i['id'] == int.parse(searchtext)) {
        collectibles.add(returnWidget(data: i, type: '称号'));
      }
    }
  }

  //角色搜索
  if ((searchtype == 'character' ||
          searchtype == 'all' ||
          searchtype == 'required') &&
      isSonginfo == false) {
    String characterJsonStr = await File(
      '${path.path}/characters.json',
    ).readAsString();
    Map<String, dynamic> characterJson = json.decode(characterJsonStr);
    for (var i in characterJson['characters']) {
      if (i['name'].toLowerCase().contains(searchtext.toLowerCase()) ||
          i['id'].toString().contains(searchtext) ||
          i['description'].toLowerCase().contains(searchtext.toLowerCase())) {
        if (searchtype == 'required' &&
            !(i as Map<String, dynamic>).containsKey('required')) {
          continue;
        }
        collectibles.add(returnWidget(data: i, type: '角色'));
      }
    }
  } else if (searchtype == 'character' && isSonginfo == true) {
    String characterJsonStr = await File(
      '${path.path}/characters.json',
    ).readAsString();
    Map<String, dynamic> characterJson = json.decode(characterJsonStr);
    for (var i in characterJson['characters']) {
      if (i['id'] == int.parse(searchtext)) {
        collectibles.add(returnWidget(data: i, type: '角色'));
      }
    }
  }

  // print(collectibles);
  return collectibles;
}

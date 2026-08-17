import 'dart:developer';

import 'package:chusearchsong_flutter/function/fun.dart';
import 'package:chusearchsong_flutter/function/toolsfun/searchlobbypagefun.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class ShopInfo extends StatefulWidget {
  final Map<String, dynamic> shopinformation;
  final ScrollController scrollController;

  const ShopInfo({
    super.key,
    required this.shopinformation,
    required this.scrollController,
  });

  @override
  State<ShopInfo> createState() => _ShopInfoState();
}

class _ShopInfoState extends State<ShopInfo> {
  bool isShowComment = false;
  IconData showCommentIcon = Icons.arrow_drop_down;

  bool isShowGanme = false;
  IconData showGanmeIcon = Icons.arrow_drop_down;

  @override
  Widget build(BuildContext context) {
    final shopinformation = widget.shopinformation;

    //地址拼接
    List<String> regionList = [];
    for (var j in shopinformation['address']['region']) {
      regionList.add(j['name']['zh']);
    }

    //开店时间
    List<Widget> openingHoursList = [];
    for (var j in shopinformation['openingHours']) {
      int openhour = j[0]['hour'];
      int openminute = j[0]['minute'];
      int closehour = j[1]['hour'];
      int closeminute = j[1]['minute'];
      openingHoursList.add(
        Card(
          color: Theme.of(context).colorScheme.secondaryContainer,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 8,
              right: 8,
              top: 3,
              bottom: 3,
            ),
            child: Text(
              '$openhour 时 $openminute 分 - $closehour 时 $closeminute 分',
            ),
          ),
        ),
      );
    }

    //机台收录
    List<Widget> gameList = [];
    for (var j in shopinformation['games']) {
      gameList.add(
        Card(
          color: Theme.of(context).colorScheme.secondaryContainer,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 8,
              right: 8,
              top: 3,
              bottom: 3,
            ),
            child: InkWell(
              onTap: () => showModalBottomSheet(
                useSafeArea: true,
                context: context,
                builder: (context) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: EdgeInsetsGeometry.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '介绍',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text('${j['comment']}'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${j['name']}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '版本：${j['version']}',
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          '数量：${j['quantity']}',
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          '${j['cost']}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    //列表
    List<Widget> list = [
      Text(
        '#${shopinformation['id']}',
        style: const TextStyle(fontSize: 15, color: Colors.grey),
      ),
      Text(
        '${shopinformation['name']}',
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      InkWell(
        onTap: () => copytext(
          text:
              '${regionList.join('')}${shopinformation['address']['detailed']}',
          context: context,
        ),
        child: Text(
          '${regionList.join(' ')} ${shopinformation['address']['detailed']}',
          style: const TextStyle(fontSize: 15, color: Colors.grey),
        ),
      ),
      const Divider(),
      const Text(
        '营业时间：',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      Wrap(children: openingHoursList),

      InkWell(
        onTap: () {
          setState(() {
            isShowGanme = !isShowGanme;
            showGanmeIcon = isShowGanme
                ? Icons.arrow_drop_up
                : Icons.arrow_drop_down;
          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '收录机台',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Icon(showGanmeIcon),
              ],
            ),
            isShowGanme ? Column(children: gameList) : const SizedBox(),
          ],
        ),
      ),
      InkWell(
        onTap: () {
          setState(() {
            isShowComment = !isShowComment;
            showCommentIcon = isShowComment
                ? Icons.arrow_drop_up
                : Icons.arrow_drop_down;
          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '介绍',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Icon(showCommentIcon),
              ],
            ),
            if (isShowComment) Text('${shopinformation['comment']}'),
          ],
        ),
      ),
      Text.rich(
        TextSpan(
          text: '上传时间：\n',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          children: [
            TextSpan(
              text: "${DateTime.parse(shopinformation['createdAt']).toLocal()}",
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
      Text.rich(
        TextSpan(
          text: '最后更新时间：\n',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          children: [
            TextSpan(
              text: "${DateTime.parse(shopinformation['updatedAt']).toLocal()}",
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    ];

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => openmap(
          address:
              '${regionList.join('')}${shopinformation['address']['detailed']}',
          context: context,
        ),
        child: Icon(Icons.navigation),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: ListView(
          controller: widget.scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          children: list,
        ),
      ),
    );
  }
}

List<Widget> searchlobby({
  required Map<String, dynamic> shopinformation,
  required String text,
  required MapController mapController,
}) {
  List<Widget> list = [];
  Set<int> shopId = {};
  for (var i in shopinformation['shops']) {
    //店名搜索
    if (i['name'].contains(text)) {
      shopId.add(i['id']);
    }

    //地区搜索
    for (var j in i['address']['region']) {
      if (j['name']['zh'].contains(text)) {
        shopId.add(i['id']);
        break;
      }
    }

    //店铺id搜索
    if (i['id'].toString().contains(text)) {
      shopId.add(i['id']);
    }
  }
  //添加组件
  for (var shop in (shopinformation['shops'] as List)) {
    if (shopId.contains(shop['id'])) {
      //地址拼接
      List<String> regionList = [];
      for (var j in shop['address']['region']) {
        regionList.add(j['name']['zh']);
      }
      list.add(
        Card(
          child: Padding(
            padding: EdgeInsetsGeometry.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${shop['name']}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${regionList.join('')}${shop['address']['detailed']}',
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    mapController.move(
                      LatLng(
                        shop['location']['coordinates'][1],
                        shop['location']['coordinates'][0],
                      ),
                      16,
                    );
                  },
                  icon: Icon(Icons.navigation),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
  log(list.length.toString());
  return list;
}

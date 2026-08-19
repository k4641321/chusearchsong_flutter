import 'dart:developer';
import 'dart:ui';

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
                isScrollControlled: true,
                context: context,
                builder: (context) => Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            '介绍',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Flexible(
                            // 让文本区占剩余空间，而不是撑爆
                            child: SingleChildScrollView(
                              // 长文本可滚动
                              child: Text('${j['comment']}'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
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
  required List shopinformation,
  required String text,
  required MapController mapController,
  required List titleIdList,
}) {
  List<Widget> list = [];
  Set<int> shopId = {};

  //游戏类型筛选
  List result1 = [];
  if (titleIdList.isNotEmpty) {
    for (var i in shopinformation) {
      for (var j in i['games']) {
        if (titleIdList.contains(j['titleId'])) {
          result1.add(i);
          break;
        }
      }
    }
  }

  List result2 = shopinformation;
  if (result1.isNotEmpty) {
    result2 = result1;
  }
  for (var i in result2) {
    //店名搜索
    if (i['name'].contains(text)) {
      shopId.add(i['id']);
    }

    //地区搜索
    List address = [];
    for (var j in i['address']['region']) {
      address.add(j['name']['zh']);
    }
    if (address.join('').contains(text)) {
      shopId.add(i['id']);
    }

    //店铺id搜索
    if (i['id'].toString().contains(text)) {
      shopId.add(i['id']);
    }
  }

  //添加组件
  for (var shop in shopinformation) {
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
                        '#${shop['id']}',
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
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
  log('搜索结果：${list.length.toString()}');
  return list;
}

class FilterBody extends StatefulWidget {
  final Map<String, dynamic> gameList;
  final ValueChanged<Set<dynamic>> onChanged;
  final Set<dynamic> selectedKeys;

  const FilterBody({
    super.key,
    required this.gameList,
    required this.selectedKeys,
    required this.onChanged,
  });

  @override
  State<FilterBody> createState() => _FilterBodyState();
}

class _FilterBodyState extends State<FilterBody> {
  Set<dynamic> _selectedKeys = {};

  void init() {
    _selectedKeys = widget.selectedKeys;
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> list = [];
    for (var i in widget.gameList.keys) {
      list.add(
        FilterChip(
          label: Text('${widget.gameList[i]}'),
          selected: _selectedKeys.contains(int.parse(i)),
          onSelected: (bool selected) {
            setState(() {
              if (selected) {
                _selectedKeys.add(int.parse(i)); // 选中 → 添加 i
              } else {
                _selectedKeys.remove(int.parse(i)); // 取消 → 移除 i
              }
            });
            widget.onChanged(_selectedKeys); // 把最新集合传出去
          },
        ),
      );
    }
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '选择游戏类型',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          Wrap(runSpacing: 5, spacing: 10, children: list),
        ],
      ),
    );
  }
}

List<Marker> createMarkers({
  required List shopList,
  required List filterList,
  required BuildContext context,
}) {
  List<Marker> loadsList = [];
  // print(shopList);
  for (var i in shopList) {
    bool ismatch = filterList.isEmpty;
    if (!ismatch) {
      for (var j in i['games']) {
        if (filterList.contains(j['titleId'])) {
          ismatch = true;
          break;
        }
      }
    }
    if (!ismatch) continue;
    loadsList.add(
      Marker(
        width: 50,
        height: 50,
        point: LatLng(
          i['location']['coordinates'][1],
          i['location']['coordinates'][0],
        ),
        child: InkWell(
          onTap: () {
            showModalBottomSheet(
              isScrollControlled: true,
              useSafeArea: true,
              context: context,
              builder: (b) => DraggableScrollableSheet(
                initialChildSize: 0.5,
                minChildSize: 0.3,
                maxChildSize: 1.0,
                expand: false,
                builder: (context, scrollController) => ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(
                    dragDevices: {
                      PointerDeviceKind.touch,
                      PointerDeviceKind.mouse,
                      PointerDeviceKind.stylus,
                      PointerDeviceKind.trackpad,
                    },
                  ),
                  child: ShopInfo(
                    shopinformation: i,
                    scrollController: scrollController,
                  ),
                ),
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.all(8),
            alignment: Alignment.center,
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),

            child: Icon(
              Icons.videogame_asset_outlined,
              color: Colors.blue,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }
  // log(loadsList.length.toString());
  return loadsList;
}

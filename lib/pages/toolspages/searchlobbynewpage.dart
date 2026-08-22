import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:chusearchsong_flutter/function/request.dart';
import 'package:chusearchsong_flutter/function/toolsfun/searchlobbynewpagefun.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster_plus/flutter_map_marker_cluster_plus.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';

List decodeShopList(String raw) => jsonDecode(raw) as List;

Map<String, dynamic> decodeGameListJson(String raw) =>
    jsonDecode(raw) as Map<String, dynamic>;

class Searchlobbynewpage extends StatefulWidget {
  const Searchlobbynewpage({super.key});

  @override
  State<Searchlobbynewpage> createState() => _SearchlobbynewpageState();
}

class _SearchlobbynewpageState extends State<Searchlobbynewpage> {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();

  LatLng _current = LatLng(39.9062, 116.3913);
  List<Marker> showmarkersList = [];
  List<Marker> markersList = [];
  List shopList = [];
  List<Widget> searchresult = [];
  bool isSearch = false;
  LatLng userPosition = LatLng(39.9062, 116.3913);
  Map<String, dynamic> gameList = {};
  List selectGameIdlist = [];

  Future<void> init() async {
    try {
      List<Marker> loadsList = [];
      String loadsText = '获取地图数据';
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              Expanded(child: Text(loadsText)),
            ],
          ),
        ),
      );
      final path = await getApplicationSupportDirectory();
      if (!File('${path.path}/res/nearcadeshops.json').existsSync() ||
          !File('${path.path}/res/nearcadegames.json').existsSync()) {
        setState(() {
          loadsText = '本地缓存缺失，正在下载，并解析';
        });
        await saveNearcadeAllShop();
        shopList = await compute(
          decodeShopList,
          File('${path.path}/res/nearcadeshops.json').readAsStringSync(),
        );

        for (var i in shopList) {
          for (var j in i['games']) {
            gameList['${j['titleId']}'] = '${j['name']}';
          }
        }
        File(
          '${path.path}/res/nearcadegames.json',
        ).writeAsStringSync(jsonEncode(gameList));
        // print(gameList);
      } else {
        shopList = await compute(
          decodeShopList,
          File('${path.path}/res/nearcadeshops.json').readAsStringSync(),
        );
        gameList = await compute(
          decodeGameListJson,
          File('${path.path}/res/nearcadegames.json').readAsStringSync(),
        );
      }
      if (!mounted) return;
      markersList = createMarkers(
        shopList: shopList,
        filterList: selectGameIdlist,
        context: context,
      );
      loadsList = List.from(markersList);
      if (!mounted) return;
      setState(() {
        showmarkersList = loadsList;
      });
      await _locate();
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (e, strack) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('错误：$e\n$strack')));
      log('$e\n$strack');
    }
  }

  Future<void> _locate() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (!mounted) return;
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (!mounted) return;
      if (permission == LocationPermission.deniedForever) return;

      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      if (!mounted) return;

      _mapController.move(LatLng(pos.latitude, pos.longitude), 16);
      setState(() {
        _current = LatLng(pos.latitude, pos.longitude);
        List<Marker> loadsList = List.from(markersList);
        loadsList.add(
          Marker(
            point: LatLng(pos.latitude, pos.longitude),
            width: 80,
            height: 80,
            child: Icon(Icons.location_on, color: Colors.blue, size: 40),
          ),
        );
        showmarkersList = loadsList;
        // log(showmarkersList.length.toString());
      });
    } catch (e, strack) {
      log('$e\n$strack');
    }
  }

  void _searchlobby() {
    isSearch = true;
    if (_searchController.text == '' && selectGameIdlist.isEmpty) {
      List<Marker> loadsList = List.from(
        createMarkers(
          shopList: shopList,
          filterList: selectGameIdlist,
          context: context,
        ),
      );
      setState(() {
        searchresult = [];
        showmarkersList = loadsList;
      });
    } else {
      List<Marker> loadsList = List.from(
        createMarkers(
          shopList: shopList,
          filterList: selectGameIdlist,
          context: context,
        ),
      );
      setState(() {
        searchresult = searchlobby(
          shopinformation: shopList,
          text: _searchController.text,
          mapController: _mapController,
          titleIdList: selectGameIdlist,
        );
        showmarkersList = loadsList;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      init();
    });
  }

  @override
  void didChangeDependencies() {
    // _locate();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("机厅搜索(新)"),
        // actions: [IconButton(onPressed: init, icon: Icon(Icons.refresh))],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _current,
              // interactionOptions: const InteractionOptions(
              //   flags: InteractiveFlag.all & ~InteractiveFlag.scrollWheelZoom,
              // ),
              onMapEvent: (MapEvent event) {
                if (event is MapEventMoveStart) {
                  if (!isSearch) return;
                  setState(() {
                    isSearch = false;
                  });
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate:
                    // 'https://webrd04.is.autonavi.com/appmaptile?lang=zh_cn&size=1&scale=1&style=7&x={x}&y={y}&z={z}',
                    // 'http://online{s}.map.bdimg.com/onlinelabel/?qt=tile&x={x}&y={y}&z={z}',
                    'http://wprd04.is.autonavi.com/appmaptile?x={x}&y={y}&z={z}&lang=zh_cn&size=1&scl=1&style=7',
              ),
              RichAttributionWidget(
                attributions: [
                  LogoSourceAttribution(
                    Icon(Icons.location_on, color: Colors.black),
                    onTap: _locate,
                    height: 24,
                  ),
                ],
              ),
              MarkerClusterLayerWidget(
                options: MarkerClusterLayerOptions(
                  markers: showmarkersList,
                  size: Size(40, 40),
                  builder: (context, marker) => Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${marker.length}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: '输入关键字',
                        filled: true,
                        fillColor: Colors.white,
                        border: ShapedInputBorder(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusGeometry.all(
                              Radius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          isSearch = true;
                        });
                      },
                      onChanged: (value) {
                        _searchlobby();
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        useSafeArea: true,
                        context: context,
                        builder: (b) => DraggableScrollableSheet(
                          initialChildSize: 0.5,
                          minChildSize: 0.3,
                          maxChildSize: 1.0,
                          expand: false,
                          builder: (context, scrollController) =>
                              ScrollConfiguration(
                                behavior: ScrollConfiguration.of(context)
                                    .copyWith(
                                      dragDevices: {
                                        PointerDeviceKind.touch,
                                        PointerDeviceKind.mouse,
                                        PointerDeviceKind.stylus,
                                        PointerDeviceKind.trackpad,
                                      },
                                    ),
                                child: SingleChildScrollView(
                                  controller: scrollController,
                                  child: FilterBody(
                                    gameList: gameList,
                                    selectedKeys: selectGameIdlist.toSet(),
                                    onChanged: (selectedKeys) {
                                      log('$selectedKeys');
                                      selectGameIdlist = selectedKeys.toList();
                                    },
                                  ),
                                ),
                              ),
                        ),
                      );
                    },
                    icon: Icon(Icons.filter_alt),
                  ),
                  IconButton(
                    onPressed: () {
                      _searchlobby();
                    },
                    icon: Icon(Icons.search),
                  ),
                ],
              ),
              searchresult.isEmpty || isSearch == false
                  ? const SizedBox.shrink()
                  : SizedBox(
                      height: 300,
                      width: double.maxFinite,
                      child: ListView.builder(
                        itemBuilder: (context, index) => searchresult[index],
                        itemCount: searchresult.length,
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }
}

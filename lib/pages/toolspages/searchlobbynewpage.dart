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

Map<String, dynamic> decodeShopJson(String raw) =>
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
  List<Marker> markersList = [];
  Map<String, dynamic> shopList = {};
  List<Widget> searchresult = [];
  bool isSearch = false;

  Future<void> init() async {
    try {
      List<Marker> loadsList = [];
      String loadsText = '获取地图数据';
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
          content: Row(
            children: [CircularProgressIndicator(), Text(loadsText)],
          ),
        ),
      );
      final path = await getApplicationSupportDirectory();
      if (!File('${path.path}/res/nearcadeshops.json').existsSync()) {
        setState(() {
          loadsText = '本地缓存缺失，正在下载，并解析';
        });
        final String raw = await requestNearcadeAllShop();
        shopList = await compute(decodeShopJson, raw);
        File(
          '${path.path}/res/nearcadeshops.json',
        ).writeAsStringSync(jsonEncode(shopList));
      } else {
        shopList = shopList = await compute(
          decodeShopJson,
          File('${path.path}/res/nearcadeshops.json').readAsStringSync(),
        );
      }
      for (var i in shopList['shops']) {
        if (!mounted) return;
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
      if (!mounted) return;
      setState(() {
        markersList = loadsList;
      });
      Navigator.of(context).pop();
    } catch (e, strack) {
      log('$e\n$strack');
    }
  }

  Future<void> _locate(bool isNew) async {
    try {
      if (!isNew) {
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
        return;
      }
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
        markersList = loadsList;
      });
    } catch (e, strack) {
      log('$e\n$strack');
    }
  }

  void _searchlobby() {
    isSearch = true;
    if (_searchController.text == '') {
      setState(() {
        searchresult = [];
      });
    } else {
      setState(() {
        searchresult = searchlobby(
          shopinformation: shopList,
          text: _searchController.text,
          mapController: _mapController,
        );
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
    _locate(true);
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
                if (event is MapEventMoveEnd) {
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
                    onTap: () => _locate(false),
                    height: 24,
                  ),
                ],
              ),
              MarkerClusterLayerWidget(
                options: MarkerClusterLayerOptions(
                  markers: markersList,
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
                        filled: true, // ← 必须 true,否则 fillColor 不生效
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

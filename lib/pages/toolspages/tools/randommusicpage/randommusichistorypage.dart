import 'package:chusearchsong_flutter/function/commonfun.dart';
import 'package:chusearchsong_flutter/function/writeandreadfun.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Randommusichistorypage extends StatefulWidget {
  final Map<String, dynamic> songsData;
  const Randommusichistorypage({super.key, required this.songsData});

  @override
  State<Randommusichistorypage> createState() => _RandommusichistorypageState();
}

class _RandommusichistorypageState extends State<Randommusichistorypage> {
  List<Widget> item = [Text('加载中...')];

  Future<void> init() async {
    List<Widget> result = [];
    List history = await (await ReadData.create()).readRandomMusicHistory();
    for (var i in history) {
      List<Widget> picwidgets = [];
      for (var j in i['ids']) {
        for (var k in widget.songsData['songs']) {
          if (j == k['id']) {
            int songid = k['id'];
            if (((k['difficulties'] as List).last as Map).containsKey(
              'origin_id',
            )) {
              songid = ((k['difficulties'] as List).last as Map)['origin_id'];
            }
            picwidgets.add(
              InkWell(
                onTap: () => interSongInfo(
                  songbasedata: k,
                  context: context,
                  songsData: widget.songsData,
                ),
                child: Padding(
                  padding: EdgeInsetsGeometry.all(5),
                  child: CachedNetworkImage(
                    height: 100,
                    width: 100,
                    imageUrl:
                        'https://assets2.lxns.net/chunithm/jacket/$songid.png',
                  ),
                ),
              ),
            );
          }
        }
      }
      result.add(
        Padding(
          padding: EdgeInsetsGeometry.all(8),
          child: Card(
            child: Padding(
              padding: EdgeInsetsGeometry.all(8),
              child: Column(
                children: [
                  Text(
                    '时间：${i['time']}',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      // fontSize: 19,
                      color: Colors.grey,
                    ),
                  ),
                  Wrap(alignment: WrapAlignment.center, children: picwidgets),
                ],
              ),
            ),
          ),
        ),
      );
    }
    setState(() {
      item = result;
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('历史抽取')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) => item[index],
              itemCount: item.length,
            ),
          ),
        ],
      ),
    );
  }
}

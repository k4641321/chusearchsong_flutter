import 'package:chusearchsong_flutter/function/fun.dart';
import 'package:chusearchsong_flutter/pages/toolspages/information/linkedversepage/linklevelpage.dart';
import 'package:flutter/material.dart';

class Gateinfopage extends StatefulWidget {
  final Map<String, dynamic> gatedata;
  final Map<String, dynamic> songsData;
  final List linklevel;

  const Gateinfopage({
    super.key,
    required this.gatedata,
    required this.songsData,
    required this.linklevel,
  });

  @override
  State<Gateinfopage> createState() => _GateinfopageState();
}

class _GateinfopageState extends State<Gateinfopage> {
  Widget gatesongwidget = SizedBox.shrink();
  List<Widget> requiredSongs = [];
  String diff = '';

  Future<void> init() async {
    if ((widget.gatedata['required_songs'] as List).isNotEmpty) {
      for (var i in widget.gatedata['required_songs']) {
        for (var j in widget.songsData['songs']) {
          if (i == j['id']) {
            String versionname = '';
            for (var k in widget.songsData['versions']) {
              if (j['version'] == k['version']) {
                versionname = k['title'];
                break;
              }
            }
            requiredSongs.add(
              returnSongCard(
                songbasedata: j,
                versionname: versionname,
                context: context,
              ),
            );
          }
        }
      }
    } else {
      requiredSongs.add(Text('无要求曲目', textAlign: TextAlign.center));
    }

    // diff = widget.gatedata['link_level'][widget.gatedata];

    for (var i in widget.songsData['songs']) {
      if (widget.gatedata['gate_song'] == i['id']) {
        String versionname = '';
        for (var j in widget.songsData['versions']) {
          if (i['version'] == j['version']) {
            versionname = j['title'];
            break;
          }
        }
        setState(() {
          gatesongwidget = returnSongCard(
            songbasedata: i,
            versionname: versionname,
            context: context,
          );
        });
        break;
      } else {
        setState(() {
          gatesongwidget = Text('暂无数据');
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('门详情'),
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline_rounded),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    Linklevelpage(linklevels: widget.linklevel),
              ),
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Center(
              child: Image.asset(
                'res/linkedverse/${widget.gatedata['id']}.webp',
                width: 125,
                height: 125,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsetsGeometry.all(10),
              child: Card(
                child: Padding(
                  padding: EdgeInsetsGeometry.all(8),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            '基本信息',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      InkWell(
                        child: Row(
                          children: [
                            Icon(
                              Icons.label,
                              size: 18,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            SizedBox(width: 4),
                            SizedBox(
                              width: 80,
                              child: const Text(
                                '名称：',
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                            SizedBox(width: 50),
                            Expanded(
                              child: Text(
                                '${widget.gatedata['name']}',
                                style: const TextStyle(fontSize: 15),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(),
                      InkWell(
                        child: Row(
                          children: [
                            Icon(
                              Icons.map,
                              size: 18,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            SizedBox(width: 4),
                            SizedBox(
                              width: 80,
                              child: const Text(
                                '需跑地图：',
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                            SizedBox(width: 50),
                            Expanded(
                              child: Text(
                                '${widget.gatedata['map']}',
                                style: const TextStyle(fontSize: 15),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(),
                      InkWell(
                        child: Row(
                          children: [
                            Icon(
                              Icons.trending_up,
                              size: 18,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            SizedBox(width: 4),
                            SizedBox(
                              width: 80,
                              child: const Text(
                                '当前解禁难度',
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                            SizedBox(width: 50),
                            Expanded(
                              child: Text(
                                '${widget.linklevel[widget.gatedata['link_level']]['level']}',
                                style: const TextStyle(fontSize: 15),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(),
                      InkWell(
                        onLongPress: () => copytext(
                          text: widget.gatedata['original_description'],
                          context: context,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.description,
                              size: 18,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            SizedBox(width: 4),
                            SizedBox(
                              width: 80,
                              child: const Text(
                                '原文描述：',
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                            SizedBox(width: 50),
                            Expanded(
                              child: Text(
                                '${widget.gatedata['original_description']}',
                                style: const TextStyle(fontSize: 15),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(),
                      InkWell(
                        onLongPress: () => copytext(
                          text: widget.gatedata['description'],
                          context: context,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.translate,
                              size: 18,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            SizedBox(width: 4),
                            SizedBox(
                              width: 80,
                              child: const Text(
                                '机器翻译：',
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                            SizedBox(width: 50),
                            Expanded(
                              child: Text(
                                '${widget.gatedata['description']}',
                                style: const TextStyle(fontSize: 15),
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
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsetsGeometry.all(10),
              child: Card(
                child: Padding(
                  padding: EdgeInsetsGeometry.all(8),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            '门曲',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                      gatesongwidget,
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsetsGeometry.all(10),
              child: Card(
                child: Padding(
                  padding: EdgeInsetsGeometry.all(8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Text(
                            '所需曲目',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) => requiredSongs[index],
                        itemCount: requiredSongs.length,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

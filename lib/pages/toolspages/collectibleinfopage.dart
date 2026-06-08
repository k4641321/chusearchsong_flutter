import 'package:flutter/material.dart';
import '../../tools/fun.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import '../../tools/texttranslate.dart';

class CollectibleInfoPage extends StatefulWidget {
  const CollectibleInfoPage({
    super.key,
    required this.data,
    required this.type,
  });
  final Map<String, dynamic> data;
  final String type;

  @override
  State<CollectibleInfoPage> createState() => _CollectibleInfoPageState();
}

class _CollectibleInfoPageState extends State<CollectibleInfoPage> {
  final ScrollController _controller = ScrollController();
  List<Widget> result = [];
  String translate = '';
  Future<void> otherinfo({required String type}) async {
    if (type == 'trophy') {
      result.add(
        Text(
          '颜色: ${widget.data['color']}',
          style: const TextStyle(fontSize: 20),
        ),
      );

      if (widget.data.keys.contains('required')) {
        List<String> difficulties = [];
        Map<String, dynamic> requiredList = widget.data['required'][0];

        if (requiredList['difficulties'].isEmpty) {
          difficulties.add('任意难度');
        } else {
          for (var i in requiredList['difficulties']) {
            // print('$i, $i.runtimeType');
            switch (i) {
              case 0:
                difficulties.add('BASIC');
              case 1:
                difficulties.add('ADVANCED');
              case 2:
                difficulties.add('EXPERT');
              case 3:
                difficulties.add('MASTER');
            }
          }
        }
        result.add(
          Text(
            '需求: \n难度: ${difficulties.toString()}',
            style: const TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
        );

        if (requiredList.keys.contains('full_chain')) {
          String fullchain;
          switch (requiredList['full_chain']) {
            case 'fullchain':
              fullchain = '铂Full Chain';
            case 'fullchain2':
              fullchain = '金Full Chain';
            default:
              fullchain = '无';
          }
          result.add(
            Text(
              'Full Chain要求: $fullchain',
              style: const TextStyle(fontSize: 20),
            ),
          );
        }
        if (requiredList.keys.contains('full_combo')) {
          String fullcombo;
          switch (requiredList['full_combo']) {
            case 'alljusticecritical':
              fullcombo = 'AJC';
            case 'alljustice':
              fullcombo = 'ALL JUSTICE';
            case 'fullcombo':
              fullcombo = 'FULL COMBO';
            default:
              fullcombo = '无';
          }
          result.add(
            Text(
              'Full Combo要求: $fullcombo',
              style: const TextStyle(fontSize: 20),
            ),
          );
        }

        if (requiredList.keys.contains('rank')) {
          String rank;
          rank = requiredList['rank'];
          result.add(
            Text('rank要求: $rank', style: const TextStyle(fontSize: 20)),
          );
        }

        if (requiredList.keys.contains('songs')) {
          List<dynamic> songs = requiredList['songs'];
          //加载曲目
          final dataPath = await getApplicationSupportDirectory();
          String jsonString = await File(
            '${dataPath.path}/res/songs.json',
          ).readAsString();
          Map<String, dynamic> songData = json.decode(jsonString);
          result.add(Text('关联曲目: ', style: const TextStyle(fontSize: 20)));
          //获取曲目信息
          for (var songItem in songs) {
            Map<String, dynamic> song = {};
            for (var j in songData['songs']) {
              if (j['id'] == songItem['id']) {
                song = j;
                break;
              }
            }
            //获取版本名
            String versionname = '';
            for (var j in songData['versions']) {
              if (j['version'] == song['version']) {
                versionname = j['title'];
              }
            }

            result.add(
              InkWell(
                key: ValueKey(songItem['id']),
                onTap: () async {
                  interSongInfo(
                    i: song,
                    context: context,
                    versionname: versionname,
                  );
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                  child: Padding(
                    padding: EdgeInsetsGeometry.all(10.0),
                    child: Text(
                      '${song['id']} - ${song['title']}      ${song['genre']} - $versionname',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            );
          }
        }
      }
    }
    setState(() {
      otherinfowidget = result;
    });
  }

  List<Widget> otherinfowidget = [];

  @override
  void initState() {
    super.initState();
    otherinfo(type: widget.type);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.data['name']} - 收藏品信息'),
        // backgroundColor: const Color.fromARGB(255, 255, 229, 84),
      ),
      body: Center(
        child: Scrollbar(
          controller: _controller,
          child: SingleChildScrollView(
            controller: _controller,
            child: Column(
              children: [
                Image.network(
                  'https://assets2.lxns.net/chunithm/${widget.type}/${widget.data['id']}.png',
                  errorBuilder: (context, error, stackTrace) {
                    return Text(
                      '图片加载失败',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    );
                  },
                ),
                Text(
                  '落雪id: ${widget.data['id']}',
                  style: const TextStyle(fontSize: 20),
                ),
                InkWell(
                  onLongPress: () =>
                      copytext(text: widget.data['name'], context: context),
                  child: Text(
                    '名称: ${widget.data['name']}',
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                InkWell(
                  onLongPress: () => copytext(
                    text: widget.data['description'],
                    context: context,
                  ),
                  child: Text(
                    '描述: ${widget.data['description']}',
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                const Divider(),
                Column(children: otherinfowidget),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () async {
                        try {
                          String result = await translateText(
                            sourceText: widget.data['description'],
                            context: context,
                          );
                          setState(() {
                            translate = result;
                          });
                        } catch (e) {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text('翻译失败: $e')));
                        }
                      },
                      child: Text(
                        '翻译描述',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        try {
                          String result = await translateText(
                            sourceText: widget.data['name'],
                            context: context,
                          );
                          setState(() {
                            translate = result;
                          });
                        } catch (e) {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text('翻译失败: $e')));
                        }
                      },
                      child: Text(
                        '翻译标题',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onLongPress: () =>
                      copytext(text: translate, context: context),
                  child: Text(translate, style: TextStyle(fontSize: 20)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

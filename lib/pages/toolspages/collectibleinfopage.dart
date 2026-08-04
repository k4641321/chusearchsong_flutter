import 'dart:developer';

import 'package:flutter/material.dart';
import '../../function/fun.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import '../../function/texttranslate.dart';
import '../../function/toolsfun/playerinfopagefun.dart';
import '../../function/request.dart';

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
  Map<String, dynamic> newdata = {};
  String charatext = '';
  Widget charatranwidget = SizedBox.shrink();
  //加载其余信息
  Future<void> otherinfo({required String type}) async {
    //返回英文难度列表，称号使用
    List returnEnglishDiff({
      required List difficulties,
      required bool isComplete,
      List<String>? requireddifficulties,
    }) {
      List result = [];
      if (isComplete == true) {
        for (var i in difficulties) {
          switch (i) {
            case 0:
              result.add('BASIC');
            case 1:
              result.add('ADVANCED');
            case 2:
              result.add('EXPERT');
            case 3:
              result.add('MASTER');
            case 4:
              difficulties.add('ULTIMATE');
            case 5:
              difficulties.add('Worlds\'End');
            default:
              result.add('未知');
          }
        }
      } else if (isComplete == false && requireddifficulties != null) {
        result = requireddifficulties;
        for (var i in difficulties) {
          switch (i) {
            case 0:
              result.remove('BASIC');
            case 1:
              result.remove('ADVANCED');
            case 2:
              result.remove('EXPERT');
            case 3:
              result.remove('MASTER');
            case 4:
              result.remove('ULTIMATE');
            case 5:
              result.remove('Worlds\'End');
            default:
              result = ['未知'];
          }
        }
      }
      return result;
    }

    newdata = widget.data;
    //检侧是不是称号
    if (type == 'trophy') {
      try {
        String trophyprogressstr = await requestTrendProgress(
          id: newdata['id'],
        );
        Map<String, dynamic> trophyprogressjson = json.decode(
          trophyprogressstr,
        );
        if (trophyprogressjson.keys.contains('data')) {
          newdata = trophyprogressjson['data'];
        }
      } catch (e, stackTrace) {
        newdata = widget.data;
        log('trophyprogressstr error: $e');
        log('trophyprogressstr stackTrace: $stackTrace');
      }
      result.add(
        Text(
          '颜色: ${newdata['color']}',
          style: const TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
      );

      //检测有没有要求
      if (newdata.keys.contains('required')) {
        List<String> difficulties = [];
        Map<String, dynamic> requiredList = newdata['required'][0];
        List<Widget> songList = [];
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
              case 4:
                difficulties.add('ULTIMATE');
              case 5:
                difficulties.add('Worlds\'End');
              default:
                difficulties.add('未知');
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
        //full_chain要求
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
              textAlign: TextAlign.center,
            ),
          );
        }
        //full_combo要求
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
              textAlign: TextAlign.center,
            ),
          );
        }

        //评级要求
        if (requiredList.keys.contains('rank')) {
          String rank;
          rank = requiredList['rank'];
          result.add(
            Text(
              'rank要求: $rank',
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
          );
        }

        //曲目要求
        if (requiredList.keys.contains('songs')) {
          List<dynamic> songs = requiredList['songs'];
          //加载曲目
          final dataPath = await getApplicationSupportDirectory();
          String jsonString = await File(
            '${dataPath.path}/res/songs.json',
          ).readAsString();
          Map<String, dynamic> songData = json.decode(jsonString);
          result.add(
            Text(
              '关联曲目: ',
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
          );
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

            if (songs.length > 4) {
              songList.add(
                InkWell(
                  // key: ValueKey(songItem['id']),
                  onTap: () async {
                    interSongInfo(
                      songbasedata: song,
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
            } else {
              result.add(
                InkWell(
                  // key: ValueKey(songItem['id']),
                  onTap: () async {
                    interSongInfo(
                      songbasedata: song,
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
          if (songList.isNotEmpty) {
            result.add(_buildSongListSection(songList));
          }
          result.add(const Divider());

          //最后的信息构建组件
          if (newdata.containsKey('required')) {
            List allsongrequiredlist = newdata['required'];
            List allsongrequired = [];
            int songcount = 0;
            for (var i in allsongrequiredlist) {
              if (i.containsKey('songs')) {
                allsongrequired = i['songs'];
                songcount = allsongrequired.length;
              }
              if (i.containsKey('completed')) {
                if (i['completed'] == true) {
                  result.add(
                    Text(
                      '总完成状态: 完成 $songcount/$songcount',
                      style: const TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  );
                } else if (i['completed'] == false) {
                  result.add(
                    Text(
                      '总完成状态: 未完成',
                      style: const TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
              }
            }
            List<Widget> uncompletedsongs = [];
            List<Widget> completedsongs = [];
            int completedsongscount = 0;
            if (allsongrequired.isNotEmpty) {
              for (var i in allsongrequired) {
                if (i['completed'] == true) {
                  completedsongscount++;
                  Map<String, dynamic> song = {};
                  for (var j in songData['songs']) {
                    if (j['id'] == i['id']) {
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
                  completedsongs.add(
                    InkWell(
                      // key: ValueKey(songItem['id']),
                      onTap: () async {
                        interSongInfo(
                          songbasedata: song,
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
                            '${song['id']} - ${song['title']}      ${song['genre']} - $versionname\n${returnEnglishDiff(difficulties: i['completed_difficulties'], isComplete: true)}',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  );
                } else if (i['completed'] == false) {
                  Map<String, dynamic> song = {};
                  for (var j in songData['songs']) {
                    if (j['id'] == i['id']) {
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
                  uncompletedsongs.add(
                    InkWell(
                      // key: ValueKey(songItem['id']),
                      onTap: () async {
                        interSongInfo(
                          songbasedata: song,
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
                            '${song['id']} - ${song['title']}      ${song['genre']} - $versionname\n${returnEnglishDiff(difficulties: i['completed_difficulties'], isComplete: false, requireddifficulties: difficulties)}',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  );
                }
              }

              if (completedsongs.length > 4) {
                result.add(
                  Text(
                    '已完成歌曲曲目 $completedsongscount/$songcount',
                    style: const TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                );
                result.add(_buildSongListSection(completedsongs));
              } else if (completedsongs.isNotEmpty) {
                result.add(
                  Text(
                    '已完成歌曲曲目 $completedsongscount/$songcount',
                    style: const TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                );
                for (var i in completedsongs) {
                  result.add(i);
                }
              }

              if (uncompletedsongs.length > 4) {
                result.add(
                  Text(
                    '未完成歌曲曲目 ${songcount - completedsongscount}/$songcount',
                    style: const TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                );
                result.add(_buildSongListSection(uncompletedsongs));
              } else if (uncompletedsongs.isNotEmpty) {
                result.add(
                  Text(
                    '未完成歌曲曲目 ${songcount - completedsongscount}/$songcount',
                    style: const TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                );
                for (var i in uncompletedsongs) {
                  result.add(i);
                }
              }
            }
          }
        }
      }
    } else if (type == 'character') {
      final path = await getApplicationSupportDirectory();
      List segacharadata = jsonDecode(
        File('${path.path}/res/segachara.json').readAsStringSync(),
      );
      for (var i in segacharadata) {
        if (i['name'] == widget.data['name']) {
          setState(() {
            charatranwidget = TextButton(
              onPressed: () async {
                String translate2 = await translateText(
                  sourceText: charatext,
                  context: context,
                );
                setState(() {
                  translate = translate2;
                });
              },
              child: Text(
                '翻译介绍',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            );
          });
          result.add(
            Text(
              '画师：${i['artist']}',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
          );
          result.add(
            Text(
              '所属地图：${i['ctg_name']}',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
          );
          result.add(
            Text(
              '日服上线时间：${i['release']}',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
          );
          result.add(
            Text(
              '介绍：${(i['text'] as List).join('\n')}',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
          );
          result.add(
            Image.network(
              'https://chunithm.sega.jp/storage/chara/${i['page']}/illustration/${i['id']}.png',
              errorBuilder: (context, error, stackTrace) => Text('立绘加载失败'),
            ),
            // InteractiveViewer(
            //   maxScale: 5.0,
            //   minScale: 0.1,
            //   child:
            // ),
          );

          charatext = (i['text'] as List).join('\n');
        }
      }
    }
    if (!mounted) return;
    setState(() {
      otherinfowidget = result;
    });
  }

  List<Widget> otherinfowidget = [];

  /// 构建带嵌套滚动转发的固定高度歌曲列表
  Widget _buildSongListSection(List<Widget> children) {
    final innerController = ScrollController();
    return NotificationListener<ScrollUpdateNotification>(
      onNotification: (notification) {
        final metrics = notification.metrics;
        final delta = notification.dragDetails?.delta.dy ?? 0;
        // 内层到顶且手指继续下滑 → 外层向上滚
        if (metrics.pixels <= metrics.minScrollExtent && delta > 0) {
          _controller.jumpTo(_controller.offset - delta);
        }
        // 内层到底且手指继续上滑 → 外层向下滚
        if (metrics.pixels >= metrics.maxScrollExtent && delta < 0) {
          _controller.jumpTo(_controller.offset - delta);
        }
        return false;
      },
      child: SizedBox(
        height: 250,
        child: ListView(
          controller: innerController,
          physics: const ClampingScrollPhysics(),
          children: children,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    otherinfo(type: widget.type);
  }

  @override
  void dispose() {
    _controller.dispose();
    if (!mounted) return;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${newdata['name']} - 收藏品信息'),
        // backgroundColor: const Color.fromARGB(255, 255, 229, 84),
      ),
      body: CustomScrollView(
        controller: _controller,
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.network(
                  'https://assets2.lxns.net/chunithm/${widget.type}/${newdata['id']}.png',
                  errorBuilder: (context, error, stackTrace) {
                    if (widget.type == 'trophy') {
                      return InkWell(
                        child: Container(
                          color: returnTrophyBackgroundColor(newdata['color']),
                          padding: EdgeInsets.all(8),
                          child: Text(
                            newdata['name'],
                            style: TextStyle(
                              shadows: [
                                Shadow(
                                  color: returnTrophyColor(newdata['color']),
                                ),
                              ],
                              color: returnTrophyColor(newdata['color']),
                              fontSize: 20,
                            ),
                          ),
                        ),
                      );
                    }
                    return Text(
                      '图片加载失败',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    );
                  },
                ),
                Text(
                  '落雪id: ${newdata['id']}',
                  style: const TextStyle(fontSize: 20),
                ),
                InkWell(
                  onLongPress: () =>
                      copytext(text: newdata['name'], context: context),
                  child: Text(
                    '名称: ${newdata['name']}',
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                InkWell(
                  onLongPress: () =>
                      copytext(text: newdata['description'], context: context),
                  child: Text(
                    '描述: ${newdata['description']}',
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () async {
                        try {
                          String result = await translateText(
                            sourceText: newdata['description'],
                            context: context,
                          );
                          if (!mounted) return;
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
                            sourceText: newdata['name'],
                            context: context,
                          );
                          if (!mounted) return;
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
                    charatranwidget,
                  ],
                ),
                InkWell(
                  onLongPress: () =>
                      copytext(text: translate, context: context),
                  child: Text(translate, style: TextStyle(fontSize: 20)),
                ),
                const Divider(),
              ],
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => otherinfowidget[index],
              childCount: otherinfowidget.length,
            ),
          ),
        ],
      ),
    );
  }
}

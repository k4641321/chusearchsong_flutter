import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:chusearchsong_flutter/function/fun.dart';
import 'package:chusearchsong_flutter/function/request.dart';
import 'package:chusearchsong_flutter/function/toolsfun/friendbattlepagefun.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class FriendBattlePage extends StatefulWidget {
  const FriendBattlePage({super.key});

  @override
  State<StatefulWidget> createState() => _FriendBattlePageState();
}

class _FriendBattlePageState extends State<FriendBattlePage> {
  int mychart = 0;
  int friendchart = 0;
  int commonchart = 0;

  int win = 0;
  int lose = 0;
  int draw = 0;

  double myRating = 0;
  double friendRating = 0;
  int friendcode = 0;
  int newfriendcode = 0;

  bool _isLoading = false;
  String _loadingText = '加载中...';
  int? levelindex;
  String? winningandlosingstatus;

  List myscore = [];
  List friendscore = [];
  Map<String, dynamic> songsdata = {};
  List<Widget> vsresultwidget = [];

  final TextEditingController friendcodeController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  Future<void> init() async {
    try {
      if (!mounted) return;
      setState(() {
        _isLoading = true;
      });
      if (!mounted) return;
      setState(() {
        _loadingText = '加载曲目...';
      });
      songsdata = jsonDecode(await loadSongsData());
      if (!mounted) return;
      setState(() {
        _loadingText = '上传玩家成绩...';
      });
      final uploadresult = jsonDecode(await uploadplayerscore());
      myscore = jsonDecode(
        await requestScore(token: await returnlxnstoken()),
      )['data'];
      if (uploadresult['Sucess'] == true) {
        if (!mounted) return;
        setState(() {
          _loadingText = '成功';
          _isLoading = false;
        });

        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('成功')));
      } else {
        if (!mounted) return;
        setState(() {
          _loadingText = '失败';
        });
        if (!mounted) return;
        await showDialog(
          context: context,
          builder: (b) =>
              AlertDialog(title: Text('错误'), content: Text('上传玩家成绩失败')),
        );
        _isLoading = false;
      }
    } catch (e, strack) {
      log("$e\n$strack");
      if (!mounted) return;
      await showDialog(
        context: context,
        builder: (b) => AlertDialog(
          title: Text('错误'),
          content: Text('请将错误截图给开发者\n$e\n$strack'),
        ),
      );
      _isLoading = false;
    }
  }

  Future<void> readAgreement() async {
    Map<String, dynamic> config = await loadConfig();
    if (!config.containsKey('readfriendbattleagreement') ||
        config['readfriendbattleagreement'] == false) {
      if (!mounted) return;
      showDialog(
        context: (context),
        builder: (b) => AlertDialog(
          title: Text('提示'),
          content: Text(
            '由于落雪开发者无法获取玩家完整的所有成绩，您的数据将被上传到作者的数据库，使用双方都必须已经将成绩上传到作者的数据库，否则无法进行比较\n\n点击确定同意使用，点击取消退出友人对战',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(b);
                Navigator.pop(context);
              },
              child: Text('取消'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(b);
                setState(() {
                  config['readfriendbattleagreement'] = true;
                  saveConfig(config);
                });
              },
              child: Text('确定'),
            ),
          ],
        ),
      );
    } else if (config['readfriendbattleagreement'] == true) {
      init();
    }
  }

  void vs() async {
    try {
      if (friendcodeController.text == '') {
        return;
      }
      newfriendcode = int.parse(friendcodeController.text);
      if (friendcode != newfriendcode) {
        final path = await getApplicationSupportDirectory();
        if (!mounted) return;
        setState(() {
          _isLoading = true;
          _loadingText = '请求好友数据...';
        });
        friendscore =
            jsonDecode(await finduploadallscore(newfriendcode))['allscore'] ??
            (throw Exception('没有找到该玩家的数据'));
        if (!mounted) return;
        setState(() {
          _loadingText = '请求我的数据...';
        });
        myscore = jsonDecode(
          File('${path.path}/res/allscore.json').readAsStringSync(),
        )['data'];
        if (!mounted) return;
        setState(() {
          _loadingText = '请求好友信息...';
        });
        friendRating =
            jsonDecode(
              await requestotherPlayerInfo(newfriendcode),
            )['data']['rating'] ??
            (throw Exception('没有找到该玩家的数据'));
        if (!mounted) return;
        setState(() {
          _loadingText = '请求我的信息...';
        });
        myRating = jsonDecode(
          File('${path.path}/res/playerinfo.json').readAsStringSync(),
        )['data']['rating'];
        friendcode = newfriendcode;
      }
      if (!mounted) return;
      setState(() {
        _loadingText = '比较...';
      });
      Map<String, dynamic> briefvs = vsresult(
        myscore: myscore,
        friendscore: friendscore,
      );
      if (!mounted) return;
      setState(() {
        win = briefvs['win'];
        lose = briefvs['lose'];
        draw = briefvs['draw'];
        mychart = briefvs['mychart'];
        friendchart = briefvs['friendchart'];
        commonchart = briefvs['commonchart'];
        vsresultwidget = returnvsresultwidget(
          commonchart: briefvs['commontsong'],
          songsdata: songsdata,
          context: context,
          winningandlosingstatus: winningandlosingstatus,
          levelindex: levelindex,
        );
        _isLoading = false;
      });
    } catch (e, strack) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      log("$e\n$strack");
      if (!mounted) return;
      await showDialog(
        context: context,
        builder: (b) => AlertDialog(
          title: Text('错误'),
          content: Text('请将错误截图给开发者\n$e\n$strack'),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    readAgreement();
  }

  @override
  void dispose() {
    if (!mounted) return;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        child: Icon(Icons.arrow_upward),
        onPressed: () {
          _scrollController.jumpTo(0);
        },
      ),
      appBar: AppBar(title: const Text("友人对战")),
      body: Scrollbar(
        controller: _scrollController,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: friendcodeController,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      decoration: InputDecoration(hint: Text('输入对方好友码')),
                    ),
                  ),
                  TextButton(onPressed: () => vs(), child: Text('开始对比')),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: EdgeInsetsGeometry.all(8),
                  child: Column(
                    children: [
                      Text('结果', style: TextStyle(fontSize: 25)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text.rich(
                            TextSpan(
                              text: '$mychart\n',
                              children: [
                                TextSpan(
                                  text: '我的谱面',
                                  style: TextStyle(fontSize: 13),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 25),
                          ),

                          Text.rich(
                            TextSpan(
                              text: '$commonchart\n',
                              children: [
                                TextSpan(
                                  text: '共同谱面',
                                  style: TextStyle(fontSize: 13),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 25),
                          ),
                          Text.rich(
                            TextSpan(
                              text: '$friendchart\n',
                              children: [
                                TextSpan(
                                  text: '好友谱面',
                                  style: TextStyle(fontSize: 13),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 25),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () {
                              winningandlosingstatus = 'win';
                              vs();
                            },
                            child: Card(
                              color: const Color.fromARGB(255, 88, 216, 65),
                              child: Padding(
                                padding: EdgeInsetsGeometry.only(
                                  top: 10,
                                  bottom: 10,
                                  right: 25,
                                  left: 25,
                                ),
                                child: Text.rich(
                                  TextSpan(
                                    text: '$win\n',
                                    children: [
                                      TextSpan(
                                        text: '胜',
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              winningandlosingstatus = 'draw';
                              vs();
                            },
                            child: Card(
                              color: const Color.fromARGB(255, 244, 196, 64),
                              child: Padding(
                                padding: EdgeInsetsGeometry.only(
                                  top: 10,
                                  bottom: 10,
                                  right: 25,
                                  left: 25,
                                ),
                                child: Text.rich(
                                  TextSpan(
                                    text: '$draw\n',
                                    children: [
                                      TextSpan(
                                        text: '平',
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              winningandlosingstatus = 'lose';
                              vs();
                            },
                            child: Card(
                              color: const Color.fromARGB(255, 255, 68, 68),
                              child: Padding(
                                padding: EdgeInsetsGeometry.only(
                                  top: 10,
                                  bottom: 10,
                                  right: 25,
                                  left: 25,
                                ),
                                child: Text.rich(
                                  TextSpan(
                                    text: '$lose\n',
                                    children: [
                                      TextSpan(
                                        text: '输',
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            winningandlosingstatus = null;
                            vs();
                          });
                        },
                        child: Text('Rating: $myRating - $friendRating'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        levelindex = null;
                        vs();
                      },
                      style: ButtonStyle(),
                      child: Text(
                        '全部',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        levelindex = 0;
                        vs();
                      },
                      style: ButtonStyle(),
                      child: Text('BAS', style: TextStyle(color: Colors.green)),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        levelindex = 1;
                        vs();
                      },
                      style: ButtonStyle(),
                      child: Text(
                        'ADV',
                        style: TextStyle(color: Colors.orange),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        levelindex = 2;
                        vs();
                      },
                      style: ButtonStyle(),
                      child: Text('EXP', style: TextStyle(color: Colors.red)),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        levelindex = 3;
                        vs();
                      },
                      style: ButtonStyle(),
                      child: Text(
                        'MAS',
                        style: TextStyle(color: Colors.purple),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        levelindex = 4;
                        vs();
                      },
                      style: ButtonStyle(),
                      child: Text(
                        'ULT',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        levelindex = 5;
                        vs();
                      },
                      style: ButtonStyle(),
                      child: Text('WL', style: TextStyle(color: Colors.grey)),
                    ),
                  ),
                ],
              ),
            ),
            SliverList.builder(
              itemBuilder: (context, index) => vsresultwidget[index],
              itemCount: vsresultwidget.length,
            ),
          ],
        ),
      ),
      bottomNavigationBar: _isLoading
          ? SizedBox(
              height: 50,
              child: Column(
                children: [const LinearProgressIndicator(), Text(_loadingText)],
              ),
            )
          : null,
    );
  }
}

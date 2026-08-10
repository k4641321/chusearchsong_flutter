import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:chusearchsong_flutter/function/toolsfun/viewallgradespagefun.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class Viewallgradespage extends StatefulWidget {
  const Viewallgradespage({super.key});

  @override
  State<Viewallgradespage> createState() => _ViewallgradespageState();
}

class _ViewallgradespageState extends State<Viewallgradespage> {
  List allscore = [];
  Map<String, dynamic> songsdata = {};
  int totalchart = 0;
  int ssspcount = 0;
  int ssscount = 0;
  int fccount = 0;
  int ajcount = 0;
  int ajccount = 0;
  int page = 0;

  //筛选
  String sortingmethod = '默认';
  int? versionfilter;
  String versionfiltername = '全部';
  double levelfilterup = 17;
  double levelfilterdown = 0;
  int levelindexfilter = -1;
  String levelindexfiltername = '全部';
  int scoreupfilter = 1010000;
  int scoredownfilter = 0;
  String fcfilter = 'all';

  List<List<Widget>> scorelist = [
    [CircularProgressIndicator()],
  ];
  final TextEditingController levelfilterupcontroller = TextEditingController();
  final TextEditingController levelfilterdowncontroller =
      TextEditingController();
  final TextEditingController scoreupfiltercontroller = TextEditingController();
  final TextEditingController scoredownfiltercontroller =
      TextEditingController();
  final TextEditingController pagecontroller = TextEditingController();
  final ScrollController scrollcontroller = ScrollController();

  void init() {
    Map<String, dynamic> result = returnScoreData(allscore);
    setState(() {
      totalchart = result['totalchart'];
      ssspcount = result['sssp'];
      ssscount = result['sss'];
      fccount = result['fc'];
      ajcount = result['aj'];
      ajccount = result['ajc'];
    });
    List<List<Widget>> resultlist = returnScoreList(
      allscoredata: allscore,
      songsdata: songsdata,
      context: context,
      sortingmethod: sortingmethod,
      scoredownfilter: scoredownfilter,
      scoreupfilter: scoreupfilter,
      levelfilterdown: levelfilterdown,
      levelfilterup: levelfilterup,
      levelindexfilter: levelindexfilter,
      versionfilter: versionfilter,
      fcfilter: fcfilter,
    );
    setState(() {
      scorelist = resultlist;
      pagecontroller.text = (page + 1).toString();
    });
  }

  Future<void> loadallscore() async {
    try {
      final path = await getApplicationSupportDirectory();
      allscore = jsonDecode(
        File('${path.path}/res/allscore.json').readAsStringSync(),
      )['data'];
      songsdata = jsonDecode(
        File('${path.path}/res/songs.json').readAsStringSync(),
      );
      init();
    } catch (e, strack) {
      log('$e\n$strack');
      setState(() {
        scorelist = [
          [Text('错误，加载成绩失败，请检查是否获取过成绩\n$e\n$strack')],
        ];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadallscore();
  }

  Widget _levelBtn(String label, double down, double up) {
    return Expanded(
      child: TextButton(
        onPressed: () {
          setState(() {
            levelfilterdown = down;
            levelfilterup = up;
          });
          Navigator.of(context).pop();
        },
        child: Text(label),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('所有成绩查看')),
      body: Scrollbar(
        controller: scrollcontroller,
        child: CustomScrollView(
          controller: scrollcontroller,
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Card(
                          child: Padding(
                            padding: EdgeInsetsGeometry.only(
                              left: 15,
                              right: 15,
                              top: 8,
                              bottom: 8,
                            ),
                            child: Column(
                              children: [
                                Text('总谱面数'),
                                Text(totalchart.toString()),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Card(
                          child: Padding(
                            padding: EdgeInsetsGeometry.only(
                              left: 15,
                              right: 15,
                              top: 8,
                              bottom: 8,
                            ),
                            child: Column(
                              children: [
                                Text('SSS+'),
                                Text(ssspcount.toString()),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Card(
                          child: Padding(
                            padding: EdgeInsetsGeometry.only(
                              left: 15,
                              right: 15,
                              top: 8,
                              bottom: 8,
                            ),
                            child: Column(
                              children: [
                                Text('SSS'),
                                Text(ssscount.toString()),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Card(
                          child: Padding(
                            padding: EdgeInsetsGeometry.only(
                              left: 15,
                              right: 15,
                              top: 8,
                              bottom: 8,
                            ),
                            child: Column(
                              children: [Text('FC'), Text(fccount.toString())],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Card(
                          child: Padding(
                            padding: EdgeInsetsGeometry.only(
                              left: 15,
                              right: 15,
                              top: 8,
                              bottom: 8,
                            ),
                            child: Column(
                              children: [Text('AJ'), Text(ajcount.toString())],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Card(
                          child: Padding(
                            padding: EdgeInsetsGeometry.only(
                              left: 15,
                              right: 15,
                              top: 8,
                              bottom: 8,
                            ),
                            child: Column(
                              children: [
                                Text('AJC'),
                                Text(ajccount.toString()),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => showDialog(
                            context: context,
                            builder: (b) => AlertDialog(
                              title: Text('选择排序方式'),
                              content: SizedBox(
                                // height: 300,
                                child: SizedBox(
                                  width: double.maxFinite,
                                  child: ListView(
                                    shrinkWrap: true,
                                    children: [
                                      ListTile(
                                        title: Text('Rating'),
                                        onTap: () {
                                          setState(() {
                                            sortingmethod = 'Rating';
                                          });
                                          Navigator.pop(b);
                                        },
                                      ),
                                      ListTile(
                                        title: Text('定数'),
                                        onTap: () {
                                          setState(() {
                                            sortingmethod = '定数';
                                          });
                                          Navigator.pop(b);
                                        },
                                      ),
                                      ListTile(
                                        title: Text('分数'),
                                        onTap: () {
                                          setState(() {
                                            sortingmethod = '分数';
                                          });
                                          Navigator.pop(b);
                                        },
                                      ),
                                      ListTile(
                                        title: Text('超越之力'),
                                        onTap: () {
                                          setState(() {
                                            sortingmethod = '超越之力';
                                          });
                                          Navigator.pop(b);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          child: Card(
                            child: Padding(
                              padding: EdgeInsetsGeometry.all(8),
                              child: Column(
                                children: [
                                  Text('排序方式'),
                                  Text(
                                    sortingmethod,
                                    style: TextStyle(fontSize: 10),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () => showDialog(
                            context: context,
                            builder: (b) {
                              List<Widget> versionlist = [];
                              for (var i in songsdata['versions']) {
                                versionlist.add(
                                  ListTile(
                                    title: Text(i['title']),
                                    onTap: () {
                                      setState(() {
                                        versionfilter = i['version'];
                                        if (i['title'] != 'CHUNITHM') {
                                          versionfiltername =
                                              (i['title'] as String).replaceAll(
                                                'CHUNITHM',
                                                '',
                                              );
                                        } else {
                                          versionfiltername = i['title'];
                                        }
                                      });
                                      Navigator.pop(b);
                                    },
                                  ),
                                );
                              }
                              versionlist.insert(
                                0,
                                ListTile(
                                  title: Text('全部'),
                                  onTap: () {
                                    setState(() {
                                      versionfilter = null;
                                      versionfiltername = '全部';
                                    });
                                    Navigator.pop(b);
                                  },
                                ),
                              );
                              return AlertDialog(
                                title: Text('选择版本'),
                                content: SizedBox(
                                  width: double.maxFinite,
                                  child: ListView(
                                    shrinkWrap: true,
                                    children: versionlist,
                                  ),
                                ),
                              );
                            },
                          ),
                          child: Card(
                            child: Padding(
                              padding: EdgeInsetsGeometry.all(8),
                              child: Column(
                                children: [
                                  Text('版本筛选'),
                                  Text(
                                    versionfiltername,
                                    maxLines: 1,
                                    style: TextStyle(fontSize: 10),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () => showDialog(
                            context: context,
                            builder: (b) {
                              return AlertDialog(
                                title: Text('选择难度区间'),
                                content: SizedBox(
                                  width: double.maxFinite,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: TextField(
                                              inputFormatters: [
                                                FilteringTextInputFormatter.allow(
                                                  RegExp(r'^\d+\.?\d{0,}'),
                                                ),
                                              ],
                                              controller:
                                                  levelfilterdowncontroller,
                                              decoration: InputDecoration(
                                                hintText: '难度下限',
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsetsGeometry.only(
                                              left: 20,
                                              right: 20,
                                            ),
                                            child: Text('~'),
                                          ),
                                          Expanded(
                                            child: TextField(
                                              inputFormatters: [
                                                FilteringTextInputFormatter.allow(
                                                  RegExp(r'^\d+\.?\d{0,}'),
                                                ),
                                              ],
                                              controller:
                                                  levelfilterupcontroller,
                                              decoration: InputDecoration(
                                                hintText: '难度上限',
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Divider(),
                                      ListView(
                                        shrinkWrap: true,
                                        children: [
                                          Row(
                                            children: [
                                              _levelBtn('0', 0, 0),
                                              _levelBtn('1', 1, 1.9),
                                              _levelBtn('2', 2, 2.9),
                                              _levelBtn('3', 3, 3.9),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              _levelBtn('4', 4, 4.9),
                                              _levelBtn('5', 5, 5.9),
                                              _levelBtn('6', 6, 6.9),
                                              _levelBtn('7', 7, 7.4),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              _levelBtn('7+', 7.5, 7.9),
                                              _levelBtn('8', 8, 8.4),
                                              _levelBtn('8+', 8.5, 8.9),
                                              _levelBtn('9', 9, 9.4),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              _levelBtn('9+', 9.5, 9.9),
                                              _levelBtn('10', 10, 10.4),
                                              _levelBtn('10+', 10.5, 10.9),
                                              _levelBtn('11', 11, 11.4),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              _levelBtn('11+', 11.5, 11.9),
                                              _levelBtn('12', 12, 12.4),
                                              _levelBtn('12+', 12.5, 12.9),
                                              _levelBtn('13', 13, 13.4),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              _levelBtn('13+', 13.5, 13.9),
                                              _levelBtn('14', 14, 14.4),
                                              _levelBtn('14+', 14.5, 14.9),
                                              _levelBtn('15', 15, 15.4),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              _levelBtn('15+', 15.5, 15.9),
                                              _levelBtn('16', 16, 16.9),
                                              Expanded(
                                                child: TextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      levelfilterdown = 0;
                                                      levelfilterup = 17.0;
                                                    });
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('全部'),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(b),
                                    child: Text('取消'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        levelfilterdown =
                                            double.tryParse(
                                              levelfilterdowncontroller.text,
                                            ) ??
                                            0;
                                        levelfilterup =
                                            double.tryParse(
                                              levelfilterupcontroller.text,
                                            ) ??
                                            17;
                                        Navigator.pop(b);
                                      });
                                    },
                                    child: Text('确定'),
                                  ),
                                ],
                              );
                            },
                          ),
                          child: Card(
                            child: Padding(
                              padding: EdgeInsetsGeometry.all(8),
                              child: Column(
                                children: [
                                  Text('定数筛选'),
                                  Text(
                                    '$levelfilterdown - $levelfilterup',
                                    style: TextStyle(fontSize: 10),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => showDialog(
                            context: context,
                            builder: (b) {
                              return AlertDialog(
                                title: Text('难度筛选'),
                                content: SizedBox(
                                  width: double.maxFinite,
                                  child: ListView(
                                    shrinkWrap: true,
                                    children: [
                                      ListTile(
                                        title: Text('全部'),
                                        onTap: () {
                                          setState(() {
                                            levelindexfilter = -1;
                                            levelindexfiltername = '全部';
                                            Navigator.pop(b);
                                          });
                                        },
                                      ),
                                      ListTile(
                                        title: Text('Basic'),
                                        onTap: () {
                                          setState(() {
                                            levelindexfilter = 0;
                                            levelindexfiltername = 'Basic';
                                            Navigator.pop(b);
                                          });
                                        },
                                      ),
                                      ListTile(
                                        title: Text('Advanced'),
                                        onTap: () {
                                          setState(() {
                                            levelindexfilter = 1;
                                            levelindexfiltername = 'Advanced';
                                            Navigator.pop(b);
                                          });
                                        },
                                      ),
                                      ListTile(
                                        title: Text('Expert'),
                                        onTap: () {
                                          setState(() {
                                            levelindexfilter = 2;
                                            levelindexfiltername = 'Expert';
                                            Navigator.pop(b);
                                          });
                                        },
                                      ),
                                      ListTile(
                                        title: Text('Master'),
                                        onTap: () {
                                          setState(() {
                                            levelindexfilter = 3;
                                            levelindexfiltername = 'Master';
                                            Navigator.pop(b);
                                          });
                                        },
                                      ),
                                      ListTile(
                                        title: Text('ULtima'),
                                        onTap: () {
                                          setState(() {
                                            levelindexfilter = 4;
                                            levelindexfiltername = 'ULtima';
                                            Navigator.pop(b);
                                          });
                                        },
                                      ),
                                      ListTile(
                                        title: Text('World\'s End'),
                                        onTap: () {
                                          setState(() {
                                            levelindexfilter = 5;
                                            levelindexfiltername =
                                                'World\'s End';
                                            Navigator.pop(b);
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          child: Card(
                            child: Padding(
                              padding: EdgeInsetsGeometry.all(8),
                              child: Column(
                                children: [
                                  Text('难度筛选'),
                                  Text(
                                    levelindexfiltername,
                                    style: TextStyle(fontSize: 10),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () => showDialog(
                            context: context,
                            builder: (b) {
                              return AlertDialog(
                                title: Text('选择分数区间'),
                                content: SizedBox(
                                  width: double.maxFinite,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: TextField(
                                              controller:
                                                  scoredownfiltercontroller,
                                              decoration: InputDecoration(
                                                hintText: '最低分',
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsetsGeometry.only(
                                              left: 20,
                                              right: 20,
                                            ),
                                            child: Text('~'),
                                          ),
                                          Expanded(
                                            child: TextField(
                                              controller:
                                                  scoreupfiltercontroller,
                                              decoration: InputDecoration(
                                                hintText: '最高分',
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      ListView(
                                        shrinkWrap: true,
                                        children: [
                                          ListTile(
                                            title: Text('全部'),
                                            onTap: () => setState(() {
                                              scoredownfilter = 0;
                                              scoreupfilter = 1010000;
                                              Navigator.pop(b);
                                            }),
                                          ),
                                          ListTile(
                                            title: Text('SSS+'),
                                            onTap: () => setState(() {
                                              scoredownfilter = 1009000;
                                              scoreupfilter = 1010000;
                                              Navigator.pop(b);
                                            }),
                                          ),
                                          ListTile(
                                            title: Text('SSS'),
                                            onTap: () => setState(() {
                                              scoredownfilter = 1007500;
                                              scoreupfilter = 1008999;
                                              Navigator.pop(b);
                                            }),
                                          ),
                                          ListTile(
                                            title: Text('SS+'),
                                            onTap: () => setState(() {
                                              scoredownfilter = 1005000;
                                              scoreupfilter = 1007499;
                                              Navigator.pop(b);
                                            }),
                                          ),
                                          ListTile(
                                            title: Text('SS'),
                                            onTap: () => setState(() {
                                              scoredownfilter = 1000000;
                                              scoreupfilter = 1004999;
                                              Navigator.pop(b);
                                            }),
                                          ),
                                          ListTile(
                                            title: Text('S+'),
                                            onTap: () => setState(() {
                                              scoredownfilter = 990000;
                                              scoreupfilter = 999999;
                                              Navigator.pop(b);
                                            }),
                                          ),
                                          ListTile(
                                            title: Text('S'),
                                            onTap: () => setState(() {
                                              scoredownfilter = 975000;
                                              scoreupfilter = 989999;
                                              Navigator.pop(b);
                                            }),
                                          ),
                                          ListTile(
                                            title: Text('AAA'),
                                            onTap: () => setState(() {
                                              scoredownfilter = 950000;
                                              scoreupfilter = 974999;
                                              Navigator.pop(b);
                                            }),
                                          ),
                                          ListTile(
                                            title: Text('AA'),
                                            onTap: () => setState(() {
                                              scoredownfilter = 925000;
                                              scoreupfilter = 949999;
                                              Navigator.pop(b);
                                            }),
                                          ),
                                          ListTile(
                                            title: Text('A'),
                                            onTap: () => setState(() {
                                              scoredownfilter = 900000;
                                              scoreupfilter = 924999;
                                              Navigator.pop(b);
                                            }),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(b),
                                    child: Text('取消'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        scoredownfilter =
                                            int.tryParse(
                                              scoredownfiltercontroller.text,
                                            ) ??
                                            0;
                                        scoreupfilter =
                                            int.tryParse(
                                              scoreupfiltercontroller.text,
                                            ) ??
                                            1010000;
                                        Navigator.pop(b);
                                      });
                                    },
                                    child: Text('确定'),
                                  ),
                                ],
                              );
                            },
                          ),
                          child: Card(
                            child: Padding(
                              padding: EdgeInsetsGeometry.all(8),
                              child: Column(
                                children: [
                                  Text('分数筛选'),
                                  Text(
                                    '${scoredownfilter.toString()} - ${scoreupfilter.toString()}',
                                    maxLines: 1,
                                    style: TextStyle(fontSize: 10),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () => showDialog(
                            context: context,
                            builder: (b) {
                              return AlertDialog(
                                title: Text('选择连击状态'),
                                content: SizedBox(
                                  width: double.maxFinite,
                                  child: Column(
                                    children: [
                                      ListView(
                                        shrinkWrap: true,
                                        children: [
                                          ListTile(
                                            title: Text('全部'),
                                            onTap: () => setState(() {
                                              fcfilter = 'all';
                                              Navigator.pop(b);
                                            }),
                                          ),
                                          ListTile(
                                            title: Text('FC'),
                                            onTap: () => setState(() {
                                              fcfilter = 'fc';
                                              Navigator.pop(b);
                                            }),
                                          ),
                                          ListTile(
                                            title: Text('AJ'),
                                            onTap: () => setState(() {
                                              fcfilter = 'aj';
                                              Navigator.pop(b);
                                            }),
                                          ),
                                          ListTile(
                                            title: Text('AJC'),
                                            onTap: () => setState(() {
                                              fcfilter = 'ajc';
                                              Navigator.pop(b);
                                            }),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          child: Card(
                            child: Padding(
                              padding: EdgeInsetsGeometry.all(8),
                              child: Column(
                                children: [
                                  Text('连击筛选'),
                                  Text(
                                    fcfilter,
                                    style: TextStyle(fontSize: 10),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            List<List<Widget>> resultlist = returnScoreList(
                              allscoredata: allscore,
                              songsdata: songsdata,
                              context: context,
                              sortingmethod: sortingmethod,
                              scoredownfilter: scoredownfilter,
                              scoreupfilter: scoreupfilter,
                              levelfilterdown: levelfilterdown,
                              levelfilterup: levelfilterup,
                              levelindexfilter: levelindexfilter,
                              versionfilter: versionfilter,
                              fcfilter: fcfilter,
                            );
                            page = 0;
                            setState(() {
                              scorelist = resultlist;
                              pagecontroller.text = (page + 1).toString();
                            });
                          },
                          child: Text('筛选'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SliverList.builder(
              itemBuilder: (context, index) => scorelist[page][index],
              itemCount: scorelist[page].length,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                page = page - 1;
                if (page - 1 < 0) {
                  page = 0;
                }
                pagecontroller.text = (page + 1).toString();
              });
            },
            icon: Icon(Icons.arrow_back),
          ),
          SizedBox(
            width: 50,
            child: TextField(
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
              controller: pagecontroller,
              onChanged: (value) {
                setState(() {
                  if (value.isEmpty) return;
                  if (int.tryParse(value) != null) {
                    page = int.parse(value) - 1;
                  } else {
                    return;
                  }

                  if (page < 0) {
                    page = 0;
                  } else if (page >= scorelist.length) {
                    page = scorelist.length - 1;
                  }
                  pagecontroller.text = (page + 1).toString();
                });
              },
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                page++;
                if (page >= scorelist.length) {
                  page = scorelist.length - 1;
                }
                pagecontroller.text = (page + 1).toString();
              });
            },
            icon: Icon(Icons.arrow_forward),
          ),
        ],
      ),
    );
  }
}

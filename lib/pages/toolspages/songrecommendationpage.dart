import 'package:flutter/material.dart';
import '../../function/toolsfun/songrecommendationpagefun.dart';
import '../../function/list.dart';
import '../../function/searchfun/search.dart';
import 'dart:developer';

class SongRecommendationPage extends StatefulWidget {
  const SongRecommendationPage({super.key});

  @override
  State<SongRecommendationPage> createState() => _SongRecommendationPageState();
}

class _SongRecommendationPageState extends State<SongRecommendationPage>
    with SingleTickerProviderStateMixin {
  //定义所需变量
  Widget oldSongWidget = SizedBox.shrink(); //CircularProgressIndicator();
  Widget newSongWidget = SizedBox.shrink(); //CircularProgressIndicator();
  List<List<Widget>> oldSongWidgetList = [];
  List<List<Widget>> newSongWidgetList = [];
  int oldpage = 0;
  int newpage = 0;

  String? selectedGenre = '-1';
  String? selectedVersion = '-1';
  String? selectedDifficultyDown = '-1';
  String? selectedDifficultyUp = '-1';
  String? selectedifPlay = '-1';
  String? selectedRank = '-1';
  int? bpmup;
  int? bpmdown;
  List<Widget> searchResults = [];
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _bpmup = TextEditingController();
  final TextEditingController _bpmdown = TextEditingController();
  final TextEditingController _pageController = TextEditingController();
  final TextEditingController _preScoreController = TextEditingController();
  final TextEditingController _minRatingController = TextEditingController();
  late TabController _tabController;

  Widget genreDropdownMenu = DropdownMenu<String>(dropdownMenuEntries: []);
  Widget versionDropdownMenu = DropdownMenu<String>(dropdownMenuEntries: []);

  Future<void> _buildAllDropdownMenus() async {
    Widget genreDropdownMenu1 = await buildGenreDropdownMenu(
      initialSelection: selectedGenre,
      onSelected: (String? value) {
        setState(() {
          selectedGenre = value;
        });
        try {
          calculate();
        } catch (e) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('搜索失败，可能是数据丢失')));
        }
      },
    );
    Widget versionDropdownMenu1 = await buildVersionDropdownMenu(
      initialSelection: selectedVersion,
      onSelected: (String? value) {
        setState(() {
          selectedVersion = value;
        });
        try {
          calculate();
        } catch (e) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('搜索失败，可能是数据丢失')));
        }
      },
    );
    if (!mounted) return;
    setState(() {
      genreDropdownMenu = genreDropdownMenu1;
      versionDropdownMenu = versionDropdownMenu1;
    });
  }

  Future<List<dynamic>?> _performSearch() async {
    String searchTitle = _searchController.text;
    String genre = selectedGenre ?? '-1';
    String version = selectedVersion ?? '-1';
    String difficultyDown = selectedDifficultyDown ?? '-1';
    String difficultyUp = selectedDifficultyUp ?? '-1';
    String ifPlay = selectedifPlay ?? '-1';
    try {
      // 使用 await 调用异步函数
      List<dynamic> resultsMap = await filter(
        searchTitle,
        genre,
        version,
        difficultyDown,
        difficultyUp,
        ifPlay,
        bpmup,
        bpmdown,
        false,
        null,
      );
      return resultsMap;
    } catch (e) {
      log('搜索错误: $e', name: 'searchpage.dart', level: 1000);
      return null;
      // 可以显示错误信息给用户
    }
  }

  Future<void> calculate() async {
    List<dynamic>? filterSongs = await _performSearch();
    try {
      oldpage = 0;
      newpage = 0;
      // double.parse(_pageController.text);
      if (!mounted) return;
      if (filterSongs != null) {
        if (selectedRank == '-1') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('未选择评级，将使用SSS+评级'),
              duration: Duration(seconds: 1),
            ),
          );
        }
        if (_minRatingController.text == '') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('未输入最低Rating'),
              duration: Duration(microseconds: 1000),
            ),
          );
          return;
        }
        if (_tabController.index == 0) {
          oldSongWidgetList = await songRecommendation(
            isNew: false,
            filterSongs: filterSongs,
            rank: selectedRank ?? '-1',
            minRating: _minRatingController.text,
            context: context,
            expectedScore: _preScoreController.text,
          );
        } else {
          // log('新歌');
          newSongWidgetList = await songRecommendation(
            isNew: true,
            filterSongs: filterSongs,
            rank: selectedRank ?? '-1',
            minRating: _minRatingController.text,
            context: context,
            expectedScore: _preScoreController.text,
          );
        }
      }
      setState(() {
        if (_tabController.index == 0) {
          oldSongWidget = ListView.builder(
            itemBuilder: (context, index) => oldSongWidgetList[oldpage][index],
            itemCount: oldSongWidgetList[oldpage].length,
          );
          _pageController.text = '${oldpage + 1}';
        } else {
          newSongWidget = ListView.builder(
            itemBuilder: (context, index) => newSongWidgetList[newpage][index],
            itemCount: newSongWidgetList[newpage].length,
          );
          _pageController.text = '${newpage + 1}';
        }
      });
      // print(oldSongWidgetList);
    } catch (e, strack) {
      log('$e\n$strack', name: 'songrecommendationpage.dart', level: 1000);
      setState(() {
        oldSongWidget = Text('错误 $e\n$strack');
      });
    }
  }

  Future<void> init({required bool isNew}) async {
    try {
      double? result = await initminRating(isNew: isNew);
      if (result == null) {
        setState(() {
          _minRatingController.text = '';
          return;
        });
      } else {
        setState(() {
          _minRatingController.text = result.toString();
        });
      }
    } catch (e) {
      log('获取b50失败');
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    init(isNew: false);
    _tabController = TabController(length: 2, vsync: this);
    _buildAllDropdownMenus();
  }

  @override
  void didChangeDependencies() {
    // init();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('吃分推荐')),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: genreDropdownMenu),
                Expanded(child: versionDropdownMenu),
                Expanded(
                  child: buildDifficultyDownDropdownMenu(
                    initialSelection: selectedDifficultyDown,
                    onSelected: (String? value) {
                      setState(() {
                        selectedDifficultyDown = value;
                      });
                      try {
                        calculate();
                      } catch (e) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text('$e')));
                      }
                    },
                  ),
                ),
                Expanded(
                  child: buildDifficultyUpDropdownMenu(
                    initialSelection: selectedDifficultyUp,
                    onSelected: (String? value) {
                      setState(() {
                        selectedDifficultyUp = value;
                      });
                      try {
                        calculate();
                      } catch (e) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text('$e')));
                      }
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _bpmdown,
                    decoration: InputDecoration(hintText: 'BPM下限'),
                    onChanged: (value) {
                      try {
                        bpmdown = int.parse(_bpmdown.text);
                        calculate();
                      } catch (e) {
                        bpmdown = null;
                        log('bpmdown不是数字');
                      }
                    },
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _bpmup,
                    decoration: InputDecoration(hintText: 'BPM上限'),
                    onChanged: (value) {
                      try {
                        bpmup = int.parse(_bpmup.text);
                        calculate();
                      } catch (e) {
                        bpmup = null;
                        log('bpmup不是数字');
                      }
                    },
                  ),
                ),
                Expanded(
                  child: buildRankDropdownMenu(
                    initialSelection: selectedRank,
                    onSelected: (String? value) {
                      setState(() {
                        selectedRank = value;
                      });
                      try {
                        calculate();
                      } catch (e) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text('$e')));
                      }
                    },
                  ),
                ),

                Expanded(
                  child: buildIfPlayDropdownMenu(
                    initialSelection: selectedifPlay,
                    onSelected: (String? value) {
                      setState(() {
                        selectedifPlay = value;
                      });
                      try {
                        calculate();
                      } catch (e) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text('$e')));
                      }
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text('最低Rating：'),
                Expanded(child: TextField(controller: _minRatingController)),
                Text('预吃分数：'),
                Expanded(child: TextField(controller: _preScoreController)),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => calculate(),
                    child: Text('计算'),
                  ),
                ),
              ],
            ),
            TabBar(
              controller: _tabController,
              tabs: [
                Tab(text: '旧歌'),
                Tab(text: '新歌'),
              ],
              onTap: (value) async {
                try {
                  if (value == 0) {
                    init(isNew: false);
                    if (oldSongWidgetList.isNotEmpty) {
                      setState(() {
                        oldSongWidget = ListView.builder(
                          itemBuilder: (context, index) =>
                              oldSongWidgetList[oldpage][index],
                          itemCount: oldSongWidgetList[oldpage].length,
                        );
                        _pageController.text = '${oldpage + 1}';
                      });
                    }
                  } else if (value == 1) {
                    init(isNew: true);
                    if (newSongWidgetList.isNotEmpty) {
                      setState(() {
                        newSongWidget = ListView.builder(
                          itemBuilder: (context, index) =>
                              newSongWidgetList[newpage][index],
                          itemCount: newSongWidgetList[newpage].length,
                        );
                        _pageController.text = '${newpage + 1}';
                      });
                    }
                  }
                } catch (e, strack) {
                  log('$e\n$strack');
                  if (!context.mounted) return;
                  // ScaffoldMessenger.of(
                  //   context,
                  // ).showSnackBar(SnackBar(content: Text('错误 $e')));
                }
              },
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  Center(child: oldSongWidget),
                  Center(child: newSongWidget),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              try {
                if (_tabController.index == 0) {
                  oldpage = oldpage - 1;
                  // log('$page');
                  if (oldpage < 0) {
                    oldpage = 0;
                  }
                  setState(() {
                    oldSongWidget = ListView.builder(
                      itemBuilder: (context, index) =>
                          oldSongWidgetList[oldpage][index],
                      itemCount: oldSongWidgetList[oldpage].length,
                    );
                    _pageController.text = '${oldpage + 1}';
                  });
                } else {
                  newpage = newpage - 1;
                  // log('$page');
                  if (newpage < 0) {
                    newpage = 0;
                  }
                  setState(() {
                    newSongWidget = ListView.builder(
                      itemBuilder: (context, index) =>
                          newSongWidgetList[newpage][index],
                      itemCount: newSongWidgetList[newpage].length,
                    );
                    _pageController.text = '${newpage + 1}';
                  });
                }
              } catch (e) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('没了')));
              }
            },
            icon: Icon(Icons.arrow_back),
          ),
          SizedBox(
            width: 50,
            child: TextField(
              controller: _pageController,
              onChanged: (value) {
                try {
                  if (_tabController.index == 0) {
                    oldpage = int.parse(value) - 1;
                    if (oldpage < 0) {
                      oldpage = 0;
                    } else if (oldpage >= oldSongWidgetList.length) {
                      oldpage = oldSongWidgetList.length - 1;
                    }
                    setState(() {
                      oldSongWidget = ListView.builder(
                        itemBuilder: (context, index) =>
                            oldSongWidgetList[oldpage][index],
                        itemCount: oldSongWidgetList[oldpage].length,
                      );
                    });
                  } else {
                    newpage = int.parse(value) - 1;
                    if (newpage < 0) {
                      newpage = 0;
                    } else if (newpage >= newSongWidgetList.length) {
                      newpage = newSongWidgetList.length - 1;
                    }
                    setState(() {
                      newSongWidget = ListView.builder(
                        itemBuilder: (context, index) =>
                            newSongWidgetList[newpage][index],
                        itemCount: newSongWidgetList[newpage].length,
                      );
                    });
                  }
                } catch (e) {
                  return;
                }
              },
            ),
          ),
          IconButton(
            onPressed: () {
              try {
                // log('$page');
                if (_tabController.index == 0) {
                  oldpage = oldpage + 1;
                  if (oldpage >= oldSongWidgetList.length) {
                    oldpage = oldSongWidgetList.length - 1;
                  }
                  setState(() {
                    oldSongWidget = ListView.builder(
                      itemBuilder: (context, index) =>
                          oldSongWidgetList[oldpage][index],
                      itemCount: oldSongWidgetList[oldpage].length,
                    );
                    _pageController.text = '${oldpage + 1}';
                  });
                } else {
                  newpage = newpage + 1;
                  if (newpage >= newSongWidgetList.length) {
                    newpage = newSongWidgetList.length - 1;
                  }
                  setState(() {
                    newSongWidget = ListView.builder(
                      itemBuilder: (context, index) =>
                          newSongWidgetList[newpage][index],
                      itemCount: newSongWidgetList[newpage].length,
                    );
                    _pageController.text = '${newpage + 1}';
                  });
                }
              } catch (e) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('你生成完再点啊')));
              }
            },
            icon: Icon(Icons.arrow_forward),
          ),
        ],
      ),
    );
  }
}

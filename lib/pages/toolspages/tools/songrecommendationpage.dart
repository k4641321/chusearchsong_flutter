import 'package:flutter/material.dart';
import '../../../function/toolsfun/songrecommendationpagefun.dart';
import '../../../function/list.dart';
import '../../../function/searchfun/search.dart';
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
  int? selectedSpecialFilter = 0;
  bool isMinRatingChanged = false;
  bool _ready = false;

  List<String> selectedGenre = ['-1'];
  List<Widget> genreWidgetList = [];
  List<Widget> versionWidgetList = [];
  List<String> selectedVersion = ['-1'];
  String? selectedDifficultyDown = '-1';
  String? selectedDifficultyUp = '-1';
  String? selectedifPlay = '-1';
  String? selectedRank = '-1';
  int? bpmup;
  int? bpmdown;
  List<Widget> searchResults = [];
  Map<String, dynamic> songsData = {};
  Map<String, dynamic> aliasData = {};

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _bpmup = TextEditingController();
  final TextEditingController _bpmdown = TextEditingController();
  final TextEditingController _pageController = TextEditingController();
  final TextEditingController _preScoreController = TextEditingController();
  final TextEditingController _minRatingController = TextEditingController();
  late TabController _tabController;
  final TextEditingController _difficultydown = TextEditingController();
  final TextEditingController _difficultyup = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  //筛选按钮
  IconData _filterIcon = Icons.filter_alt;
  bool _showfilter = true;
  //流派显示
  IconData _showgenreIcon = Icons.arrow_drop_up_sharp;
  bool _showgenre = false;
  //版本显示
  IconData _showversionIcon = Icons.arrow_drop_up_sharp;
  bool _showversion = false;
  //难度显示
  IconData _showdiffIcon = Icons.arrow_drop_up_sharp;
  bool _showdiff = false;
  //Bpm显示
  IconData _showbpmIcon = Icons.arrow_drop_up_sharp;
  bool _showbpm = false;
  //其余筛选显示
  IconData _showotherIcon = Icons.arrow_drop_up_sharp;
  bool _showother = false;

  void buildGenreWidget() {
    List<Widget> genreWidgets = buildGenreWrapList(
      songsdata: songsData,
      currentGenre: selectedGenre,
      onChange: () => setState(() {}),
      onGenreSelected: (value) {
        if (selectedGenre.contains(value) && value != '-1') {
          selectedGenre.remove(value);
          selectedGenre.remove('-1');
        } else {
          selectedGenre.add(value);
          selectedGenre.remove('-1');
        }
        if (selectedGenre.isEmpty) {
          selectedGenre = ['-1'];
        } else if (value == '-1') {
          selectedGenre = ['-1'];
        }
        buildGenreWidget();
        calculate();
        // print(selectedGenre);
      },
    );
    if (!mounted) return;
    setState(() {
      genreWidgetList = genreWidgets;
    });
  }

  void buildVersionWidget() {
    List<Widget> versionWidgets = buildVersionWrapList(
      songsdata: songsData,
      currentVersion: selectedVersion,
      onChange: () => setState(() {}),
      onGenreSelected: (value) {
        if (selectedVersion.contains(value) && value != '-1') {
          selectedVersion.remove(value);
          selectedVersion.remove('-1');
        } else {
          selectedVersion.add(value);
          selectedVersion.remove('-1');
        }
        if (selectedVersion.isEmpty) {
          selectedVersion = ['-1'];
        } else if (value == '-1') {
          selectedVersion = ['-1'];
        }
        buildVersionWidget();
        calculate();
        // print(selectedGenre);
      },
    );
    if (!mounted) return;
    setState(() {
      versionWidgetList = versionWidgets;
    });
  }

  Future<List<dynamic>?> _performSearch() async {
    if (!_ready) return [];
    String searchTitle = _searchController.text;
    String difficultyDown = selectedDifficultyDown ?? '-1';
    String difficultyUp = selectedDifficultyUp ?? '-1';
    String ifPlay = selectedifPlay ?? '-1';
    try {
      // 使用 await 调用异步函数
      List<dynamic> resultsMap = await filter(
        songsData,
        aliasData,
        searchTitle,
        selectedGenre,
        selectedVersion,
        difficultyDown,
        difficultyUp,
        ifPlay,
        bpmdown,
        bpmup,
        false,
        null,
        0,
      );
      return resultsMap;
    } catch (e, strack) {
      log('搜索错误: $e\n$strack', name: 'searchpage.dart', level: 1000);
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
      if (!context.mounted) return;
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
      if (!context.mounted) return;
      setState(() {
        oldSongWidget = Text('错误 $e\n$strack');
      });
    }
  }

  Future<void> init({required bool isNew}) async {
    try {
      songsData = await loadSongs();
      aliasData = await loadAlias();
      buildGenreWidget();
      buildVersionWidget();
      double? result = await initminRating(isNew: isNew);
      if (result == null) {
        if (!context.mounted) return;
        setState(() {
          _minRatingController.text = '';
          return;
        });
      } else {
        if (!context.mounted) return;
        setState(() {
          _minRatingController.text = result.toString();
        });
      }
    } catch (e) {
      log('获取b50失败');
      return;
    }
  }

  void _onDifficultyUpInput() {
    log('自定义难度上限');
    selectedDifficultyUp = _difficultyup.text;
    calculate();
  }

  void _onDifficultyDownInput() {
    log('自定义难度下限');
    selectedDifficultyDown = _difficultydown.text;
    calculate();
  }

  @override
  void initState() {
    super.initState();
    init(isNew: false);
    _tabController = TabController(length: 2, vsync: this);
    _difficultyup.addListener(_onDifficultyUpInput);
    _difficultydown.addListener(_onDifficultyDownInput);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ready = true;
    });
  }

  @override
  void didChangeDependencies() {
    // init();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _difficultyup.removeListener(_onDifficultyUpInput);
    _difficultydown.removeListener(_onDifficultyDownInput);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('吃分推荐'),
        actions: [
          IconButton(
            onPressed: () {
              if (_showfilter == false) {
                setState(() {
                  _showfilter = true;
                });
              } else if (_showfilter == true) {
                setState(() {
                  _showfilter = false;
                });
              }
              if (_filterIcon == Icons.arrow_drop_down) {
                setState(() {
                  _filterIcon = Icons.arrow_drop_up;
                });
              } else if (_filterIcon == Icons.arrow_drop_up) {
                setState(() {
                  _filterIcon = Icons.arrow_drop_down;
                });
              }
            },
            icon: Icon(_filterIcon),
          ),
        ],
      ),
      body: DefaultTabController(
        length: 2,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: '搜索...标题，曲师，别名，落雪id，谱师',
                          ),
                          onChanged: (value) {
                            try {
                              calculate();
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('搜索失败，可能是数据丢失')),
                              );
                            }
                          },
                        ),
                      ),

                      IconButton(
                        onPressed: () {
                          try {
                            calculate();
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('搜索失败，可能是数据丢失')),
                            );
                          }
                        },
                        icon: Icon(Icons.search),
                      ),
                    ],
                  ),
                  AnimatedSize(
                    duration: Duration(milliseconds: 250),
                    child: _showfilter
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Column(
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      setState(() {
                                        _showgenre = !_showgenre;
                                        if (_showgenreIcon ==
                                            Icons.arrow_drop_down) {
                                          _showgenreIcon = Icons.arrow_drop_up;
                                        } else {
                                          _showgenreIcon =
                                              Icons.arrow_drop_down;
                                        }
                                      });
                                    },
                                    child: Padding(
                                      padding: EdgeInsetsGeometry.all(8),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              '分类',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Icon(_showgenreIcon),
                                        ],
                                      ),
                                    ),
                                  ),
                                  _showgenre
                                      ? Wrap(
                                          spacing: 5.0,
                                          runSpacing: 3.0,
                                          children: genreWidgetList,
                                        )
                                      : SizedBox.shrink(),
                                ],
                              ),
                              Column(
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      setState(() {
                                        _showversion = !_showversion;
                                        if (_showversionIcon ==
                                            Icons.arrow_drop_down) {
                                          _showversionIcon =
                                              Icons.arrow_drop_up;
                                        } else {
                                          _showversionIcon =
                                              Icons.arrow_drop_down;
                                        }
                                      });
                                    },
                                    child: Padding(
                                      padding: EdgeInsetsGeometry.all(8),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              '版本',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Icon(_showversionIcon),
                                        ],
                                      ),
                                    ),
                                  ),
                                  _showversion
                                      ? Wrap(
                                          spacing: 5.0,
                                          runSpacing: 3.0,
                                          children: versionWidgetList,
                                        )
                                      : SizedBox.shrink(),
                                  Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            _showdiff = !_showdiff;
                                            if (_showdiffIcon ==
                                                Icons.arrow_drop_down) {
                                              _showdiffIcon =
                                                  Icons.arrow_drop_up;
                                            } else {
                                              _showdiffIcon =
                                                  Icons.arrow_drop_down;
                                            }
                                          });
                                        },
                                        child: Padding(
                                          padding: EdgeInsetsGeometry.all(8),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  '难度',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              Icon(_showdiffIcon),
                                            ],
                                          ),
                                        ),
                                      ),
                                      _showdiff
                                          ? Row(
                                              children: [
                                                Expanded(
                                                  child: buildDifficultyDownDropdownMenu(
                                                    ccontroller:
                                                        _difficultydown,
                                                    initialSelection:
                                                        selectedDifficultyDown,
                                                    onSelected: (String? value) {
                                                      setState(() {
                                                        selectedDifficultyDown =
                                                            value;
                                                      });
                                                      try {
                                                        calculate();
                                                      } catch (e) {
                                                        ScaffoldMessenger.of(
                                                          context,
                                                        ).showSnackBar(
                                                          SnackBar(
                                                            content: Text(
                                                              '搜索失败，可能是数据丢失',
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                    },
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      EdgeInsetsGeometry.only(
                                                        left: 10,
                                                        right: 10,
                                                      ),
                                                  child: Text('~'),
                                                ),
                                                Expanded(
                                                  child: buildDifficultyUpDropdownMenu(
                                                    ccontroller: _difficultyup,
                                                    initialSelection:
                                                        selectedDifficultyUp,
                                                    onSelected: (String? value) {
                                                      setState(() {
                                                        selectedDifficultyUp =
                                                            value;
                                                      });
                                                      try {
                                                        calculate();
                                                      } catch (e) {
                                                        ScaffoldMessenger.of(
                                                          context,
                                                        ).showSnackBar(
                                                          SnackBar(
                                                            content: Text(
                                                              '搜索失败，可能是数据丢失',
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ],
                                            )
                                          : SizedBox.shrink(),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        _showbpm = !_showbpm;
                                        if (_showbpmIcon ==
                                            Icons.arrow_drop_down) {
                                          _showbpmIcon = Icons.arrow_drop_up;
                                        } else {
                                          _showbpmIcon = Icons.arrow_drop_down;
                                        }
                                      });
                                    },
                                    child: Padding(
                                      padding: EdgeInsetsGeometry.all(8),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              'BPM',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Icon(_showbpmIcon),
                                        ],
                                      ),
                                    ),
                                  ),
                                  _showbpm
                                      ? Row(
                                          children: [
                                            Expanded(
                                              child: TextField(
                                                controller: _bpmdown,
                                                decoration: InputDecoration(
                                                  hintText: 'BPM下限',
                                                ),
                                                onChanged: (value) {
                                                  try {
                                                    bpmdown = int.parse(
                                                      _bpmdown.text,
                                                    );
                                                    calculate();
                                                  } catch (e) {
                                                    bpmdown = null;
                                                    log('bpmdown不是数字');
                                                  }
                                                },
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsGeometry.only(
                                                left: 10,
                                                right: 10,
                                              ),
                                              child: Text('~'),
                                            ),
                                            Expanded(
                                              child: TextField(
                                                controller: _bpmup,
                                                decoration: InputDecoration(
                                                  hintText: 'BPM上限',
                                                ),
                                                onChanged: (value) {
                                                  try {
                                                    bpmup = int.parse(
                                                      _bpmup.text,
                                                    );
                                                    calculate();
                                                  } catch (e) {
                                                    bpmup = null;
                                                    log('bpmup不是数字');
                                                  }
                                                },
                                              ),
                                            ),
                                          ],
                                        )
                                      : SizedBox.shrink(),
                                ],
                              ),
                              Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        _showother = !_showother;
                                        if (_showotherIcon ==
                                            Icons.arrow_drop_down) {
                                          _showotherIcon = Icons.arrow_drop_up;
                                        } else {
                                          _showotherIcon =
                                              Icons.arrow_drop_down;
                                        }
                                      });
                                    },
                                    child: Padding(
                                      padding: EdgeInsetsGeometry.all(8),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              '其余选项',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Icon(_showotherIcon),
                                        ],
                                      ),
                                    ),
                                  ),
                                  _showother
                                      ? Column(
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: buildSpecialFilterDropdownMenu(
                                                    initialSelection:
                                                        selectedSpecialFilter,
                                                    onSelected: (int? value) {
                                                      setState(() {
                                                        selectedSpecialFilter =
                                                            value;
                                                      });
                                                      try {
                                                        calculate();
                                                      } catch (e) {
                                                        ScaffoldMessenger.of(
                                                          context,
                                                        ).showSnackBar(
                                                          SnackBar(
                                                            content: Text(
                                                              '搜索失败，可能是数据丢失',
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                    },
                                                  ),
                                                ),
                                                Expanded(
                                                  child: buildRankDropdownMenu(
                                                    initialSelection:
                                                        selectedRank,
                                                    onSelected: (String? value) {
                                                      if (!context.mounted) {
                                                        return;
                                                      }

                                                      setState(() {
                                                        selectedRank = value;
                                                      });
                                                      try {
                                                        calculate();
                                                      } catch (e) {
                                                        ScaffoldMessenger.of(
                                                          context,
                                                        ).showSnackBar(
                                                          SnackBar(
                                                            content: Text('$e'),
                                                          ),
                                                        );
                                                      }
                                                    },
                                                  ),
                                                ),

                                                Expanded(
                                                  child: buildIfPlayDropdownMenu(
                                                    initialSelection:
                                                        selectedifPlay,
                                                    onSelected: (String? value) {
                                                      if (!context.mounted) {
                                                        return;
                                                      }
                                                      setState(() {
                                                        selectedifPlay = value;
                                                      });
                                                      try {
                                                        calculate();
                                                      } catch (e) {
                                                        ScaffoldMessenger.of(
                                                          context,
                                                        ).showSnackBar(
                                                          SnackBar(
                                                            content: Text('$e'),
                                                          ),
                                                        );
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text('最低Rating：'),
                                                Expanded(
                                                  child: TextField(
                                                    onChanged: (value) {
                                                      isMinRatingChanged = true;
                                                      calculate();
                                                    },
                                                    controller:
                                                        _minRatingController,
                                                  ),
                                                ),
                                                Text('预吃分数：'),
                                                Expanded(
                                                  child: TextField(
                                                    controller:
                                                        _preScoreController,
                                                    onChanged: (value) =>
                                                        calculate(),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      : SizedBox.shrink(),
                                ],
                              ),
                            ],
                          )
                        : SizedBox.shrink(),
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
                        if (isMinRatingChanged == true) {
                          return;
                        }
                        if (value == 0) {
                          init(isNew: false);
                          if (oldSongWidgetList.isNotEmpty) {
                            if (!context.mounted) return;
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
                            if (!context.mounted) return;
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
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                width: MediaQuery.widthOf(context),
                height: MediaQuery.heightOf(context),
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    Center(child: oldSongWidget),
                    Center(child: newSongWidget),
                  ],
                ),
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
                  if (!context.mounted) return;
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
                  if (!context.mounted) return;
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
                    if (!context.mounted) return;
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
                    if (!context.mounted) return;
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
                  if (!context.mounted) return;
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
                  if (!context.mounted) return;
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

import 'package:flutter/material.dart';
import '../../../function/list.dart';
import 'dart:developer';
import '../../../function/searchfun/search.dart';

class RandomMusicPage extends StatefulWidget {
  const RandomMusicPage({super.key});
  @override
  State<RandomMusicPage> createState() => _RandomMusicPageState();
}

class _RandomMusicPageState extends State<RandomMusicPage> {
  List<String> selectedGenre = ['-1'];
  List<Widget> genreWidgetList = [];
  List<Widget> versionWidgetList = [];
  List<String> selectedVersion = ['-1'];
  String? selectedDifficultyDown = '-1';
  String? selectedDifficultyUp = '-1';
  String? selectedifPlay = '-1';
  int? bpmup;
  int? bpmdown;
  int count = 0;
  List<Widget> searchResults = [];
  Map<String, dynamic> songsData = {};
  Map<String, dynamic> aliasData = {};
  // Future result;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _bpmup = TextEditingController();
  final TextEditingController _bpmdown = TextEditingController();
  List<Widget> songResult = [Text('待抽取')];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _difficultydown = TextEditingController();
  final TextEditingController _difficultyup = TextEditingController();
  bool _ready = false;

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

  Future<void> _performSearch() async {
    if (!_ready) return;
    String searchTitle = _searchController.text;

    String difficultyDown = selectedDifficultyDown ?? '-1';
    String difficultyUp = selectedDifficultyUp ?? '-1';
    String ifPlay = selectedifPlay ?? '-1';
    int randomcount;

    randomcount = count;
    try {
      // 使用 await 调用异步函数
      Map<String, dynamic> resultsMap = await filter(
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
        randomcount,
        0,
      );
      if (!mounted) return;
      List<Widget> results = await search(
        songsData: songsData,
        songresultMap: resultsMap,
        context: context,
      );
      if (!mounted) return;
      // 更新状态
      setState(() {
        songResult = results;
      });
    } catch (e, strack) {
      log('搜索错误: $e\n$strack', name: 'searchpage.dart', level: 1000);
      // 可以显示错误信息给用户
    }
  }

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
        // print(selectedGenre);
      },
    );
    if (!mounted) return;
    setState(() {
      versionWidgetList = versionWidgets;
    });
  }

  void _onDifficultyUpInput() {
    log('自定义难度上限');
    if (double.tryParse(_difficultyup.text) != null) {
      selectedDifficultyUp = double.tryParse(_difficultyup.text).toString();
    }
  }

  void _onDifficultyDownInput() {
    log('自定义难度下限');
    if (double.tryParse(_difficultydown.text) != null) {
      selectedDifficultyDown = double.tryParse(_difficultydown.text).toString();
    }
  }

  Future<void> init() async {
    songsData = await loadSongs();
    aliasData = await loadAlias();
    buildGenreWidget();
    buildVersionWidget();
  }

  @override
  void initState() {
    super.initState();
    init();
    _difficultyup.addListener(_onDifficultyUpInput);
    _difficultydown.addListener(_onDifficultyDownInput);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ready = true;
    });
  }

  @override
  void dispose() {
    _difficultyup.removeListener(_onDifficultyUpInput);
    _difficultydown.removeListener(_onDifficultyDownInput);
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
      appBar: AppBar(
        title: Text('随机歌曲'),
        // backgroundColor: const Color.fromARGB(255, 255, 229, 84),
        actions: [
          IconButton(
            onPressed: () async {
              setState(() {
                if (_filterIcon == Icons.filter_alt_off) {
                  _filterIcon = Icons.filter_alt;
                } else {
                  _filterIcon = Icons.filter_alt_off;
                }
                _showfilter = !_showfilter;
              });
            },
            icon: Icon(_filterIcon),
          ),
        ],
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () async {
                          count = 1;
                          await _performSearch();
                        },
                        child: Text(
                          '抽一首',
                          style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).colorScheme.onSurface,
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
                        onPressed: () async {
                          count = 3;
                          await _performSearch();
                        },
                        child: Text(
                          '抽三首',
                          style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsetsGeometry.only(bottom: 5),
                  child: InkWell(
                    onTap: () async {
                      try {
                        count = int.parse(_controller.text);
                      } catch (e) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text('输的什么玩意')));
                        return;
                      }
                      await _performSearch();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '抽',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 70,
                          child: TextField(
                            controller: _controller,
                            decoration: InputDecoration(
                              isDense: true,
                              // hintText: '我去除了大部分输入框边框，只保留了底边，这样才能让你知道这至少是个输入框（）',
                            ),
                          ),
                        ),
                        Text(
                          '首',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          _showfilter
              ? SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Column(
                        children: [
                          InkWell(
                            onTap: () async {
                              setState(() {
                                _showgenre = !_showgenre;
                                if (_showgenreIcon == Icons.arrow_drop_down) {
                                  _showgenreIcon = Icons.arrow_drop_up;
                                } else {
                                  _showgenreIcon = Icons.arrow_drop_down;
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
                                if (_showversionIcon == Icons.arrow_drop_down) {
                                  _showversionIcon = Icons.arrow_drop_up;
                                } else {
                                  _showversionIcon = Icons.arrow_drop_down;
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
                        ],
                      ),
                      // Row(children: [Expanded(child: versionDropdownMenu)]),
                      Column(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                _showdiff = !_showdiff;
                                if (_showdiffIcon == Icons.arrow_drop_down) {
                                  _showdiffIcon = Icons.arrow_drop_up;
                                } else {
                                  _showdiffIcon = Icons.arrow_drop_down;
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
                                        ccontroller: _difficultydown,
                                        initialSelection:
                                            selectedDifficultyDown,
                                        onSelected: (String? value) {
                                          setState(() {
                                            selectedDifficultyDown = value;
                                          });
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
                                      child: buildDifficultyUpDropdownMenu(
                                        ccontroller: _difficultyup,
                                        initialSelection: selectedDifficultyUp,
                                        onSelected: (String? value) {
                                          setState(() {
                                            selectedDifficultyUp = value;
                                          });
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
                                _showbpm = !_showbpm;
                                if (_showbpmIcon == Icons.arrow_drop_down) {
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
                                          bpmdown = int.tryParse(_bpmdown.text);
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
                                          bpmup = int.tryParse(_bpmup.text);
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
                                if (_showotherIcon == Icons.arrow_drop_down) {
                                  _showotherIcon = Icons.arrow_drop_up;
                                } else {
                                  _showotherIcon = Icons.arrow_drop_down;
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
                              ? Row(
                                  children: [
                                    Expanded(
                                      child: buildIfPlayDropdownMenu(
                                        initialSelection: selectedifPlay,
                                        onSelected: (String? value) {
                                          setState(() {
                                            selectedifPlay = value;
                                          });
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
                )
              : SliverToBoxAdapter(child: SizedBox.shrink()),
          SliverList.builder(
            itemBuilder: (context, index) => songResult[index],
            itemCount: songResult.length,
          ),
        ],
      ),
    );
  }
}

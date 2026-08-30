import 'package:flutter/material.dart';
import '../../function/list.dart';
import '../../function/searchfun/search.dart';
import 'dart:developer';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<String> selectedGenre = ['-1'];
  List<Widget> genreWidgetList = [];
  List<Widget> versionWidgetList = [];
  List<String> selectedVersion = ['-1'];
  String? selectedDifficultyDown = '-1';
  String? selectedDifficultyUp = '-1';
  String? selectedifPlay = '-1';
  int? selectedSpecialFilter = 0;
  int? bpmup;
  int? bpmdown;
  List<Widget> searchResults = [];
  Map<String, dynamic> songsData = {};
  Map<String, dynamic> aliasData = {};
  // Future result;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _bpmup = TextEditingController();
  final TextEditingController _bpmdown = TextEditingController();
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
        true,
        null,
        selectedSpecialFilter,
      );
      if (!mounted) return;
      List<Widget> results = await search(
        songsData: songsData,
        songresultMap: resultsMap,
        context: context,
        searchinfo: resultsMap['searchinfo'],
      );
      if (!mounted) return;
      setState(() {
        searchResults = results;
      });
    } catch (e, strack) {
      log('搜索错误: $e\n$strack', name: 'searchpage.dart', level: 1000);
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
        _performSearch();
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
        _performSearch();
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
    _performSearch();
  }

  void _onDifficultyDownInput() {
    log('自定义难度下限');
    if (double.tryParse(_difficultydown.text) != null) {
      selectedDifficultyDown = double.tryParse(_difficultydown.text).toString();
    }
    _performSearch();
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
      body: Center(
        child: Scrollbar(
          controller: _scrollController,
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsetsGeometry.only(bottom: 5),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: '搜索...标题，曲师，别名，落雪id，谱师',
                          ),
                          onChanged: (value) {
                            try {
                              _performSearch();
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('搜索失败，可能是数据丢失')),
                              );
                            }
                          },
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          setState(() {
                            _showfilter = !_showfilter;
                            if (_filterIcon == Icons.filter_alt_off) {
                              _filterIcon = Icons.filter_alt;
                            } else {
                              _filterIcon = Icons.filter_alt_off;
                            }
                          });
                        },
                        icon: Icon(_filterIcon),
                      ),
                      IconButton(
                        onPressed: () {
                          try {
                            _performSearch();
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
                                    if (_showgenreIcon ==
                                        Icons.arrow_drop_down) {
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
                                    if (_showversionIcon ==
                                        Icons.arrow_drop_down) {
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
                                    if (_showdiffIcon ==
                                        Icons.arrow_drop_down) {
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
                                          child:
                                              buildDifficultyDownDropdownMenu(
                                                ccontroller: _difficultydown,
                                                initialSelection:
                                                    selectedDifficultyDown,
                                                onSelected: (String? value) {
                                                  setState(() {
                                                    selectedDifficultyDown =
                                                        value;
                                                  });
                                                  try {
                                                    _performSearch();
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
                                          padding: EdgeInsetsGeometry.only(
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
                                                selectedDifficultyUp = value;
                                              });
                                              try {
                                                _performSearch();
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
                                              try {
                                                bpmdown = int.parse(
                                                  _bpmdown.text,
                                                );
                                                _performSearch();
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
                                                bpmup = int.parse(_bpmup.text);
                                                _performSearch();
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
                                              try {
                                                _performSearch();
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
                                          child: buildSpecialFilterDropdownMenu(
                                            initialSelection:
                                                selectedSpecialFilter,
                                            onSelected: (int? value) {
                                              setState(() {
                                                selectedSpecialFilter = value;
                                              });
                                              try {
                                                _performSearch();
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
                    )
                  : SliverToBoxAdapter(child: SizedBox.shrink()),

              // Expanded(
              //         child: ListView.builder(
              //           itemCount: searchResults.length,
              //           itemBuilder: (context, index) => searchResults[index],
              //         ),
              //       ),
              SliverList.builder(
                itemBuilder: (context, index) => searchResults[index],
                itemCount: searchResults.length,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

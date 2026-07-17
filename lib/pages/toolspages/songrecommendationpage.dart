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

class _SongRecommendationPageState extends State<SongRecommendationPage> {
  Widget oldSongWidget = CircularProgressIndicator();
  Widget newSongWidget = CircularProgressIndicator();
  List<List<Widget>> oldSongWidgetList = [];
  List<List<Widget>> newSongWidgetList = [];
  int page = 0;

  String? selectedGenre = '-1';
  String? selectedVersion = '-1';
  String? selectedDifficultyDown = '-1';
  String? selectedDifficultyUp = '-1';
  String? selectedifPlay = '-1';
  String? selectedRank = '-1';
  int? bpmup;
  int? bpmdown;
  List<Widget> searchResults = [];
  // Future result;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _bpmup = TextEditingController();
  final TextEditingController _bpmdown = TextEditingController();
  final TextEditingController _pageController = TextEditingController();

  Widget genreDropdownMenu = DropdownMenu<String>(dropdownMenuEntries: []);
  Widget versionDropdownMenu = DropdownMenu<String>(dropdownMenuEntries: []);

  Future<void> _buildAllDropdownMenus() async {
    log('1');
    Widget genreDropdownMenu1 = await buildGenreDropdownMenu(
      initialSelection: selectedGenre,
      onSelected: (String? value) {
        setState(() {
          selectedGenre = value;
        });
        try {
          _performSearch();
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
          _performSearch();
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

  Future<void> _performSearch() async {
    String searchTitle = _searchController.text;
    String genre = selectedGenre ?? '-1';
    String version = selectedVersion ?? '-1';
    String difficultyDown = selectedDifficultyDown ?? '-1';
    String difficultyUp = selectedDifficultyUp ?? '-1';
    String ifPlay = selectedifPlay ?? '-1';
    String rank = selectedRank ?? '-1';
    try {
      // 使用 await 调用异步函数
      List<Widget> results = await search(
        searchTitle,
        genre,
        version,
        difficultyDown,
        difficultyUp,
        ifPlay,
        bpmup,
        bpmdown,
        true,
        null,
        context,
      );
      if (!mounted) return;
      // 更新状态
      setState(() {
        searchResults = results;
      });
    } catch (e) {
      log('搜索错误: $e', name: 'searchpage.dart', level: 1000);
      // 可以显示错误信息给用户
    }
  }

  Future<void> init() async {
    try {
      oldSongWidgetList = await oldSongRecommendation(
        ifYueJi: false,
        context: context,
      );
      // print(oldSongWidgetList);
      setState(() {
        oldSongWidget = ListView.builder(
          itemBuilder: (context, index) => oldSongWidgetList[page][index],
          itemCount: oldSongWidgetList[page].length,
        );
      });
    } catch (e, strack) {
      log('$e\n$strack', name: 'songrecommendationpage.dart', level: 1000);
    }
  }

  @override
  void initState() {
    super.initState();
    _buildAllDropdownMenus();
  }

  @override
  void didChangeDependencies() {
    // init();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      //   child: Icon(Icons.arrow_upward),
      //   onPressed: () {
      //     oldSongWidgetScrollerController.jumpTo(0);
      //   },
      // ),
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
                        _performSearch();
                      } catch (e) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text('搜索失败，可能是数据丢失')));
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
                        _performSearch();
                      } catch (e) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text('搜索失败，可能是数据丢失')));
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
                        _performSearch();
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
                        _performSearch();
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
                      // try {
                      //   _performSearch();
                      // } catch (e) {
                      //   ScaffoldMessenger.of(
                      //     context,
                      //   ).showSnackBar(SnackBar(content: Text('搜索失败，可能是数据丢失')));
                      // }
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
                        _performSearch();
                      } catch (e) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text('搜索失败，可能是数据丢失')));
                      }
                    },
                  ),
                ),
              ],
            ),

            TabBar(
              tabs: [
                Tab(text: '旧歌'),
                Tab(text: '新歌'),
              ],
            ),
            Expanded(
              child: TabBarView(
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
              page = page - 1;
              // log('$page');
              if (page <= 0) {
                page = 0;
              }
              setState(() {
                oldSongWidget = ListView.builder(
                  itemBuilder: (context, index) =>
                      oldSongWidgetList[page][index],
                  itemCount: oldSongWidgetList[page].length,
                );
                _pageController.text = '${page + 1}';
              });
            },
            icon: Icon(Icons.arrow_back),
          ),
          SizedBox(width: 50, child: TextField(controller: _pageController)),
          IconButton(
            onPressed: () {
              page = page + 1;
              // log('$page');
              if (page >= oldSongWidgetList.length) {
                page = oldSongWidgetList.length;
              }
              setState(() {
                oldSongWidget = ListView.builder(
                  itemBuilder: (context, index) =>
                      oldSongWidgetList[page][index],
                  itemCount: oldSongWidgetList[page].length,
                );
                _pageController.text = '${page + 1}';
              });
            },
            icon: Icon(Icons.arrow_forward),
          ),
        ],
      ),
    );
  }
}

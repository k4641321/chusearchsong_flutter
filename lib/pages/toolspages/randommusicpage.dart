import 'package:flutter/material.dart';
import '../../function/list.dart';
import 'dart:developer';
import '../../function/searchfun/search.dart';

class RandomMusicPage extends StatefulWidget {
  const RandomMusicPage({super.key});
  @override
  State<RandomMusicPage> createState() => _RandomMusicPageState();
}

class _RandomMusicPageState extends State<RandomMusicPage> {
  String? selectedGenre = '-1';
  String? selectedVersion = '-1';
  String? selectedDifficultyDown = '-1';
  String? selectedDifficultyUp = '-1';
  String? selectedifPlay = '-1';
  int? bpmup;
  int? bpmdown;
  int count = 0;
  List<Widget> searchResults = [];
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

  Future<void> _performSearch() async {
    if (!_ready) return;
    String searchTitle = _searchController.text;
    String genre = selectedGenre ?? '-1';
    String version = selectedVersion ?? '-1';
    String difficultyDown = selectedDifficultyDown ?? '-1';
    String difficultyUp = selectedDifficultyUp ?? '-1';
    String ifPlay = selectedifPlay ?? '-1';
    int randomcount;

    randomcount = count;
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
        randomcount,
        0,
      );
      if (!mounted) return;
      List<Widget> results = await search(
        songresultMap: resultsMap,
        context: context,
      );
      if (!mounted) return;
      // 更新状态
      setState(() {
        songResult = results;
      });
    } catch (e) {
      log('搜索错误: $e', name: 'searchpage.dart', level: 1000);
      // 可以显示错误信息给用户
    }
  }

  Widget genreDropdownMenu = DropdownMenu<String>(dropdownMenuEntries: []);
  Widget versionDropdownMenu = DropdownMenu<String>(dropdownMenuEntries: []);
  Future<void> _buildAllDropdownMenus() async {
    Widget genreDropdownMenu1 = await buildGenreDropdownMenu(
      initialSelection: selectedGenre,
      onSelected: (String? value) {
        setState(() {
          selectedGenre = value;
        });
      },
    );
    Widget versionDropdownMenu1 = await buildVersionDropdownMenu(
      initialSelection: selectedVersion,
      onSelected: (String? value) {
        setState(() {
          selectedVersion = value;
        });
      },
    );
    if (!mounted) return;
    setState(() {
      genreDropdownMenu = genreDropdownMenu1;
      versionDropdownMenu = versionDropdownMenu1;
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

  @override
  void initState() {
    super.initState();
    _buildAllDropdownMenus();
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
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () async {
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
                        child: Text(
                          '抽自定义首',
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
                    Expanded(child: TextField(controller: _controller)),
                  ],
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Row(
              children: [
                Expanded(child: genreDropdownMenu),
                Expanded(child: versionDropdownMenu),
                Expanded(
                  child: buildDifficultyDownDropdownMenu(
                    ccontroller: _difficultydown,
                    initialSelection: selectedDifficultyDown,
                    onSelected: (String? value) {
                      setState(() {
                        selectedDifficultyDown = value;
                      });
                    },
                  ),
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
            ),
          ),
          SliverToBoxAdapter(
            child: Row(
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
            ),
          ),
          SliverList.builder(
            itemBuilder: (context, index) => songResult[index],
            itemCount: songResult.length,
          ),
        ],
      ),
    );
  }
}

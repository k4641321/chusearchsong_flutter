import 'package:flutter/material.dart';
import '../../tools/fun.dart';
import '../../tools/list.dart';
import 'dart:developer';
import '../../tools/search.dart';

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

  Future<void> _performSearch() async {
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
      List<Widget> results = await search(
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
        context,
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

  @override
  void initState() {
    super.initState();
    _buildAllDropdownMenus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('随机歌曲'),
        // backgroundColor: const Color.fromARGB(255, 255, 229, 84),
      ),
      body: Scrollbar(
        controller: _scrollController,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
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
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      try {
                        _performSearch();
                      } catch (e) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text('搜索失败，可能是数据丢失')));
                      }
                    },
                    icon: Icon(Icons.search),
                  ),
                ],
              ),
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
              ListView(
                shrinkWrap: true,
                // physics: NeverScrollableScrollPhysics(),
                children: songResult,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

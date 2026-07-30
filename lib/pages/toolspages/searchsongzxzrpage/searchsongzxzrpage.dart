import 'dart:developer';

import 'package:chusearchsong_flutter/function/list.dart'
    show buildDifficultyDownDropdownMenu, buildDifficultyUpDropdownMenu;
// buildIfPlayDropdownMenu;
import 'package:chusearchsong_flutter/function/toolsfun/searchsongzxzrpagefun/searchsongzxzrpagefun.dart';
import 'package:flutter/material.dart';

import '../../../function/toolsfun/searchsongzxzrpagefun/searchfun.dart';

class Searchsongzxzrpage extends StatefulWidget {
  const Searchsongzxzrpage({super.key});

  @override
  State<Searchsongzxzrpage> createState() => _SearchsongzxzrpageState();
}

class _SearchsongzxzrpageState extends State<Searchsongzxzrpage> {
  String? selectedGenre = '-1';
  String? selectedVersion = '-1';
  String? selectedDifficultyDown = '-1';
  String? selectedDifficultyUp = '-1';
  String? selectedifPlay = '-1';
  int? bpmup;
  int? bpmdown;
  List<Widget> searchResults = [];
  // Future result;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _bpmup = TextEditingController();
  final TextEditingController _bpmdown = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  Future<void> _performSearch() async {
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
        true,
        null,
      );
      if (!mounted) return;
      List<Widget> results = await search(
        songresultMap: resultsMap,
        context: context,
      );
      if (!mounted) return;
      // 更新状态
      setState(() {
        searchResults = results;
      });
    } catch (e, strack) {
      log('搜索错误: $e\n$strack', name: 'searchsongszxzrpage.dart', level: 1000);
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

  @override
  void initState() {
    super.initState();
    _buildAllDropdownMenus();
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
      appBar: AppBar(title: Text('最新最热查歌')),
      body: Center(
        child: Scrollbar(
          controller: _scrollController,
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: '搜索...标题，曲师，别名，id，谱师',
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
              SliverToBoxAdapter(
                child: Row(
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
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('搜索失败，可能是数据丢失')),
                            );
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
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('搜索失败，可能是数据丢失')),
                            );
                          }
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

                    // Expanded(
                    //   child: buildIfPlayDropdownMenu(
                    //     initialSelection: selectedifPlay,
                    //     onSelected: (String? value) {
                    //       setState(() {
                    //         selectedifPlay = value;
                    //       });
                    //       try {
                    //         _performSearch();
                    //       } catch (e) {
                    //         ScaffoldMessenger.of(context).showSnackBar(
                    //           SnackBar(content: Text('搜索失败，可能是数据丢失')),
                    //         );
                    //       }
                    //     },
                    //   ),
                    // ),
                  ],
                ),
              ),
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

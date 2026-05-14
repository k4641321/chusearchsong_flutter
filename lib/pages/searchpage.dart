import 'package:flutter/material.dart';
import '../tools/list.dart';
import '../tools/search.dart';
import 'dart:developer';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String? selectedGenre = '-1';
  String? selectedVersion = '-1';
  String? selectedDifficultyDown = '-1';
  String? selectedDifficultyUp = '-1';

  List<Widget> searchResults = [];
  // Future result;
  final TextEditingController _searchController = TextEditingController();

  Future<void> _performSearch() async {
    String searchTitle = _searchController.text;
    String genre = selectedGenre ?? '-1';
    String version = selectedVersion ?? '-1';
    String difficultyDown = selectedDifficultyDown ?? '-1';
    String difficultyUp = selectedDifficultyUp ?? '-1';

    try {
      // 使用 await 调用异步函数
      List<Widget> results = await search(
        searchTitle,
        genre,
        version,
        difficultyDown,
        difficultyUp,
        context,
      );

      // 更新状态
      setState(() {
        searchResults = results;
      });
    } catch (e) {
      log('搜索错误: $e');
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
      body: Center(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(hintText: '搜索...标题，曲师，别名'),
                  ),
                ),

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
            Expanded(child: ListView(children: searchResults)),
          ],
        ),
      ),
    );
  }
}

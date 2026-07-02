import 'dart:developer';
import '../../tools/searchlobbypagefun.dart';
import 'package:flutter/material.dart';
import '../../tools/list.dart';

class SearchLobbyPage extends StatefulWidget {
  const SearchLobbyPage({super.key});

  @override
  State<SearchLobbyPage> createState() => _SearchLobbyPageState();
}

class _SearchLobbyPageState extends State<SearchLobbyPage> {
  List<DropdownMenuEntry> dropdownMenuEntries = [];
  List<Widget> searchResults = [];
  final TextEditingController _controller = TextEditingController();
  String initialSelection = '全部';
  @override
  void initState() {
    super.initState();
    _getdropdownMenuEntries();
  }

  Future<void> _getdropdownMenuEntries() async {
    dropdownMenuEntries = await getlobby();
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('机厅搜索'),
        // backgroundColor: const Color.fromARGB(255, 255, 229, 84),
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(hintText: '数据来源于华立官网'),
                    onChanged: (value) async {
                      try {
                        List<Widget> searchresults = await search(
                          searchResults: searchResults,
                          controller: _controller,
                          initialSelection: initialSelection,
                          context: context,
                        );
                        if (!mounted) return;
                        setState(() {
                          searchResults = searchresults;
                        });
                      } catch (e) {
                        log('错误', name: 'searchlobbypage', level: 1000);
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text('搜索失败，可能数据丢失')));
                      }
                    },
                  ),
                ),

                DropdownMenu(
                  selectOnly: true,
                  initialSelection: initialSelection,
                  onSelected: (value) async {
                    setState(() {
                      initialSelection = value;
                    });
                    try {
                      List<Widget> searchresults = await search(
                        searchResults: searchResults,
                        controller: _controller,
                        initialSelection: initialSelection,
                        context: context,
                      );
                      if (!mounted) return;
                      setState(() {
                        searchResults = searchresults;
                      });
                    } catch (e) {
                      log('错误', name: 'searchlobbypage', level: 1000);
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('搜索失败，可能数据丢失')));
                    }
                  },
                  menuHeight: 300,
                  dropdownMenuEntries: dropdownMenuEntries,
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () async {
                    try {
                      List<Widget> searchresults = await search(
                        searchResults: searchResults,
                        controller: _controller,
                        initialSelection: initialSelection,
                        context: context,
                      );
                      if (!mounted) return;
                      setState(() {
                        searchResults = searchresults;
                      });
                    } catch (e) {
                      log('错误', name: 'searchlobbypage', level: 1000);
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('搜索失败，可能数据丢失')));
                    }
                  },
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

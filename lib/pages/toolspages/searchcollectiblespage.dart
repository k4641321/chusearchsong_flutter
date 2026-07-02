import 'package:flutter/material.dart';
import '../../tools/fun.dart';

class SearchCollectiblesPage extends StatefulWidget {
  const SearchCollectiblesPage({super.key});

  @override
  State<SearchCollectiblesPage> createState() => _SearchCollectiblesState();
}

class _SearchCollectiblesState extends State<SearchCollectiblesPage> {
  final TextEditingController _controller = TextEditingController();
  List<Widget> result = [];
  String initialSelection = 'all';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('收藏品搜索'),
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
                    onChanged: (value) async {
                      List<Widget> result2 = [];
                      result2 = await searchCollectibles(
                        context: context,
                        searchtext: _controller.text,
                        searchtype: initialSelection,
                        isSonginfo: false,
                      );
                      if (!mounted) return;
                      setState(() {
                        result = result2;
                      });
                    },
                  ),
                ),
                DropdownMenu(
                  selectOnly: true,
                  initialSelection: initialSelection,
                  dropdownMenuEntries: [
                    DropdownMenuEntry(value: 'all', label: '全部'),
                    DropdownMenuEntry(value: 'character', label: '角色'),
                    DropdownMenuEntry(value: 'plate', label: '名牌板'),
                    DropdownMenuEntry(value: 'icon', label: '头像'),
                    DropdownMenuEntry(value: 'trophy', label: '称号'),
                  ],
                  onSelected: (value) {
                    setState(() {
                      initialSelection = value ?? 'all';
                    });
                  },
                ),
                IconButton(
                  onPressed: () async {
                    List<Widget> result2 = [];
                    try {
                      result2 = await searchCollectibles(
                        context: context,
                        searchtext: _controller.text,
                        searchtype: initialSelection,
                        isSonginfo: false,
                      );
                      if (!mounted) return;
                      setState(() {
                        result = result2;
                      });
                    } catch (e) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('错误，可能数据不存在，请在关于界面更新数据 $e')),
                      );
                    }
                  },
                  icon: Icon(Icons.search),
                ),
              ],
            ),
            Expanded(child: ListView(children: result)),
          ],
        ),
      ),
    );
  }
}

import 'dart:developer';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import '../tools/list.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

class SearchLobbyPage extends StatefulWidget {
  const SearchLobbyPage({super.key});

  @override
  State<SearchLobbyPage> createState() => _SearchLobbyPageState();
}

class _SearchLobbyPageState extends State<SearchLobbyPage> {
  List<DropdownMenuEntry> dropdownMenuEntries = [];
  List<Widget> searchResults = [];
  final TextEditingController _controller = TextEditingController();
  String? initialSelection;
  @override
  void initState() {
    super.initState();
    _getdropdownMenuEntries();
  }

  Future<void> _getdropdownMenuEntries() async {
    dropdownMenuEntries = await getlobby();
    setState(() {});
  }

  Future<void> _openmap({required Map<String, dynamic> i}) async {
    final String myapp = ' chusearchsong';
    final Uri url = Uri.parse(
      'androidamap://poi?sourceApplication=$myapp&keywords=${i['address']}',
    );
    final Uri url2 = Uri.parse(
      'amapuri://keywordsearch?keywords=${i['address']}&sourceApplication=$myapp',
    );
    final Uri url3 = Uri.parse(
      'amapuri://poi?sourceApplication=$myapp&keywords=${i['address']}',
    );
    try {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('打开高德地图，尝试第一种')));
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
        return;
      }
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('无法打开高德地图，尝试第二种')));
      if (await canLaunchUrl(url2)) {
        await launchUrl(url2);
        return;
      }
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('无法打开高德地图，尝试第三种')));
      if (await canLaunchUrl(url3)) {
        await launchUrl(url3);
        return;
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('无法打开高德地图，我没招了')));
        throw Exception('我没招了');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('无法打开高德地图')));
      log('$e', name: 'searchLobbyPage', level: 1000);
    }
  }

  Future<void> _search() async {
    final dataPath = await getApplicationSupportDirectory();
    String lobbyDataStr = await File(
      '${dataPath.path}/res/location.json',
    ).readAsString();
    final lobbyDataJson = json.decode(lobbyDataStr) as List;
    List searchResults2 = [];
    List<Widget> searchResults3 = [];
    searchResults.clear();
    for (var i in lobbyDataJson) {
      if (i['arcadeName'].toLowerCase().contains(
        _controller.text.toLowerCase(),
      )) {
        searchResults2.add(i);
      }
    }
    // print(searchResults2);
    if (initialSelection == '全部') {
      log('跳过地区筛选');
      for (var i in searchResults2) {
        searchResults3.add(
          InkWell(
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('${i['province']} - ${i['address']}'),
              ),
            ),
            onTap: () => _openmap(i: i),
          ),
        );
      }
    } else {
      for (var i in searchResults2) {
        if (i['province'] == initialSelection) {
          searchResults3.add(
            InkWell(
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('${i['province']} - ${i['address']}'),
                ),
              ),
              onTap: () => _openmap(i: i),
            ),
          );
        }
      }
    }
    // print(searchResults);
    log('搜索完成');
    setState(() {
      searchResults = searchResults3;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('机厅搜索'),
        backgroundColor: const Color.fromARGB(255, 255, 229, 84),
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
                  ),
                ),

                DropdownMenu(
                  selectOnly: true,
                  initialSelection: initialSelection,
                  onSelected: (value) => setState(() {
                    initialSelection = value;
                  }),
                  menuHeight: 300,
                  dropdownMenuEntries: dropdownMenuEntries,
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    try {
                      _search();
                    } catch (e) {
                      log('错误', name: 'searchlobbypage', level: 1000);
                      if (!mounted) return;
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

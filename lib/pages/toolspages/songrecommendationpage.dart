import 'package:flutter/material.dart';
import '../../tools/songrecommendationpagefun.dart';

class SongRecommendationPage extends StatefulWidget {
  const SongRecommendationPage({super.key});

  @override
  State<SongRecommendationPage> createState() => _SongRecommendationPageState();
}

class _SongRecommendationPageState extends State<SongRecommendationPage> {
  Widget oldSongWidget = CircularProgressIndicator();
  Widget newSongWidget = CircularProgressIndicator();

  Future<void> init() async {
    Widget oldSongWidgetresult = await oldSongRecommendation(
      ifYueJi: false,
      context: context,
    );
    setState(() {
      oldSongWidget = oldSongWidgetresult;
    });
  }

  @override
  void didChangeDependencies() {
    init();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('吃分推荐')),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
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
    );
  }
}

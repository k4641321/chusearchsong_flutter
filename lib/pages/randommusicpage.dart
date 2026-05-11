import 'package:flutter/material.dart';
import '../tools/fun.dart';

class RandomMusicPage extends StatefulWidget {
  const RandomMusicPage({super.key});
  @override
  State<RandomMusicPage> createState() => _RandomMusicPageState();
}

class _RandomMusicPageState extends State<RandomMusicPage> {
  Widget songData = Text('待抽取');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('随机音乐'),
        backgroundColor: const Color.fromARGB(255, 255, 229, 84),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () async {
                    Widget widget = await randomSong(context: context);
                    setState(() {
                      songData = widget;
                    });
                  },
                  child: Text('抽一首'),
                ),
              ),
            ],
          ),
          const Divider(),
          Row(
            children: [
              Expanded(
                child: Card(
                  child: Padding(
                    padding: EdgeInsetsGeometry.all(8.0),
                    child: songData,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../tools/fun.dart';

class RandomMusicPage extends StatefulWidget {
  const RandomMusicPage({super.key});
  @override
  State<RandomMusicPage> createState() => _RandomMusicPageState();
}

class _RandomMusicPageState extends State<RandomMusicPage> {
  List<Widget> songResult = [Text('待抽取')];
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('随机音乐'),
        // backgroundColor: const Color.fromARGB(255, 255, 229, 84),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () async {
                        List<Widget> widget = await randomSong(
                          context: context,
                          count: 1,
                        );
                        setState(() {
                          songResult = widget;
                        });
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
                        List<Widget> widget = await randomSong(
                          context: context,
                          count: 3,
                        );
                        setState(() {
                          songResult = widget;
                        });
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
                        int count = 0;
                        try {
                          count = int.parse(_controller.text);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('输入的什么玩意，数字呢')),
                          );
                        }

                        List<Widget> widget = await randomSong(
                          context: context,
                          count: count,
                        );
                        setState(() {
                          songResult = widget;
                        });
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
                children: [Expanded(child: TextField(controller: _controller))],
              ),
              const Divider(),
            ],
          ),
          Expanded(child: ListView(children: songResult)),
        ],
      ),
    );
  }
}

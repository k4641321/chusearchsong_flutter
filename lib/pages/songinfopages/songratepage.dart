import 'package:chusearchsong_flutter/function/songinfofun/songratepagefun.dart';
import 'package:flutter/material.dart';

class Songratepage extends StatefulWidget {
  final int songid;
  final int? index;
  const Songratepage({super.key, required this.songid, this.index});

  @override
  State<Songratepage> createState() => _SongratepageState();
}

class _SongratepageState extends State<Songratepage> {
  Widget body = CircularProgressIndicator();

  Future<void> init() async {
    Widget result = await buildChildren(
      songid: widget.songid,
      index: widget.index,
    );
    setState(() {
      body = result;
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chunirec鸟率')),
      body: body,
    );
  }
}

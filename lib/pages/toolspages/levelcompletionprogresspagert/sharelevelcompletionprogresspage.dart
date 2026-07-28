import 'dart:developer';

import 'package:chusearchsong_flutter/function/toolsfun/levelcompletionprogresspagefun/sharelevelcompletionprogresspagefun.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/rendering.dart';

class Sharelevelcompletionprogresspage extends StatefulWidget {
  final List level;
  final Map<String, dynamic> songsdata;

  const Sharelevelcompletionprogresspage({
    super.key,
    required this.level,
    required this.songsdata,
  });

  @override
  State<Sharelevelcompletionprogresspage> createState() =>
      _SharelevelcompletionprogresspageState();
}

class _SharelevelcompletionprogresspageState
    extends State<Sharelevelcompletionprogresspage> {
  final GlobalKey _globalKey = GlobalKey();
  Widget result = Text('未生成');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('分享等级完成进度')),
      body: Column(
        children: [
          Text('生成时请保证网络通常，资源都来源与网络'),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () async {
                    try {
                      Widget result2 =
                          await returnShareLevelCompletionProgressPageFun(
                            level: widget.level,
                            songsdata: widget.songsdata,
                            context: context,
                          );
                      if (!mounted) return;
                      setState(() {
                        result = result2;
                      });
                    } catch (e, strack) {
                      log('$e\n$strack');
                      if (!mounted) return;
                      setState(() {
                        result = Text('错误：$e\n$strack');
                      });
                    }
                  },
                  child: Text('生成'),
                ),
              ),
              Expanded(
                child: TextButton(onPressed: () {}, child: Text('分享')),
              ),
            ],
          ),
          Expanded(
            child: InteractiveViewer(
              maxScale: 5.0,
              minScale: 0.1,
              constrained: false,
              boundaryMargin: EdgeInsets.all(double.infinity),
              child: RepaintBoundary(key: _globalKey, child: result),
            ),
          ),
        ],
      ),
    );
  }
}

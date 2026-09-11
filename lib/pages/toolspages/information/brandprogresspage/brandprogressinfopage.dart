import 'dart:developer';

import 'package:chusearchsong_flutter/function/toolsfun/brandprogressfun/brandprogressinfofun.dart';
import 'package:chusearchsong_flutter/function/toolsfun/levelcompletionprogresspagefun/sharelevelcompletionprogresspagefun.dart';
import 'package:chusearchsong_flutter/function/toolsfun/viewallgradespagefun.dart';
import 'package:flutter/material.dart';

class Brandprogressinfopage extends StatefulWidget {
  final Map<String, dynamic> brandinfo;
  final Map<String, dynamic> songsData;
  final List playhistory;

  const Brandprogressinfopage({
    super.key,
    required this.brandinfo,
    required this.songsData,
    required this.playhistory,
  });

  @override
  State<Brandprogressinfopage> createState() => _BrandprogressinfopageState();
}

class _BrandprogressinfopageState extends State<Brandprogressinfopage> {
  final ScrollController scrollController = ScrollController();
  String diffname = 'Master';
  int diffindex = 3;
  bool isshow = true;
  List<Widget> item = [];

  Future<void> init() async {
    try {
      List<Widget> result = await buildBrandProgressWidgets(
        songsData: widget.songsData,
        brandinfo: widget.brandinfo,
        playhistory: widget.playhistory,
        diffindex: diffindex,
        isshow: isshow,
        context: context,
      );
      setState(() {
        item = result;
      });
    } catch (e, strack) {
      log('$e\n$strack');
      setState(() {
        item = [Text('错误：$e\n$strack')];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('牌子详情进度')),
      body: Scrollbar(
        controller: scrollController,
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: [
              Center(
                child: Image.network(
                  'https://assets2.lxns.net/chunithm/trophy/${widget.brandinfo['id']}.png',
                  errorBuilder: (context, error, stackTrace) => Text('图片加载失败'),
                ),
              ),
              Text(
                '${widget.brandinfo['name']}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                '${widget.brandinfo['description']}',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        List<Widget> children = [];
                        for (var i
                            in widget
                                .brandinfo['required'][0]['difficulties']) {
                          children.add(
                            ListTile(
                              title: Text(returnDiffName(i)),
                              onTap: () {
                                setState(() {
                                  diffindex = i;
                                  diffname = returnDiffName(i);
                                  init();
                                  Navigator.of(context).pop();
                                });
                              },
                            ),
                          );
                        }
                        showDialog(
                          context: context,
                          builder: (context) => SimpleDialog(
                            title: Text('选择难度'),
                            children: children,
                          ),
                        );
                      },
                      child: Text(
                        diffname,
                        style: TextStyle(
                          color: diffcolor(diffindex: diffindex),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          isshow = !isshow;
                        });
                        init();
                      },
                      child: Text('展示已完成：$isshow'),
                    ),
                  ),
                ],
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => item[index],
                itemCount: item.length,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:math';

import 'package:chusearchsong_flutter/function/toolsfun/chuqinturntablepagefun.dart';
import 'package:flutter/material.dart';

//数学全忘光了，大部分让AI帮忙了
class Chuqinturntablepage extends StatefulWidget {
  const Chuqinturntablepage({super.key});

  @override
  State<Chuqinturntablepage> createState() => _ChuqinturntablepageState();
}

class _ChuqinturntablepageState extends State<Chuqinturntablepage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final ScrollController _scrollController = ScrollController();
  double _currentAngle = 0;
  String result = '未抽取';
  bool _isSpinning = false;

  final List<String> _sliceLabels = [
    '出勤',
    '不出勤',
    '出勤',
    '不出勤',
    '出勤',
    '不出勤',
    '出勤',
    '不出勤',
    '出勤',
    '不出勤',
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );
    _controller.addStatusListener(_onAnimationStatus);
  }

  void _onAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _calcResult();
    }
  }

  void _calcResult() {
    // 归一化角度，去掉多转的圈数
    final normalizedAngle = _currentAngle % (2 * pi);
    // 箭头在底部(pi/2)，反推指向的原始扇形角度
    var selectedAngle = (pi / 2 - normalizedAngle) % (2 * pi);
    if (selectedAngle < 0) selectedAngle += 2 * pi;
    // 每份 pi/5，算出第几格
    final sliceIndex = (selectedAngle / (pi / 5)).floor();
    setState(() {
      result = _sliceLabels[sliceIndex];
      _isSpinning = false;
    });
  }

  void _startSpin() {
    if (_isSpinning) return;
    setState(() {
      _isSpinning = true;
      result = '抽取中...';
    });
    // 随机目标角度（多转几圈看起来更自然）
    final targetAngle =
        _currentAngle + 2 * pi * 5 + Random().nextDouble() * 2 * pi;
    _animation = Tween<double>(
      begin: _currentAngle,
      end: targetAngle,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _animation.addListener(
      () => setState(() => _currentAngle = _animation.value),
    );
    _controller.reset();
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('出勤转盘')),
      body: Scrollbar(
        controller: _scrollController,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              Stack(
                children: [
                  Center(
                    child: Transform.rotate(
                      angle: _currentAngle,
                      child: CustomPaint(
                        size: Size(400, 400), // 画布大小（可选）
                        painter: ChuqingPainter(
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.primaryContainer,
                        ), // 背景层，先画
                      ),
                    ),
                  ),
                  Center(child: Icon(Icons.arrow_downward, size: 50)),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => _startSpin(),
                      child: Text('开抽'),
                    ),
                  ),
                ],
              ),
              Text('结果：$result'),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

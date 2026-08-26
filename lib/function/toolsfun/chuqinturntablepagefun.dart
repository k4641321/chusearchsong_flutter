import 'dart:math';

import 'package:flutter/material.dart';

//数学全忘光了，大部分让AI帮忙了
class ChuqingPainter extends CustomPainter {
  final Color backgroundcolor;
  final Color secondcolor;

  ChuqingPainter(this.backgroundcolor, this.secondcolor);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(center, 150, Paint()..color = backgroundcolor);

    for (double i = 0; i < 10; i = i + pi / 2.5) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: 150),
        i,
        pi / 5,
        true,
        Paint()..color = secondcolor,
      );
    }

    for (var i = 0; i < 10; i++) {
      final startAngle = i * pi / 5;
      final midAngle = startAngle + pi / 10;
      final r = 100; // 文字到圆心的距离

      String text = (i % 2 == 0) ? '不出勤' : '出勤';

      final textPainter = TextPainter(
        text: TextSpan(
          text: text,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      canvas.save();
      // 把原点移到文字该在的位置
      canvas.translate(
        center.dx + cos(midAngle) * r,
        center.dy + sin(midAngle) * r,
      );
      // 旋转文字，让文字沿径向（从圆心向外）排列
      canvas.rotate(midAngle + pi / 2); // +pi/2 让文字头朝外
      // 居中绘制（原点已经是文字位置了）
      textPainter.paint(
        canvas,
        Offset(-textPainter.width / 2, -textPainter.height / 2),
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant ChuqingPainter oldDelegate) {
    return true; // 需要重绘时返回 true
  }
}

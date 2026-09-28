import 'package:flutter/material.dart';

class BackgroundProvider extends InheritedWidget {
  final ImageProvider? backgroundImage;
  final int opacity;

  const BackgroundProvider({
    super.key,
    required this.backgroundImage,
    required this.opacity,
    required super.child,
  });

  static BackgroundProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<BackgroundProvider>();
  }

  @override
  bool updateShouldNotify(covariant BackgroundProvider oldWidget) =>
      backgroundImage != oldWidget.backgroundImage ||
      opacity != oldWidget.opacity;
}
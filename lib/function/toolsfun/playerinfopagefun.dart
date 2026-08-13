import 'package:flutter/material.dart';

Color returnRatingColor(double rating) => switch (rating) {
  < 4 => Colors.green,
  < 7 => Colors.orange,
  < 10 => Colors.red,
  < 12 => Colors.deepPurple,
  < 13.25 => Colors.deepOrange,
  < 14.5 => Colors.grey,
  < 15.25 => Colors.yellow,
  < 16.00 => Colors.amber,
  < 17 => Colors.purple,
  > 17 => Colors.purpleAccent,
  _ => Colors.white,
};

Color returnRatingBackgroundColor(double rating) => switch (rating) {
  < 4 => Colors.green.withAlpha(30),
  < 7 => Colors.orange.withAlpha(30),
  < 10 => Colors.red.withAlpha(30),
  < 12 => Colors.deepPurple.withAlpha(30),
  < 13.25 => Colors.deepOrange.withAlpha(30),
  < 14.5 => Colors.grey.withAlpha(30),
  < 15.25 => Colors.yellow.withAlpha(30),
  < 16.00 => Colors.amber.withAlpha(30),
  < 17 => Colors.purple.withAlpha(30),
  > 17 => Colors.purpleAccent.withAlpha(30),
  _ => Colors.white.withAlpha(30),
};

Color returnTrophyBackgroundColor(String? color) => switch (color) {
  'normal' => Colors.blueGrey.withAlpha(30),
  'copper' => Colors.deepOrange.withAlpha(30),
  'silver' => Colors.grey.withAlpha(30),
  'gold' => Colors.yellow.withAlpha(30),
  'platina' => Colors.amber.withAlpha(30),
  'rainbow' => Colors.purpleAccent.withAlpha(30),
  null => Colors.white.withAlpha(30),
  _ => Colors.white.withAlpha(30),
};

Color returnTrophyColor(String? color) => switch (color) {
  'normal' => Colors.white,
  'copper' => Colors.deepOrange,
  'silver' => Colors.grey,
  'gold' => Colors.yellow,
  'platina' => Colors.amber,
  'rainbow' => Colors.purpleAccent,
  null => Colors.white,
  _ => Colors.white,
};

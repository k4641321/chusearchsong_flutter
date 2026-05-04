import 'package:flutter/material.dart';

class Info extends StatelessWidget {
  const Info({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text('作者：k4641321', style: TextStyle(fontSize: 25)),
          Text(
            'Github：https://github.com/k4641321/chusearchsong_flutter',
            style: TextStyle(fontSize: 25),
          ),
          Text('还没写完，下次再写'),
        ],
      ),
    );
  }
}

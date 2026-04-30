import 'package:flutter/material.dart';
import 'search.dart';

class Info extends StatelessWidget {
  const Info({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text('作者：k4641321', style: TextStyle(fontSize: 25)),
          TextButton(
            onPressed: () => search('B', '', 10000),
            child: Text('搜索'),
          ),
        ],
      ),
    );
  }
}

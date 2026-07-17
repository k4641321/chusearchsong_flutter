import 'package:flutter/material.dart';
import '../../function/list.dart';

//Rating颜色
class RatingColor extends StatelessWidget {
  const RatingColor({super.key});

  @override
  Widget build(BuildContext context) {
    final ScrollController controller = ScrollController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rating Color'),
        // backgroundColor: const Color.fromARGB(255, 255, 229, 84),
      ),
      body: Scrollbar(
        controller: controller,
        child: SingleChildScrollView(
          controller: controller,
          child: Center(
            child: DataTable(
              columns: [
                DataColumn(label: Text('颜色')),
                DataColumn(label: Text('Rating值')),
              ],
              rows: ratingColor(),
            ),
          ),
        ),
      ),
    );
  }
}

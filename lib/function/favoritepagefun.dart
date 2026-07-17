import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';

Future<void> exportFavoriteSong() async {
  try {
    final path = await getApplicationSupportDirectory();
    final filepath = '${path.path}/files/favorite.json';
    final favoriteJsonStr = File(filepath).readAsStringSync();
    final Uint8List dataBytes = utf8.encode(favoriteJsonStr);
    String? outputPath = await FilePicker.saveFile(
      dialogTitle: '请选择收藏文件保存位置',
      fileName: 'favorite.json', // 默认文件名
      type: FileType.custom,
      bytes: dataBytes,
      allowedExtensions: ['json'],
    );

    if (outputPath == null) {
      log('取消导出');
      return;
    }

    final outputFile = File(outputPath);
    await outputFile.writeAsString(favoriteJsonStr);
  } catch (e) {
    log('$e', name: 'favoritepagefun.dart', level: 1000);
    throw Exception('导出收藏失败');
  }
}

Future<void> importFavoriteSong() async {
  final path = await getApplicationSupportDirectory();
  final filepath = '${path.path}/files/favorite.json';

  try {
    FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    if (result == null || result.files.isEmpty) {
      log('取消选择');
      return;
    }
    final filePath = result.files.single.path;
    if (filePath == null) {
      throw Exception('文件路径为空');
    }
    final file = File(filePath);
    final String content = await file.readAsString();
    try {
      List json = jsonDecode(content);
      File(filepath).writeAsBytesSync(utf8.encode(jsonEncode(json)));
    } catch (e) {
      throw Exception('文件格式错误');
    }
  } catch (e) {
    log('$e', name: 'favoritepagefun.dart', level: 1000);
    throw Exception('导入收藏失败');
  }
}

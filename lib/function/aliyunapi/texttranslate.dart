import 'dart:convert';
import 'dart:math';

import 'package:chusearchsong_flutter/function/fun.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

//算你马，还是AI写的快

/// 阿里云机器翻译 API 调用
///
/// 需要先到阿里云控制台获取 AccessKeyId 和 AccessKeySecret
/// 开通机器翻译服务: https://www.aliyun.com/product/ai/base_alimt
class AliTextTranslate {
  late final String accessKeyId;
  late final String accessKeySecret;

  // 私有构造函数，外部不能直接 new
  AliTextTranslate._();

  // 静态工厂方法：自动调用 _init 后返回实例
  static Future<AliTextTranslate> create() async {
    final instance = AliTextTranslate._();
    await instance._init();
    return instance;
  }

  Future<void> _init() async {
    final config = await loadConfig();
    accessKeyId = config['texttranslate']?['accessKeyId'] ?? '';
    accessKeySecret = config['texttranslate']?['accessKeySecret'] ?? '';
  }

  /// [accessKeyId] 阿里云 AccessKey ID
  /// [accessKeySecret] 阿里云 AccessKey Secret

  /// 翻译文本
  ///
  /// [text] 待翻译的文本
  /// [sourceLang] 源语言代码，如 'zh'（中文）、'en'（英文）、'ja'（日文）等
  /// [targetLang] 目标语言代码
  /// [formatType] 文本格式，'text' 或 'html'，默认 'text'
  ///
  /// 返回翻译后的文本
  Future<String> translate({
    required String text,
    String formatType = 'text',
    String scene = 'general',
  }) async {
    const endpoint = 'mt.aliyuncs.com';
    final params = {
      'FormatType': formatType,
      'SourceLanguage': 'auto',
      'TargetLanguage': 'zh',
      'SourceText': text,
      'Scene': scene,
      'Action': 'TranslateGeneral',
      'Version': '2018-10-12',
      'AccessKeyId': accessKeyId,
      'SignatureMethod': 'HMAC-SHA1',
      'Timestamp': _formatTimestamp(DateTime.now().toUtc()),
      'SignatureVersion': '1.0',
      'SignatureNonce': _generateNonce(),
      'Format': 'JSON',
    };

    // 生成签名
    final signature = _generateSignature(params, 'POST');
    params['Signature'] = signature;

    final uri = Uri.https(endpoint, '/');
    final response = await http.post(uri, body: params);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json['Code'] == '200') {
        return json['Data']['Translated'];
      } else {
        throw AliyunApiException(
          code: json['Code'] ?? 'UNKNOWN',
          message: json['Message'] ?? '翻译失败',
        );
      }
    } else {
      throw AliyunApiException(
        code: 'HTTP_${response.statusCode}',
        message: '请求失败: ${response.statusCode} - ${response.body}',
      );
    }
  }

  /// 生成阿里云 API V1 签名
  String _generateSignature(Map<String, String> params, String httpMethod) {
    // 1. 按参数名排序
    final sortedKeys = params.keys.toList()..sort();
    // 2. 拼接 canonicalized query string
    final canonicalizedQuery = sortedKeys
        .map((key) => '${_percentEncode(key)}=${_percentEncode(params[key]!)}')
        .join('&');

    // 3. 构造待签名字符串
    final stringToSign =
        '$httpMethod&${_percentEncode('/')}&${_percentEncode(canonicalizedQuery)}';

    // 4. HMAC-SHA1 签名
    final key = utf8.encode('$accessKeySecret&');
    final message = utf8.encode(stringToSign);
    final hmacSha1 = Hmac(sha1, key);
    final digest = hmacSha1.convert(message);

    return base64Encode(digest.bytes);
  }

  /// 百分比编码（阿里云特殊规则）
  String _percentEncode(String value) {
    final encoded = Uri.encodeComponent(value);
    return encoded
        .replaceAll('+', '%20')
        .replaceAll('*', '%2A')
        .replaceAll('%7E', '~');
  }

  /// 格式化时间戳为 ISO 8601 格式
  String _formatTimestamp(DateTime dt) {
    return DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(dt);
  }

  /// 生成随机数作为 Nonce
  String _generateNonce() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    return base64Encode(bytes);
  }
}

/// 阿里云 API 异常
class AliyunApiException implements Exception {
  final String code;
  final String message;

  const AliyunApiException({required this.code, required this.message});

  @override
  String toString() => 'AliyunApiException($code): $message';
}

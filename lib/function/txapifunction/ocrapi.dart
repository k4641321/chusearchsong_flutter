// 腾讯云API签名v3实现示例
// 本代码基于腾讯云API签名v3文档实现: https://cloud.tencent.com/document/product/213/30654
// 请严格按照文档说明使用，不建议随意修改签名相关代码
import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

void main() async {
  // 密钥信息从环境变量读取，需要提前在环境变量中设置 TENCENTCLOUD_SECRET_ID 和 TENCENTCLOUD_SECRET_KEY
  // 使用环境变量方式可以避免密钥硬编码在代码中，提高安全性
  // 生产环境建议使用更安全的密钥管理方案，如密钥管理系统(KMS)、容器密钥注入等
  // 请参见：https://cloud.tencent.com/document/product/1278/85305
  // 密钥可前往官网控制台 https://console.cloud.tencent.com/cam/capi 进行获取
  final tencentSecretId = Platform.environment['TENCENTCLOUD_SECRET_ID'];
  final tencentSecretKey = Platform.environment['TENCENTCLOUD_SECRET_KEY'];
  final token = '';

  final service = 'ocr';
  final host = 'ocr.tencentcloudapi.com';
  final endpoint = 'https://$host';
  final region = 'ap-guangzhou';
  final action = 'GeneralBasicOCR';
  final version = '2018-11-19';
  final algorithm = 'TC3-HMAC-SHA256';
  final timestamp = (DateTime.now().millisecondsSinceEpoch / 1000).toInt();
  final date = DateFormat(
    'yyyy-MM-dd',
  ).format(DateTime.fromMillisecondsSinceEpoch(timestamp * 1000, isUtc: true));

  // ************* 步骤 1：拼接规范请求串 *************
  final httpRequestMethod = 'POST';
  final canonicalUri = '/';
  final canonicalQuerystring = '';
  final ct = 'application/json; charset=utf-8';
  final payload = "{\"ImageBase64\":\"\"}";
  final canonicalHeaders =
      'content-type:$ct\nhost:$host\nx-tc-action:${action.toLowerCase()}\n';
  final signedHeaders = 'content-type;host;x-tc-action';
  final hashedRequestPayload = sha256.convert(utf8.encode(payload));
  final canonicalRequest =
      '''
$httpRequestMethod
$canonicalUri
$canonicalQuerystring
$canonicalHeaders
$signedHeaders
$hashedRequestPayload''';
  print(canonicalRequest);

  // ************* 步骤 2：拼接待签名字符串 *************
  final credentialScope = '$date/$service/tc3_request';
  final hashedCanonicalRequest = sha256.convert(utf8.encode(canonicalRequest));
  final stringToSign =
      '''
$algorithm
$timestamp
$credentialScope
$hashedCanonicalRequest''';
  print(stringToSign);

  // ************* 步骤 3：计算签名 *************
  List<int> sign(List<int> key, String msg) {
    final hmacSha256 = Hmac(sha256, key);
    return hmacSha256.convert(utf8.encode(msg)).bytes;
  }

  final secretDate = sign(utf8.encode('TC3$tencentSecretKey'), date);
  final secretService = sign(secretDate, service);
  final secretSigning = sign(secretService, 'tc3_request');
  final signature = Hmac(
    sha256,
    secretSigning,
  ).convert(utf8.encode(stringToSign)).toString();
  print(signature);

  // ************* 步骤 4：拼接 Authorization *************
  final authorization =
      '$algorithm Credential=$tencentSecretId/$credentialScope, SignedHeaders=$signedHeaders, Signature=$signature';
  print(authorization);

  // ************* 步骤 5：构造并发起请求 *************
  final response = await http.post(
    Uri.parse(endpoint),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Authorization': authorization,
      'X-TC-Action': action,
      'X-TC-Version': version,
      'X-TC-Region': region,
      'X-TC-Timestamp': timestamp.toString(),
      'X-TC-Token': token.toString(),
    },
    body: payload,
  );
  print(json.decode(utf8.decode(response.bodyBytes)));
}

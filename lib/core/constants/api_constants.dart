import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static String get baseUrl => dotenv.env['SERVER_IP'] ?? 'https://sface.app';
  static String get awsIp =>
      dotenv.env['AWS_IP'] ?? 'https://d37j40e2wj9q14.cloudfront.net/';
  static String get resizeCdn =>
      dotenv.env['RESIZE_CDN'] ?? 'https://d4cjy5b5pv1mr.cloudfront.net/';

  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 15);

  // Photogoods Endpoints
  static String photogoodsSearchEndpoint(String query) =>
      '/v1/photogoods/search/$query';

  static String photogoodsDetailEndpoint(int feedsIdx) =>
      '/v1/photogoods/$feedsIdx';

  // Kiosk Endpoints
  static const String kioskPhotosEndpoint = '/v1/kiosk/photosNew';

  // Coupon Endpoints
  static const String couponVerifyEndpoint = '/v1/coupon/client/verify';
  static const String couponUseEndpoint = '/v1/coupon/client/use';
}

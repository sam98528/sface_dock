import 'dart:convert';

/// QR 코드 암호화/복호화 유틸리티 클래스
class QREncryption {
  static const String _prefix = 'SFACE_';
  static const int _caesarShift = 13;

  /// feedIdx를 암호화하여 QR 코드용 데이터 생성
  static String encryptFeedIdx(int feedIdx) {
    final originalData = feedIdx.toString();
    final caesarEncrypted = _caesarCipher(originalData, _caesarShift);
    final base64Encoded = base64Encode(utf8.encode(caesarEncrypted));
    return '$_prefix$base64Encoded';
  }

  /// QR 코드 데이터를 복호화하여 feedIdx 추출
  static int? decryptToFeedIdx(String encryptedData) {
    try {
      if (!encryptedData.startsWith(_prefix)) return null;
      final dataWithoutPrefix = encryptedData.substring(_prefix.length);
      final base64Decoded = utf8.decode(base64Decode(dataWithoutPrefix));
      final caesarDecrypted = _caesarCipher(base64Decoded, -_caesarShift);
      return int.parse(caesarDecrypted);
    } catch (e) {
      return null;
    }
  }

  /// 시저 암호 적용/복호화
  static String _caesarCipher(String text, int shift) {
    final result = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      final char = text[i];
      if (char.codeUnitAt(0) >= 48 && char.codeUnitAt(0) <= 57) {
        final shifted = ((char.codeUnitAt(0) - 48 + shift) % 10);
        final finalShift = shifted < 0 ? shifted + 10 : shifted;
        result.writeCharCode(finalShift + 48);
      } else {
        result.write(char);
      }
    }
    return result.toString();
  }

  /// QR 코드 데이터가 유효한 SFACE QR인지 확인
  static bool isValidSFACEQR(String data) {
    return data.startsWith(_prefix);
  }
}

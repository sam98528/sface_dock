/// 1cut_vertical layout constants (1200x1800 canvas)
/// 미리보기(다이얼로그, 장바구니)와 최종 인쇄 합성 모두 이 값을 사용.
class LayoutConstants {
  LayoutConstants._();

  static const int canvasW = 1200;
  static const int canvasH = 1800;
  static const int slotLeft = 51;
  static const int slotTop = 132;
  static const int slotW = 1098;
  static const int slotH = 1210;

  // Normalized fractions for UI positioning (0.0 ~ 1.0)
  static const double slotLeftFrac = slotLeft / canvasW;
  static const double slotTopFrac = slotTop / canvasH;
  static const double slotWFrac = slotW / canvasW;
  static const double slotHFrac = slotH / canvasH;
  static const double slotRightFrac = 1.0 - slotLeftFrac - slotWFrac;
  static const double slotBottomFrac = 1.0 - slotTopFrac - slotHFrac;

  /// Canvas aspect ratio (width / height)
  static const double canvasAspect = canvasW / canvasH;
}

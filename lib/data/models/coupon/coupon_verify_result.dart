class CouponVerifyResult {
  final bool valid;
  final String? message;
  final String? couponName;
  final String? couponDiscountType; // 'free' | 'won'
  final int? couponDiscountPrice; // nullable, won 타입일 때만 사용
  final String? couponAvailableStore;
  final String? couponCode;

  const CouponVerifyResult({
    required this.valid,
    this.message,
    this.couponName,
    this.couponDiscountType,
    this.couponDiscountPrice,
    this.couponAvailableStore,
    this.couponCode,
  });

  factory CouponVerifyResult.fromVerifyResponse(
    Map<String, dynamic> json,
    String code,
  ) {
    final valid = json['valid'] as bool? ?? false;
    final data = json['data'] as Map<String, dynamic>?;

    return CouponVerifyResult(
      valid: valid,
      message: json['message'] as String?,
      couponName: data?['coupon_name'] as String?,
      couponDiscountType: data?['coupon_discount_type'] as String?,
      couponDiscountPrice: data?['coupon_discount_price'] as int?,
      couponAvailableStore: data?['coupon_available_store'] as String?,
      couponCode: code,
    );
  }

  factory CouponVerifyResult.invalid(String message) {
    return CouponVerifyResult(valid: false, message: message);
  }
}

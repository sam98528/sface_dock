import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/cart/cart_item.dart';
import '../../data/models/kiosk/kiosk_photo.dart';

/// 적용된 쿠폰 하나를 나타내는 모델
class AppliedCoupon {
  final String code;
  final String name;
  final String discountType; // 'free' | 'won'
  final int? discountPrice; // 'won' 타입일 때 할인 금액 (nullable)
  final int discountAmount; // 실제 계산된 할인 금액

  const AppliedCoupon({
    required this.code,
    required this.name,
    required this.discountType,
    this.discountPrice,
    this.discountAmount = 0,
  });

  AppliedCoupon copyWith({int? discountAmount}) {
    return AppliedCoupon(
      code: code,
      name: name,
      discountType: discountType,
      discountPrice: discountPrice,
      discountAmount: discountAmount ?? this.discountAmount,
    );
  }
}

class CartState {
  final List<CartItem> items;
  final bool isLoading;
  final List<AppliedCoupon> appliedCoupons;

  const CartState({
    this.items = const [],
    this.isLoading = false,
    this.appliedCoupons = const [],
  });

  CartState copyWith({
    List<CartItem>? items,
    bool? isLoading,
    List<AppliedCoupon>? appliedCoupons,
  }) {
    return CartState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      appliedCoupons: appliedCoupons ?? this.appliedCoupons,
    );
  }

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  int get totalPrice =>
      items.fold(0, (sum, item) => sum + (item.price * item.quantity));

  int get totalCouponDiscount =>
      appliedCoupons.fold(0, (sum, c) => sum + c.discountAmount);

  int get finalPrice {
    final result = totalPrice - totalCouponDiscount;
    return result < 0 ? 0 : result;
  }

  bool get hasCoupon => appliedCoupons.isNotEmpty;

  int get couponCount => appliedCoupons.length;

  bool isCouponApplied(String code) =>
      appliedCoupons.any((c) => c.code == code);

  int get uniqueItems => items.length;
}

class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(const CartState());

  void addItem(KioskPhoto photoData, int quantity, int price) {
    final feedsIdx = int.tryParse(photoData.postId) ?? 0;
    final existingItemIndex = state.items.indexWhere(
      (item) => item.feedsIdx == feedsIdx,
    );

    if (existingItemIndex != -1) {
      final existingItem = state.items[existingItemIndex];
      final newQuantity = existingItem.quantity + quantity;
      final finalQuantity = newQuantity > 5 ? 5 : newQuantity;

      final updatedItems = List<CartItem>.from(state.items);
      updatedItems[existingItemIndex] = existingItem.copyWith(
        quantity: finalQuantity,
      );

      state = state.copyWith(items: updatedItems);
    } else {
      final newItem = CartItem(
        feedsIdx: feedsIdx,
        quantity: quantity,
        price: price,
        photoData: photoData,
      );

      state = state.copyWith(items: [...state.items, newItem]);
    }
    _recalculateCouponDiscounts();
  }

  void removeItem(int feedsIdx) {
    final updatedItems = state.items
        .where((item) => item.feedsIdx != feedsIdx)
        .toList();

    state = state.copyWith(items: updatedItems);
    _recalculateCouponDiscounts();
  }

  void updateQuantity(int feedsIdx, int newQuantity) {
    if (newQuantity <= 0) {
      removeItem(feedsIdx);
      return;
    }

    if (newQuantity > 5) {
      newQuantity = 5;
    }

    final updatedItems = state.items.map((item) {
      if (item.feedsIdx == feedsIdx) {
        return item.copyWith(quantity: newQuantity);
      }
      return item;
    }).toList();

    state = state.copyWith(items: updatedItems);
    _recalculateCouponDiscounts();
  }

  /// 새 쿠폰의 예상 할인 금액 계산 (적용 전 미리보기)
  int estimateCouponDiscount(String discountType) {
    if (state.items.isEmpty) return 0;
    if (discountType == 'free') {
      return state.items.first.price;
    }
    return 0;
  }

  /// 쿠폰 추가 (중복 방지: 같은 코드는 추가 불가)
  /// 반환: true = 성공, false = 이미 등록된 쿠폰
  bool applyCoupon(String code, String name, String discountType, {int? discountPrice}) {
    if (state.isCouponApplied(code)) {
      return false; // 중복
    }

    final newCoupon = AppliedCoupon(
      code: code,
      name: name,
      discountType: discountType,
      discountPrice: discountPrice,
    );

    state = state.copyWith(
      appliedCoupons: [...state.appliedCoupons, newCoupon],
    );
    _recalculateCouponDiscounts();
    return true;
  }

  /// 특정 쿠폰 제거
  void removeCoupon(String code) {
    final updated = state.appliedCoupons
        .where((c) => c.code != code)
        .toList();
    state = state.copyWith(appliedCoupons: updated);
  }

  /// 모든 쿠폰 제거
  void removeAllCoupons() {
    state = state.copyWith(appliedCoupons: []);
  }

  void _recalculateCouponDiscounts() {
    if (state.appliedCoupons.isEmpty || state.items.isEmpty) {
      if (state.totalCouponDiscount != 0) {
        // 할인 금액 모두 0으로 리셋
        final reset = state.appliedCoupons
            .map((c) => c.copyWith(discountAmount: 0))
            .toList();
        state = state.copyWith(appliedCoupons: reset);
      }
      return;
    }

    // 각 쿠폰별 할인 금액 계산
    final updated = <AppliedCoupon>[];
    for (final coupon in state.appliedCoupons) {
      int discount = 0;
      if (coupon.discountType == 'free') {
        // free 타입: 장바구니 전체 무료 (totalPrice 전액 할인)
        discount = state.totalPrice;
      } else if (coupon.discountType == 'won' && coupon.discountPrice != null) {
        // won 타입: discountPrice 만큼 할인 (단, totalPrice를 초과할 수 없음)
        discount = coupon.discountPrice! > state.totalPrice
            ? state.totalPrice
            : coupon.discountPrice!;
      }
      updated.add(coupon.copyWith(discountAmount: discount));
    }

    state = state.copyWith(appliedCoupons: updated);
  }

  void clearCart() {
    state = const CartState();
  }

  CartItem? getItem(int feedsIdx) {
    try {
      return state.items.firstWhere((item) => item.feedsIdx == feedsIdx);
    } catch (e) {
      return null;
    }
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier();
});

// 편의 Provider들
final cartItemsProvider = Provider<List<CartItem>>((ref) {
  return ref.watch(cartProvider).items;
});

final cartTotalItemsProvider = Provider<int>((ref) {
  return ref.watch(cartProvider).totalItems;
});

final cartTotalPriceProvider = Provider<int>((ref) {
  return ref.watch(cartProvider).totalPrice;
});

final cartUniqueItemsProvider = Provider<int>((ref) {
  return ref.watch(cartProvider).uniqueItems;
});

final cartFinalPriceProvider = Provider<int>((ref) {
  return ref.watch(cartProvider).finalPrice;
});

final cartCouponsProvider = Provider<List<AppliedCoupon>>((ref) {
  return ref.watch(cartProvider).appliedCoupons;
});

final cartCouponCountProvider = Provider<int>((ref) {
  return ref.watch(cartProvider).couponCount;
});

final cartTotalDiscountProvider = Provider<int>((ref) {
  return ref.watch(cartProvider).totalCouponDiscount;
});

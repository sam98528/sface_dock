import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/cart/cart_item.dart';
import '../../data/models/photogoods/photo_detail.dart';

class CartState {
  final List<CartItem> items;
  final bool isLoading;

  const CartState({this.items = const [], this.isLoading = false});

  CartState copyWith({List<CartItem>? items, bool? isLoading}) {
    return CartState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  int get totalPrice =>
      items.fold(0, (sum, item) => sum + (item.price * item.quantity));

  int get uniqueItems => items.length;
}

class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(const CartState());

  void addItem(PhotoDetail photoData, int quantity) {
    final existingItemIndex = state.items.indexWhere(
      (item) => item.feedsIdx == photoData.feedsIdx,
    );

    if (existingItemIndex != -1) {
      // 기존 아이템이 있으면 수량 증가
      final existingItem = state.items[existingItemIndex];
      final newQuantity = existingItem.quantity + quantity;

      // 최대 5장 제한
      final finalQuantity = newQuantity > 5 ? 5 : newQuantity;

      final updatedItems = List<CartItem>.from(state.items);
      updatedItems[existingItemIndex] = existingItem.copyWith(
        quantity: finalQuantity,
      );

      state = state.copyWith(items: updatedItems);
    } else {
      // 새 아이템 추가
      final newItem = CartItem(
        feedsIdx: photoData.feedsIdx,
        quantity: quantity,
        price: photoData.feedsPrice,
        photoData: photoData,
      );

      state = state.copyWith(items: [...state.items, newItem]);
    }
  }

  void removeItem(int feedsIdx) {
    final updatedItems = state.items
        .where((item) => item.feedsIdx != feedsIdx)
        .toList();

    state = state.copyWith(items: updatedItems);
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

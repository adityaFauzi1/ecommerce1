import 'product_model.dart';

class CartItem {
  final Product product;
  int quantity;
  Map<String, dynamic>? extras; // ✅ tambahan untuk menu tambahan (level, topping, drink)

  CartItem({required this.product, this.quantity = 1, this.extras});

  double get totalPrice => product.price * quantity;
}

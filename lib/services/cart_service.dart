import '../models/cart_item.dart';
import '../models/product_model.dart';

class CartService {
  static final CartService _instance = CartService._internal();

  factory CartService() => _instance;

  CartService._internal();

  final List<CartItem> _cart = [];

  List<CartItem> get cart => _cart;

  // ✅ Sekarang bisa menerima 'extras' untuk makanan
  void addToCart(Product product, {Map<String, dynamic>? extras}) {
    final index = _cart.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      _cart[index].quantity++;
    } else {
      _cart.add(CartItem(product: product, extras: extras));
    }
  }

  void removeFromCart(Product product) {
    _cart.removeWhere((item) => item.product.id == product.id);
  }

  void increaseQuantity(Product product) {
    final item = _cart.firstWhere((item) => item.product.id == product.id);
    item.quantity++;
  }

  void decreaseQuantity(Product product) {
    final item = _cart.firstWhere((item) => item.product.id == product.id);
    if (item.quantity > 1) {
      item.quantity--;
    } else {
      removeFromCart(product);
    }
  }

  void clearCart() {
    _cart.clear();
  }
}

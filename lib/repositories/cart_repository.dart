import 'package:southsea_cinema/models/cart_item.dart';
import 'package:southsea_cinema/models/movie.dart';

class CartRepository {
  CartRepository._internal();

  static final CartRepository instance = CartRepository._internal();

  final List<CartItem> _items = [];

  List<CartItem> getItems() {
    return List<CartItem>.unmodifiable(_items);
  }

  void addItem(Movie movie, int quantity) {
    final index = _items.indexWhere(
      (item) => item.movie.id == movie.id,
    );

    if (index >= 0) {
      final existingItem = _items[index];

      _items[index] = CartItem(
        movie: movie,
        quantity: existingItem.quantity + quantity,
      );
    } else {
      _items.add(
        CartItem(
          movie: movie,
          quantity: quantity,
        ),
      );
    }
  }

  void removeItem(Movie movie) {
    _items.removeWhere(
      (item) => item.movie.id == movie.id,
    );
  }
}

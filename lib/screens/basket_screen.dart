import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/models/cart_item.dart';
import 'package:southsea_cinema/repositories/cart_repository.dart';

class BasketScreen extends StatefulWidget {
  const BasketScreen({super.key});

  @override
  State<BasketScreen> createState() {
    return _BasketScreenState();
  }
}

class _BasketScreenState extends State<BasketScreen> {
  String _confirmationMessage = '';

  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.shopping_basket_outlined,
              size: 64,
              color: cinemaFontMuted,
            ),
            SizedBox(height: 16),
            Text(
              'Your basket is empty.',
              style: TextStyle(
                color: cinemaFontWhite,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Select a movie and add tickets to your basket.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: cinemaFontMuted,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasketList(List<CartItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Basket',
          style: TextStyle(
            color: cinemaFontWhite,
            fontSize: 24,
          ),
        ),
        const SizedBox(height: 16),
        for (final item in items)
          Card(
            color: cinemaSurface,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.movie.title,
                    style: const TextStyle(
                      color: cinemaFontWhite,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tickets: ${item.quantity}',
                    style: const TextStyle(
                      color: cinemaFontMuted,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Price per ticket: ${item.movie.formattedPrice}',
                    style: const TextStyle(
                      color: cinemaFontMuted,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Subtotal: £${item.lineTotal.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: cinemaFontWhite,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final CartRepository cart = CartRepository.instance;
    final List<CartItem> items = cart.getItems();

    final Widget content;

    if (items.isEmpty) {
      if (_confirmationMessage.isNotEmpty) {
        content = Column(
          children: [
            _buildEmptyState(),
            Text(_confirmationMessage),
          ],
        );
      } else {
        content = _buildEmptyState();
      }
    } else {
      content = _buildBasketList(items);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: content,
      ),
    );
  }
}

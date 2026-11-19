import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/repositories/cart_repository.dart';
import 'package:southsea_cinema/screens/basket_screen.dart';

void main() {
  setUp(() {
    CartRepository.instance.clear();
  });

  testWidgets('BasketScreen displays empty message when basket has no items', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: BasketScreen()),
    );

    expect(find.text('Your basket is empty.'), findsOneWidget);
    expect(find.text('BUY TICKETS'), findsNothing);
  });
}

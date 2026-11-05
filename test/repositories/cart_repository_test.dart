import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/models/movie.dart';
import 'package:southsea_cinema/repositories/cart_repository.dart';

void main() {
  final cart = CartRepository.instance;

  const movie = Movie(
    id: 'test-movie',
    title: 'Test Movie',
    genre: 'Drama',
    synopsis: 'Testing.',
    ageRating: '12A',
    runtime: '120 minutes',
    screeningDate: '05 November 2026',
    screeningTime: '18:00',
    ticketPrice: 6,
    posterImagePath: 'assets/images/test_movie.jpg',
  );

  setUp(() {
    cart.clear();
  });

  test('addItem adds tickets to the basket', () {
    cart.addItem(movie, 2);

    final items = cart.getItems();

    expect(items.length, 1);
    expect(items.first.movie.id, movie.id);
    expect(items.first.quantity, 2);
  });
}

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

  const secondMovie = Movie(
    id: 'second-test-movie',
    title: 'Second Test Movie',
    genre: 'Comedy',
    synopsis: 'Testing.',
    ageRating: 'PG',
    runtime: '90 minutes',
    screeningDate: '06 November 2026',
    screeningTime: '19:00',
    ticketPrice: 8,
    posterImagePath: 'assets/images/second_test_movie.jpg',
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

  test('addItem combines quantities for the same movie', () {
    cart.addItem(movie, 2);
    cart.addItem(movie, 3);

    final items = cart.getItems();

    expect(items.length, 1);
    expect(items.first.quantity, 5);
  });

  test('removeItem removes only the selected movie', () {
    cart.addItem(movie, 2);
    cart.addItem(secondMovie, 3);

    cart.removeItem(movie);

    final items = cart.getItems();

    expect(items.length, 1);
    expect(items.first.movie.id, secondMovie.id);
    expect(items.first.quantity, 3);
  });

  test('clear removes all tickets from the basket', () {
    cart.addItem(movie, 2);
    cart.addItem(secondMovie, 3);

    cart.clear();

    final items = cart.getItems();

    expect(items.isEmpty, true);
  });
}

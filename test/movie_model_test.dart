import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/models/movie.dart';

void main() {
  group('Movie model tests', () {
    test('creates Movie instance with given properties', () {
      const movie = Movie(
        id: 'arrival',
        title: 'Arrival',
        genre: 'Sci-Fi/Drama',
        synopsis:
            'A linguist works to understand the language of alien visitors after spacecraft arrive on Earth.',
        ageRating: '12A',
        runtime: '116 minutes',
        screeningDate: 'Wednesday 21st Oct 2026',
        screeningTime: '19:00',
        ticketPrice: 6,
        posterImagePath: 'assets/images/arrival.jpeg',
      );

      expect(movie.id, 'arrival');
      expect(movie.title, 'Arrival');
      expect(movie.genre, 'Sci-Fi/Drama');
      expect(
        movie.synopsis,
        'A linguist works to understand the language of alien visitors after spacecraft arrive on Earth.',
      );
      expect(movie.ageRating, '12A');
      expect(movie.runtime, '116 minutes');
      expect(movie.screeningDate, 'Wednesday 21st Oct 2026');
      expect(movie.screeningTime, '19:00');
      expect(movie.ticketPrice, 6);
      expect(movie.posterImagePath, 'assets/images/arrival.jpeg');
    });

    test('formattedPrice formats a whole pound price to two decimals', () {
      const movie = Movie(
        id: 'arrival',
        title: 'Arrival',
        genre: 'Sci-Fi/Drama',
        synopsis:
            'A linguist works to understand the language of alien visitors after spacecraft arrive on Earth.',
        ageRating: '12A',
        runtime: '116 minutes',
        screeningDate: 'Wednesday 21st Oct 2026',
        screeningTime: '19:00',
        ticketPrice: 6,
        posterImagePath: 'assets/images/arrival.jpeg',
      );

      expect(movie.formattedPrice, '£6.00');
    });

    test('formattedPrice formats a price with pence to two decimals', () {
      const movie = Movie(
        id: 'arrival',
        title: 'Arrival',
        genre: 'Sci-Fi/Drama',
        synopsis:
            'A linguist works to understand the language of alien visitors after spacecraft arrive on Earth.',
        ageRating: '12A',
        runtime: '116 minutes',
        screeningDate: 'Wednesday 21st Oct 2026',
        screeningTime: '19:00',
        ticketPrice: 6.5,
        posterImagePath: 'assets/images/arrival.jpeg',
      );

      expect(movie.formattedPrice, '£6.50');
    });
  });
}

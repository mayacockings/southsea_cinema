import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/models/movie.dart';

void main() {
  test('Movie.fromJson reads all movie fields', () {
    final json = {
      'id': 'arrival',
      'title': 'Arrival',
      'genre': 'Sci-Fi/Drama',
      'synopsis':
          'A linguist works to understand the language of alien visitors after spacecraft arrive on Earth.',
      'ageRating': '12A',
      'runtime': '116 minutes',
      'screeningDate': 'Wednesday 21st Oct 2026',
      'screeningTime': '19:00',
      'ticketPrice': 6.0,
      'posterImagePath': 'assets/images/arrival.jpeg',
    };

    final movie = Movie.fromJson(json);

    expect(movie.id, 'arrival');
    expect(movie.title, 'Arrival');
    expect(movie.genre, 'Sci-Fi/Drama');
    expect(movie.synopsis,
        'A linguist works to understand the language of alien visitors after spacecraft arrive on Earth.');
    expect(movie.ageRating, '12A');
    expect(movie.runtime, '116 minutes');
    expect(movie.screeningDate, 'Wednesday 21st Oct 2026');
    expect(movie.screeningTime, '19:00');
    expect(movie.ticketPrice, 6.0);
    expect(movie.posterImagePath, 'assets/images/arrival.jpeg');
  });

  test('Movie.fromJson accepts whole-number prices', () {
    final json = {
      'id': 'arrival',
      'title': 'Arrival',
      'genre': 'Sci-Fi/Drama',
      'synopsis':
          'A linguist works to understand the language of alien visitors after spacecraft arrive on Earth.',
      'ageRating': '12A',
      'runtime': '116 minutes',
      'screeningDate': 'Wednesday 21st Oct 2026',
      'screeningTime': '19:00',
      'ticketPrice': 6,
      'posterImagePath': 'assets/images/arrival.jpeg',
    };

    final movie = Movie.fromJson(json);

    expect(movie.ticketPrice, 6.0);
  });

  test('Movie.toJson preserves all movie fields', () {
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
      ticketPrice: 6.0,
      posterImagePath: 'assets/images/arrival.jpeg',
    );

    final json = movie.toJson();

    expect(json['id'], movie.id);
    expect(json['title'], movie.title);
    expect(json['genre'], movie.genre);
    expect(json['synopsis'], movie.synopsis);
    expect(json['ageRating'], movie.ageRating);
    expect(json['runtime'], movie.runtime);
    expect(json['screeningDate'], movie.screeningDate);
    expect(json['screeningTime'], movie.screeningTime);
    expect(json['ticketPrice'], movie.ticketPrice);
    expect(json['posterImagePath'], movie.posterImagePath);
  });

  test('Movie can be converted to JSON and back', () {
    const originalMovie = Movie(
      id: 'arrival',
      title: 'Arrival',
      genre: 'Sci-Fi/Drama',
      synopsis:
          'A linguist works to understand the language of alien visitors after spacecraft arrive on Earth.',
      ageRating: '12A',
      runtime: '116 minutes',
      screeningDate: 'Wednesday 21st Oct 2026',
      screeningTime: '19:00',
      ticketPrice: 6.0,
      posterImagePath: 'assets/images/arrival.jpeg',
    );

    final restoredMovie = Movie.fromJson(originalMovie.toJson());

    expect(restoredMovie.toJson(), originalMovie.toJson());
  });
}

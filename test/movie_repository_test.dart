import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/models/movie.dart';
import 'package:southsea_cinema/repositories/movie_repository.dart';

void main() {
  group('MovieRepository unit tests', () {
    test('getMovies returns three movies', () {
      final MovieRepository repository = MovieRepository();
      final List<Movie> movies = repository.getMovies();

      expect(movies.length, 3);
    });

    test('getMovies contains valid film details', () {
      final MovieRepository repository = MovieRepository();
      final List<Movie> movies = repository.getMovies();

      final Movie pansLabyrinth = movies[0];
      expect(pansLabyrinth.id, 'pans-labyrinth');
      expect(pansLabyrinth.title, "Pan's Labyrinth");
      expect(pansLabyrinth.genre, 'Horror/Fantasy');
      expect(pansLabyrinth.ageRating, '15');
      expect(pansLabyrinth.runtime, '119 minutes');
      expect(pansLabyrinth.screeningDate, 'Sunday 18th Oct 2026');
      expect(pansLabyrinth.screeningTime, '15:00');
      expect(pansLabyrinth.ticketPrice, 6);
      expect(pansLabyrinth.synopsis,
          'In 1944 Francoist Spain, young Ofelia discovers a mysterious labyrinth where a faun gives her three dangerous tasks that may reveal her true identity.');
      expect(
          pansLabyrinth.posterImagePath, 'assets/images/pans_labyrinth.jpeg');

      final Movie arrival = movies[1];
      expect(arrival.id, 'arrival');
      expect(arrival.title, 'Arrival');
      expect(arrival.genre, 'Sci-Fi/Drama');
      expect(arrival.ageRating, '12A');
      expect(arrival.runtime, '116 minutes');
      expect(arrival.screeningDate, 'Wednesday 21st Oct 2026');
      expect(arrival.screeningTime, '19:00');
      expect(arrival.ticketPrice, 6);
      expect(arrival.synopsis,
          'A linguist works to understand the language of alien visitors after spacecraft arrive on Earth.');
      expect(arrival.posterImagePath, 'assets/images/arrival.jpeg');

      final Movie handmaiden = movies[2];
      expect(handmaiden.id, 'the-handmaiden');
      expect(handmaiden.title, 'The Handmaiden');
      expect(handmaiden.genre, 'Thriller/Drama');
      expect(handmaiden.ageRating, '18');
      expect(handmaiden.runtime, '145 minutes');
      expect(handmaiden.screeningDate, 'Friday 22nd Oct 2026');
      expect(handmaiden.screeningTime, '20:00');
      expect(handmaiden.ticketPrice, 6);
      expect(handmaiden.synopsis,
          "In 1930's Korea, a con man hires a pickpocket to become the handmaiden of a Japanese heiress, but their plans are complicated by unexpected feelings.");
      expect(handmaiden.posterImagePath, 'assets/images/the_handmaiden.jpeg');
    });

    test('getMovieById returns matching movie when id exists', () {
      final MovieRepository repository = MovieRepository();
      final Movie? movie = repository.getMovieById('arrival');
      expect(movie, isNotNull);
      expect(movie?.title, 'Arrival');
      expect(movie?.ticketPrice, 6);
    });

    test('getMovieById returns null when id does not exist', () {
      final MovieRepository repository = MovieRepository();
      final Movie? movie = repository.getMovieById('null');
      expect(movie, isNull);
    });
  });
}

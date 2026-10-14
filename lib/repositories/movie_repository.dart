import 'package:southsea_cinema/models/movie.dart';

class MovieRepository {
  List<Movie> getMovies() {
    return [
      const Movie(
        id: 'pans-labyrinth',
        title: "Pan's Labyrinth",
        genre: 'Horror/Fantasy',
        synopsis: 'In 1944 Francoist Spain, young Ofelia discovers a mysterious labyrinth where a faun gives her three dangerous tasks that may reveal her true identity.',
        ageRating: '15',
        runtime: '119 minutes',
        screeningDate: 'Sunday 18th Oct 2026',
        screeningTime: '15:00',
        ticketPrice: 6.99,
        posterImagePath: 'assets/images/pans_labyrinth.jpeg',
      ),
      const Movie(
        id: 'arrival',
        title: 'Arrival',
        genre: 'Sci-Fi/Drama',
        synopsis: 'A linguist works to understand the language of alien visitors after spacecraft arrive on Earth.',
        ageRating: '12A',
        runtime: '116 minutes',
        screeningDate: 'Wednesday 21st Oct 2026',
        screeningTime: '19:00',
        ticketPrice: 6.99,
        posterImagePath: 'assets/images/arrival.jpeg',
      ),
      const Movie(
        id: 'the-handmaiden',
        title: 'The Handmaiden',
        genre: 'Thriller/Drama',
        synopsis: "In 1930's Korea, a con man hires a pickpocket to become the handmaiden of a Japanese heiress, but their plans are complicated by unexpected feelings.",
        ageRating: '18',
        runtime: '145 minutes',
        screeningDate: 'Friday 22nd Oct 2026',
        screeningTime: '20:00',
        ticketPrice: 6.99,
        posterImagePath: 'assets/images/the_handmaiden.jpeg',
      )
    ];
  }
}
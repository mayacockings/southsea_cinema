import 'package:southsea_cinema/models/movie.dart';

class MovieRepository {
  List<Movie> getMovies() {
    return [
      const Movie(
        id: 'pans-labyrinth',
        title: "Pan's Labyrinth",
        synopsis: 'In 1944 Francoist Spain, young Ofelia discovers a mysterious labyrinth where a faun gives her three dangerous tasks that may reveal her true identity.',
        ageRating: '15',
        runtime: '119 minutes',
        screeningTime: '15:00',
        ticketPrice: 6.99,
        posterImagePath: 'assets/images/pans_labyrinth.jpeg',
      ),
      const Movie(
        id: 'arrival',
        title: 'Arrival',
        synopsis: 'A linguist works to understand the language of alien visitors after spacecraft arrive on Earth.',
        ageRating: '12A',
        runtime: '116 minutes',
        screeningTime: '19:00',
        ticketPrice: 6.99,
        posterImagePath: 'assets/images/arrival.jpeg',
      ),
    ];
  }
}
class Movie {
  final String id;
  final String title;
  final String genre;
  final String synopsis;
  final String ageRating;
  final String runtime;
  final String screeningDate;
  final String screeningTime;
  final double ticketPrice;
  final String posterImagePath;

  const Movie({
    required this.id,
    required this.title,
    required this.genre,
    required this.synopsis,
    required this.ageRating,
    required this.runtime,
    required this.screeningDate,
    required this.screeningTime,
    required this.ticketPrice,
    required this.posterImagePath,
  });
}
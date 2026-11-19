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

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] as String,
      title: json['title'] as String,
      genre: json['genre'] as String,
      synopsis: json['synopsis'] as String,
      ageRating: json['ageRating'] as String,
      runtime: json['runtime'] as String,
      screeningDate: json['screeningDate'] as String,
      screeningTime: json['screeningTime'] as String,
      ticketPrice: (json['ticketPrice'] as num).toDouble(),
      posterImagePath: json['posterImagePath'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'genre': genre,
      'synopsis': synopsis,
      'ageRating': ageRating,
      'runtime': runtime,
      'screeningDate': screeningDate,
      'screeningTime': screeningTime,
      'ticketPrice': ticketPrice,
      'posterImagePath': posterImagePath,
    };
  }

  String get formattedPrice => '£${ticketPrice.toStringAsFixed(2)}';
}

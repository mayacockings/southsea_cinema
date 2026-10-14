import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/models/movie.dart';
import 'package:southsea_cinema/views/movie_listing.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: cinemaBackground,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      margin: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 8,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: movie.title.toUpperCase(),
                    style: const TextStyle(
                      color: cinemaBrand,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: ' (${movie.ageRating})',
                    style: const TextStyle(
                      color: cinemaFontMuted,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  movie.posterImagePath,
                  width: 120,
                  height: 180,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Genre: ${movie.genre}',
                        style: const TextStyle(
                          color: cinemaFontMuted,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Runtime: ${movie.runtime}',
                        style: const TextStyle(
                          color: cinemaFontMuted,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        movie.synopsis,
                        style: const TextStyle(
                          color: cinemaFontWhite,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${movie.screeningDate}, ${movie.screeningTime}',
                    style: const TextStyle(
                      color: cinemaFontWhite,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cinemaBrand,
                    foregroundColor: cinemaFontWhite,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return MovieListing(movie: movie);
                        },
                      ),
                    );
                  },
                  child: const Text(
                    'BOOK NOW',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
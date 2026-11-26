import 'package:flutter/material.dart';
import 'package:southsea_cinema/models/movie.dart';
import 'package:southsea_cinema/views/movie_listing.dart';
import 'package:southsea_cinema/widgets/primary_button.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Card(
      color: colors.surface,
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
                    style: TextStyle(
                      color: colors.primary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: ' (${movie.ageRating})',
                    style: TextStyle(
                      color: colors.onSurfaceVariant,
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
                        style: TextStyle(color: colors.onSurfaceVariant),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Runtime: ${movie.runtime}',
                        style: TextStyle(color: colors.onSurfaceVariant),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        movie.synopsis,
                        style: TextStyle(color: colors.onSurface),
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
                    style: TextStyle(color: colors.onSurface),
                  ),
                ),
                const SizedBox(width: 16),
                PrimaryButton(
                  label: 'BOOK NOW',
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

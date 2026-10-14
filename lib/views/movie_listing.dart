import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/widgets/nav_drawer.dart';
import 'package:southsea_cinema/models/movie.dart';


class MovieListing extends StatefulWidget {
  final Movie movie;

  const MovieListing({
    super.key,
    required this.movie,
  });

  @override
  State<MovieListing> createState() {
    return _MovieListingState();
  }
}

class _MovieListingState extends State<MovieListing> {
  int _ticketQuantity = 0;
  String _bookingMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          appTitle,
          style: cinemaHeaderStyle,
        ),
        backgroundColor: cinemaSurface,
        iconTheme: const IconThemeData(color: cinemaBrand),
        elevation: 0,
      ),
      drawer: const NavDrawer(),
      body: Container(
        color: cinemaBackground,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.movie.title.toUpperCase()} (${widget.movie.ageRating})',
              style: const TextStyle(
                color: cinemaFontWhite,
                fontSize: 28,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Southsea Cinema Room',
              style: TextStyle(
                color: cinemaFontWhite,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              '${widget.movie.screeningDate}, ${widget.movie.screeningTime}',
              style: const TextStyle(
                color: cinemaFontWhite,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 48),
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 600) {
                  return Row(
                    children: [
                      Text(
                        'Runtime: ${widget.movie.runtime}',
                        style: const TextStyle(
                          color: cinemaFontMuted,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Text(
                        'Genre: ${widget.movie.genre}',
                        style: const TextStyle(
                          color: cinemaFontMuted,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Runtime: ${widget.movie.runtime}',
                        style: const TextStyle(
                          color: cinemaFontMuted,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Genre: ${widget.movie.genre}',
                        style: const TextStyle(
                          color: cinemaFontMuted,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
            const SizedBox(height: 32),
            Text(
              widget.movie.synopsis,
              style: const TextStyle(
                color: cinemaFontWhite,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 48),
            const Text(
              'Select Quantities (Up to 5 in total)',
              style: TextStyle(
                color: cinemaFontWhite,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Tickets',
              style: TextStyle(
                color: cinemaFontWhite,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                SizedBox(
                  width: 100,
                  child: DropdownMenu<int>(
                    initialSelection: _ticketQuantity,
                    textStyle: const TextStyle(
                      color: cinemaFontWhite,
                      fontSize: 18,
                    ),
                    dropdownMenuEntries: const [
                      DropdownMenuEntry(value: 0, label: '0'),
                      DropdownMenuEntry(value: 1, label: '1'),
                      DropdownMenuEntry(value: 2, label: '2'),
                      DropdownMenuEntry(value: 3, label: '3'),
                      DropdownMenuEntry(value: 4, label: '4'),
                      DropdownMenuEntry(value: 5, label: '5'),
                    ],
                    onSelected: (int? value) {
                      if (value != null) {
                        setState(() {
                          _ticketQuantity = value;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  'Adult (£${widget.movie.ticketPrice.toStringAsFixed(2)})',
                  style: const TextStyle(
                    color: cinemaFontWhite,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: cinemaBrand,
                foregroundColor: cinemaBackground,
              ),
              onPressed: () {
                setState(() {
                  _bookingMessage =
                      '$_ticketQuantity ticket(s) added to the order.';
                });
              },
              child: const Text('ADD TO ORDER'),
            ),
            const SizedBox(height: 16),
            Text(
              _bookingMessage,
              style: const TextStyle(
                color: cinemaBrandLight,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
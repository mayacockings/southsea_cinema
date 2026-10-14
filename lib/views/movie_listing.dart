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
        margin: const EdgeInsets.all(16),
        color: cinemaSurface,
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${widget.movie.title.toUpperCase()} (${widget.movie.ageRating})',
                style: const TextStyle(
                  color: cinemaFontWhite,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 16),
              Image.asset(
                widget.movie.posterImagePath,
                width: 120,
                height: 180,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 16),
              const Text(
                'Southsea Cinema Room',
                style: TextStyle(
                  color: cinemaFontWhite,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${widget.movie.screeningDate}, ${widget.movie.screeningTime}',
                style: const TextStyle(
                  color: cinemaFontWhite,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
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
              const SizedBox(height: 16),
              Text(
                widget.movie.synopsis,
                style: const TextStyle(
                  color: cinemaFontWhite,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Tickets (${widget.movie.formattedPrice} each)',
                      style: const TextStyle(
                        color: cinemaFontWhite,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
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
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: cinemaBrand,
                  foregroundColor: cinemaFontWhite,
                ),
                onPressed: () {
                  setState(() {
                    _bookingMessage =
                        '$_ticketQuantity ticket(s) added to the order.';
                  });
                },
                child: const Text(
                  'ADD TO ORDER',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),
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
      ),
    );
  }
}
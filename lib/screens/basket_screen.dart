import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/models/cart_item.dart';
import 'package:southsea_cinema/repositories/cart_repository.dart';
import 'package:southsea_cinema/widgets/primary_button.dart';
import 'package:southsea_cinema/database/cinema_db.dart';
import 'package:southsea_cinema/models/booking.dart';

class BasketScreen extends StatefulWidget {
  const BasketScreen({super.key});

  @override
  State<BasketScreen> createState() {
    return _BasketScreenState();
  }
}

class _BasketScreenState extends State<BasketScreen> {
  String _confirmationMessage = '';
  bool _savingBooking = false;
  late Future<List<Booking>> _pastBookings;

  @override
  void initState() {
    super.initState();
    _pastBookings = CinemaDatabase.instance.getAllBookings();
  }

  String _buildSummary(List<CartItem> items) {
    final List<String> parts = [];
    for (final CartItem item in items) {
      parts.add('${item.quantity} x ${item.movie.title}');
    }
    return parts.join(', ');
  }

  String _formatDate(DateTime now) {
    final String day = now.day.toString().padLeft(2, '0');
    final String month = now.month.toString().padLeft(2, '0');
    final String hour = now.hour.toString().padLeft(2, '0');
    final String minute = now.minute.toString().padLeft(2, '0');
    return '$day/$month/${now.year} $hour:$minute';
  }

  Future<void> _checkout(CartRepository cart) async {
    final List<CartItem> items = cart.getItems();
    if (_savingBooking || items.isEmpty) {
      return;
    }

    final String summary = _buildSummary(items);
    final double total = cart.getTotalDue();
    final String date = _formatDate(DateTime.now());
    final CinemaDatabase database = CinemaDatabase.instance;

    setState(() {
      _savingBooking = true;
      _confirmationMessage = '';
    });

    try {
      final int bookingNumber = await database.getNextBookingNumber();
      final Booking booking = Booking(
        bookingNumber: bookingNumber,
        summary: summary,
        total: total,
        date: date,
      );

      await database.insertBooking(booking);
      cart.clear();

      if (!mounted) {
        return;
      }

      setState(() {
        _confirmationMessage = 'Booking #$bookingNumber confirmed!';
        _pastBookings = database.getAllBookings();
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _confirmationMessage = 'Could not save your booking. Please try again.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _savingBooking = false;
        });
      }
    }
  }

  Widget _buildEmptyState() {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.shopping_basket_outlined,
              size: 64,
              color: colors.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'Your basket is empty.',
              style: TextStyle(color: colors.onSurface, fontSize: 20),
            ),
            const SizedBox(height: 8),
            Text(
              'Select a movie and add tickets to your basket.',
              textAlign: TextAlign.center,
              style: TextStyle(color: colors.onSurfaceVariant, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLineItem(CartRepository cart, CartItem item) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final TextStyle detailStyle = TextStyle(
      color: colors.onSurface,
      fontSize: 16,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '${item.quantity} Tickets',
              style: TextStyle(
                color: colors.primary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${item.quantity} Standard', style: detailStyle),
                const SizedBox(height: 4),
                Text(item.movie.title.toUpperCase(), style: detailStyle),
                const SizedBox(height: 4),
                Text(
                  '${item.movie.screeningDate}, ${item.movie.screeningTime}',
                  style: detailStyle,
                ),
                const SizedBox(height: 4),
                Text('Southsea Cinema Room', style: detailStyle),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '£${item.lineTotal.toStringAsFixed(2)}',
              textAlign: TextAlign.end,
              style: detailStyle,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.delete_outline, color: colors.onErrorContainer),
            style: IconButton.styleFrom(
              backgroundColor: colors.errorContainer,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
              padding: const EdgeInsets.all(12),
            ),
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            onPressed: () {
              setState(() {
                cart.removeItem(item.movie);
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRow(
    String label,
    String value, {
    bool emphasise = false,
  }) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final TextStyle style;

    if (emphasise) {
      style = TextStyle(
        color: colors.onSurface,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      );
    } else {
      style = TextStyle(color: colors.onSurface, fontSize: 16);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(value, style: style),
        ],
      ),
    );
  }

  Widget _buildBasketList(CartRepository cart, List<CartItem> items) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final TextStyle columnHeadingStyle = TextStyle(
      color: colors.onSurface,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    );
    final List<Widget> children = [];

    children.add(
      Text(
        'MY ORDER',
        style: TextStyle(
          color: colors.onSurface,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    children.add(const SizedBox(height: 24));

    children.add(
      Row(
        children: [
          Expanded(
            flex: 2,
            child: Text('Item', style: columnHeadingStyle),
          ),
          Expanded(
            flex: 5,
            child: Text('Details', style: columnHeadingStyle),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Price',
              textAlign: TextAlign.end,
              style: columnHeadingStyle,
            ),
          ),
          const SizedBox(width: 56),
        ],
      ),
    );

    children.add(const SizedBox(height: 16));

    for (final CartItem item in items) {
      children.add(_buildLineItem(cart, item));
    }

    children.add(const SizedBox(height: 24));

    children.add(
      _buildTotalRow(
        'Service Charge',
        '£${cart.getServiceCharge().toStringAsFixed(2)}',
      ),
    );

    children.add(const SizedBox(height: 8));

    children.add(
      _buildTotalRow(
        'Total Due',
        '£${cart.getTotalDue().toStringAsFixed(2)}',
        emphasise: true,
      ),
    );

    children.add(const SizedBox(height: 32));

    children.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PrimaryButton(
            label: 'UPDATE ORDER',
            onPressed: () {
              setState(() {});
            },
          ),
          PrimaryButton(
            label: 'BUY TICKETS',
            onPressed: () => _checkout(cart),
          ),
        ],
      ),
    );

    if (_confirmationMessage.isNotEmpty) {
      children.add(const SizedBox(height: 12));
      children.add(
        Text(
          _confirmationMessage,
          style: TextStyle(
            color: colors.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  Widget _buildPastBookings() {
    return FutureBuilder<List<Booking>>(
      future: _pastBookings,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Text('Could not load past bookings.');
        }

        final List<Booking> bookings = snapshot.data ?? [];
        if (bookings.isEmpty) {
          return const Text('No past bookings yet.');
        }

        return Column(
          children: [
            for (final Booking booking in bookings)
              Card(
                child: ListTile(
                  title: Text('Booking #${booking.bookingNumber}'),
                  subtitle: Text('${booking.summary}\n${booking.date}'),
                  trailing: Text('£${booking.total.toStringAsFixed(2)}'),
                  isThreeLine: true,
                ),
              ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final CartRepository cart = CartRepository.instance;
    final List<CartItem> items = cart.getItems();

    final Widget content;

    if (items.isEmpty) {
      if (_confirmationMessage.isNotEmpty) {
        content = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildEmptyState(),
            const SizedBox(height: 12),
            Text(
              _confirmationMessage,
              style: TextStyle(
                color: colors.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        );
      } else {
        content = _buildEmptyState();
      }
    } else {
      content = _buildBasketList(cart, items);
    }

    return Scaffold(
      appBar: AppBar(title: const Text(appTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AbsorbPointer(
              absorbing: _savingBooking,
              child: content,
            ),
            const SizedBox(height: 24),
            Text(
              'Past bookings',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            _buildPastBookings(),
          ],
        ),
      ),
    );
  }
}

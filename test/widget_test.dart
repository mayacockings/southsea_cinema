import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/main.dart';
import 'package:southsea_cinema/views/home_view.dart';
import 'package:southsea_cinema/widgets/movie_card.dart';
import 'package:southsea_cinema/views/movie_listing.dart';

void main() {
  group('App smoke tests', () {
    testWidgets('App displays HomeView as home', (WidgetTester tester) async {
      await tester.pumpWidget(const SouthseaCinemaApp());

      expect(find.byType(HomeView), findsOneWidget);
      expect(find.text('Southsea Cinema'), findsOneWidget);
      expect(find.byType(MovieCard), findsWidgets);
      expect(find.text('BOOK NOW'), findsWidgets);
    });

    testWidgets('Tapping BOOK NOW opens the selected movie listing',
        (WidgetTester tester) async {
      await tester.pumpWidget(const SouthseaCinemaApp());

      await tester.tap(find.text('BOOK NOW').first);
      await tester.pumpAndSettle();

      expect(find.byType(MovieListing), findsOneWidget);
      expect(find.text("PAN'S LABYRINTH (15)"), findsOneWidget);
      expect(find.text('Sunday 18th Oct 2026, 15:00'), findsOneWidget);
      expect(find.text('Runtime: 119 minutes'), findsOneWidget);
      expect(find.text('Genre: Horror/Fantasy'), findsOneWidget);
      expect(
          find.text(
              'In 1944 Francoist Spain, young Ofelia discovers a mysterious labyrinth where a faun gives her three dangerous tasks that may reveal her true identity.'),
          findsOneWidget);
      expect(find.text('Tickets (£6.00 each)'), findsOneWidget);

      await tester.ensureVisible(find.text('ADD TO ORDER'));
      await tester.tap(find.text('ADD TO ORDER'));
      await tester.pump();

      expect(
        find.text('0 ticket(s) added to the order.'),
        findsOneWidget,
      );
    });
  });
}

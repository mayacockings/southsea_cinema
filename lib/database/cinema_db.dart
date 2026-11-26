import 'package:path/path.dart';
import 'package:southsea_cinema/models/booking.dart';
import 'package:sqflite/sqflite.dart';

class CinemaDatabase {
  CinemaDatabase._internal();

  static final CinemaDatabase instance = CinemaDatabase._internal();

  static Database? _database;

  void setDatabase(Database? db) {
    _database = db;
  }

  Future<Database> get database async {
    final Database? cachedDatabase = _database;
    if (cachedDatabase != null) {
      return cachedDatabase;
    }

    final Database db = await _initDB('cinema_bookings.db');
    _database = db;
    return db;
  }

  Future<Database> _initDB(String fileName) async {
    final String folder = await getDatabasesPath();
    final String filePath = join(folder, fileName);

    return openDatabase(filePath, version: 1, onCreate: _createDB);
  }

  Future<void> createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS bookings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        booking_number INTEGER NOT NULL,
        summary TEXT NOT NULL,
        total REAL NOT NULL,
        date TEXT NOT NULL
      )
    ''');
  }

  Future<void> _createDB(Database db, int version) async {
    await createTables(db, version);

    const List<Booking> sampleBookings = [
      Booking(
        bookingNumber: 1003,
        summary: '2 x Arrival',
        total: 16.00,
        date: '18/04/2026 12:45',
      ),
      Booking(
        bookingNumber: 1002,
        summary: "1 x Pan's Labyrinth",
        total: 10.00,
        date: '02/03/2026 18:10',
      ),
      Booking(
        bookingNumber: 1001,
        summary: '3 x The Handmaiden',
        total: 22.00,
        date: '11/01/2026 13:02',
      ),
    ];

    for (final Booking booking in sampleBookings) {
      await db.insert('bookings', booking.toMap());
    }
  }

  Future<int> insertBooking(Booking booking) async {
    final Database db = await database;
    return db.insert('bookings', booking.toMap());
  }

  Future<List<Booking>> getAllBookings() async {
    final Database db = await database;
    final List<Map<String, Object?>> rows = await db.query(
      'bookings',
      orderBy: 'booking_number DESC',
    );

    final List<Booking> bookings = [];
    for (final Map<String, Object?> row in rows) {
      bookings.add(Booking.fromMap(row));
    }
    return bookings;
  }

  Future<int> getNextBookingNumber() async {
    final Database db = await database;
    final List<Map<String, Object?>> rows = await db.rawQuery(
      'SELECT MAX(booking_number) AS max_num FROM bookings',
    );

    if (rows.isEmpty) {
      return 1001;
    }

    final int? currentMax = rows.first['max_num'] as int?;
    return currentMax == null ? 1001 : currentMax + 1;
  }

  Future<void> close() async {
    final Database? cachedDatabase = _database;
    if (cachedDatabase != null) {
      await cachedDatabase.close();
      _database = null;
    }
  }
}

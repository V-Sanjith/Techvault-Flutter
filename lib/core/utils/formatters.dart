import 'package:intl/intl.dart';

/// Formatting utilities for currency values and dates.
abstract class Formatters {
  static final DateFormat _dateFormat = DateFormat('MMM d, yyyy');
  static final NumberFormat _currencyFormat = NumberFormat.currency(
    symbol: '\$',
    decimalDigits: 2,
  );

  static String date(DateTime? date) {
    if (date == null) return 'N/A';
    return _dateFormat.format(date);
  }

  static String currency(double? amount) {
    if (amount == null) return 'N/A';
    return _currencyFormat.format(amount);
  }
}

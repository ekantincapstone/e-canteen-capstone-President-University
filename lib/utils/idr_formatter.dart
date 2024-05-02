import 'package:intl/intl.dart';

String formatCurrency(int amount) {
  // Create a NumberFormat object with Indonesian locale
  final formatCurrency =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  // Use the format method to format the double value into a currency string
  return formatCurrency.format(amount);
}

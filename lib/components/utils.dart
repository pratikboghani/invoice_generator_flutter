import 'package:intl/intl.dart';

class Utils {
  static formatPrice(int price) => 'Rs. ${price.toStringAsFixed(2)}';
  static formatDate(DateTime date) => DateFormat('dd-MM-yyyy').format(date);
  static formatYear(DateTime date) => DateFormat('yyyy').format(date);
}

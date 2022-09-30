import 'package:intl/intl.dart';

class TimeUtils {
  static String convertdateTimeToDDMMMYYYY(DateTime date) {
    var dateFormat = new DateFormat('dd-MM-yyyy');
    String formattedDate = dateFormat.format(date);
    return formattedDate;
  }
}

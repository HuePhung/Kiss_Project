import 'package:intl/intl.dart';

class RecordDate {

  static Future<String> recordDateNow() async {
    /*var now = new DateTime.now();
    return now;*/
    final DateTime now = new DateTime.now();
    final DateFormat formatter = DateFormat('dd.MM.yyyy');
    final String formatted = formatter.format(now);
    return formatted;

  }
}
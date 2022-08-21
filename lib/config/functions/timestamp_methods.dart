import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:time_machine/time_machine.dart';

class TimestampHelpers {
  static int daysNumberSinceTimestamp(Timestamp timestamp) {
    Period periodSinceTimestamp = _getPeriodSinceDateTimeNow(timestamp);
    return periodSinceTimestamp.years * 365 + periodSinceTimestamp.months * 30 + periodSinceTimestamp.days;
  }

  static int monthsNumberSinceTimestamp(Timestamp timestamp) {
    Period periodSinceTimestamp = _getPeriodSinceDateTimeNow(timestamp);
    return periodSinceTimestamp.years * 12 + periodSinceTimestamp.months;
  }

  static int yearNumberSinceTimestamp(Timestamp timestamp) {
    Period periodSinceTimestamp = _getPeriodSinceDateTimeNow(timestamp);
    bool hasNextYearStarted = periodSinceTimestamp.days > 0;
    return periodSinceTimestamp.years + (hasNextYearStarted ? 1 : 0);
  }

  static LocalDate _getLocalDateFromTimestamp(Timestamp timestamp) => LocalDate.dateTime(timestamp.toDate());

  static Period _getPeriodSinceDateTimeNow(Timestamp timestamp) {
    LocalDate localDateFromTimestamp = _getLocalDateFromTimestamp(timestamp);
    return LocalDate.dateTime(DateTime.now()).periodSince(localDateFromTimestamp);
  }
}

String timestampToDate(Timestamp timestamp) => DateFormat('yyyy-MM-dd').format(getDateTimeFromTimestamp(timestamp));

DateTime getDateTimeFromTimestamp(Timestamp timestamp) =>
    DateTime.fromMillisecondsSinceEpoch(timestamp.seconds.toInt() * 1000);

int calcDaysBetween(Timestamp timestamp) {
  DateTime from = getDateTimeFromTimestamp(timestamp);
  return DateTime.now().difference(from).inDays;
}

String getTimeagoFromDateTime(Timestamp timestamp) {
  timeago.setLocaleMessages('pl', timeago.PlMessages());
  return timeago.format(getDateTimeFromTimestamp(timestamp), locale: 'pl');
}

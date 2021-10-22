import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String timestampToDate(Timestamp timestamp) => DateFormat('yyyy-MM-dd').format(getDateTimeFromTimestamp(timestamp));

DateTime getDateTimeFromTimestamp(Timestamp timestamp) =>
    DateTime.fromMillisecondsSinceEpoch(timestamp.seconds.toInt() * 1000);

int calcDaysBetween(Timestamp timestamp) {
  DateTime from = getDateTimeFromTimestamp(timestamp);
  return DateTime.now().difference(from).inDays;
}

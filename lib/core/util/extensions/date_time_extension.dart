import 'package:intl/intl.dart';

enum DatePattern {
  diaMesHoraMinuto('dd/MM \'às\' HH\'h\'mm'),
  diaMesAnoHoraMinuto('dd/MM/yy \'às\' HH\'h\'mm');

  const DatePattern(this.value);

  final String value;
}

extension DateTimeExtension on DateTime {
  String formatter(DatePattern pattern) =>
      DateFormat(pattern.value, 'pt_Br').format(this);
}

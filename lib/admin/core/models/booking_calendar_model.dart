/// Manages booking availability: available, booked, and blocked dates.
class BookingCalendarModel {
  Map<String, BookingStatus> dates; // key: 'yyyy-MM-dd', value: status

  BookingCalendarModel({Map<String, BookingStatus>? dates})
      : dates = dates ?? {};

  void markDate(DateTime date, BookingStatus status) {
    final key = _key(date);
    if (status == BookingStatus.available) {
      dates.remove(key); // available is the default
    } else {
      dates[key] = status;
    }
  }

  BookingStatus statusOf(DateTime date) =>
      dates[_key(date)] ?? BookingStatus.available;

  String _key(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Map<String, dynamic> toMap() => {
        'dates': dates.map((k, v) => MapEntry(k, v.name)),
      };

  factory BookingCalendarModel.fromMap(Map<dynamic, dynamic> map) {
    final rawDates = map['dates'] as Map<dynamic, dynamic>? ?? {};
    return BookingCalendarModel(
      dates: rawDates.map((k, v) => MapEntry(
            k.toString(),
            BookingStatus.values.firstWhere(
              (e) => e.name == v,
              orElse: () => BookingStatus.available,
            ),
          )),
    );
  }
}

enum BookingStatus { available, booked, blocked }

extension BookingStatusExt on BookingStatus {
  String get label {
    switch (this) {
      case BookingStatus.available:
        return 'متاح';
      case BookingStatus.booked:
        return 'محجوز';
      case BookingStatus.blocked:
        return 'غير متاح';
    }
  }
}

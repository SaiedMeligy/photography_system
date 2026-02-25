part of 'booking_cubit.dart';

class BookingState extends Equatable {
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final String selectedPackage;
  final String selectedPayment;
  final Set<DateTime> bookedDates;

  BookingState({
    DateTime? focusedDay,
    this.selectedDay,
    this.selectedPackage = '',
    this.selectedPayment = 'cash',
    Set<DateTime>? bookedDates,
  })  : focusedDay = focusedDay ?? DateTime.now(),
        bookedDates = bookedDates ??
            {
              DateTime.now().add(const Duration(days: 3)),
              DateTime.now().add(const Duration(days: 7)),
              DateTime.now().add(const Duration(days: 14)),
              DateTime.now().add(const Duration(days: 21)),
              DateTime.now().add(const Duration(days: 28)),
            };

  bool isBooked(DateTime day) => bookedDates.any(
        (d) => d.year == day.year && d.month == day.month && d.day == day.day,
      );

  BookingState copyWith({
    DateTime? focusedDay,
    DateTime? selectedDay,
    String? selectedPackage,
    String? selectedPayment,
    Set<DateTime>? bookedDates,
    bool clearSelectedDay = false,
  }) =>
      BookingState(
        focusedDay: focusedDay ?? this.focusedDay,
        selectedDay:
            clearSelectedDay ? null : (selectedDay ?? this.selectedDay),
        selectedPackage: selectedPackage ?? this.selectedPackage,
        selectedPayment: selectedPayment ?? this.selectedPayment,
        bookedDates: bookedDates ?? this.bookedDates,
      );

  @override
  List<Object?> get props => [
        focusedDay,
        selectedDay,
        selectedPackage,
        selectedPayment,
        bookedDates,
      ];
}

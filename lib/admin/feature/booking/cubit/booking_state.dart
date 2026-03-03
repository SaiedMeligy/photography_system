import 'package:equatable/equatable.dart';
import '../../../core/models/booking_calendar_model.dart';

class BookingState extends Equatable {
  final BookingCalendarModel? calendar;
  final bool isLoading;
  final BookingStatus brushMode;

  const BookingState({
    this.calendar,
    this.isLoading = true,
    this.brushMode = BookingStatus.booked,
  });

  BookingState copyWith({
    BookingCalendarModel? calendar,
    bool? isLoading,
    BookingStatus? brushMode,
  }) {
    return BookingState(
      calendar: calendar ?? this.calendar,
      isLoading: isLoading ?? this.isLoading,
      brushMode: brushMode ?? this.brushMode,
    );
  }

  @override
  List<Object?> get props => [calendar, isLoading, brushMode];
}

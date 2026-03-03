import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/models/booking_calendar_model.dart';
import '../../../core/services/admin_data_service.dart';
import 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  BookingCubit() : super(const BookingState());

  void load() {
    emit(state.copyWith(
      calendar: AdminDataService.getBookingCalendar(),
      isLoading: false,
    ));
  }

  void setBrushMode(BookingStatus mode) {
    emit(state.copyWith(brushMode: mode));
  }

  Future<void> updateDate(DateTime day) async {
    if (state.calendar == null) return;
    
    state.calendar!.markDate(day, state.brushMode);
    await AdminDataService.saveBookingCalendar(state.calendar!);
    emit(state.copyWith(calendar: state.calendar)); // Reload state
    load(); // Ensure fresh data
  }

  Future<void> removeStatus(DateTime day) async {
    if (state.calendar == null) return;

    state.calendar!.markDate(day, BookingStatus.available);
    await AdminDataService.saveBookingCalendar(state.calendar!);
    load();
  }
}

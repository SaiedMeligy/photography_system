import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/models/booking_calendar_model.dart';
import '../../../core/services/admin_data_service.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(const DashboardState());

  void load() {
    final settings = AdminDataService.getSiteSettings();
    final calendar = AdminDataService.getBookingCalendar();
    final booked = calendar.dates.values
        .where((s) => s == BookingStatus.booked)
        .length;

    emit(state.copyWith(
      totalPackages: AdminDataService.getPackages().length,
      totalCategories: AdminDataService.getCategories().length,
      totalTestimonials: AdminDataService.getTestimonials().length,
      bookedDates: booked,
      photographerName: settings?.photographerName ?? 'iBrahiim',
      isLoading: false,
    ));
  }
}

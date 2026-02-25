import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  BookingCubit() : super(BookingState());

  void selectDay(DateTime selected, DateTime focused) {
    emit(state.copyWith(selectedDay: selected, focusedDay: focused));
  }

  void changePage(DateTime focused) {
    emit(state.copyWith(focusedDay: focused));
  }

  void selectPackage(String? package) {
    if (package == null) return;
    emit(state.copyWith(selectedPackage: package));
  }

  void selectPayment(String payment) {
    emit(state.copyWith(selectedPayment: payment));
  }
}

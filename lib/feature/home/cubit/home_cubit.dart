import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/image_assets.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  Timer? _timer;

  HomeCubit() : super(const HomeState()) {
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      final next = (state.currentSlide + 1) % heroImages.length;
      emit(state.copyWith(currentSlide: next));
    });
  }

  void setSlide(int index) => emit(state.copyWith(currentSlide: index));

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}

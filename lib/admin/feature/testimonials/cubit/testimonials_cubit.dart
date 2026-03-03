import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/models/testimonial_model.dart';
import '../../../core/services/admin_data_service.dart';
import 'testimonials_state.dart';

class TestimonialsCubit extends Cubit<TestimonialsState> {
  TestimonialsCubit() : super(const TestimonialsState());

  void load() {
    emit(state.copyWith(
      testimonials: AdminDataService.getTestimonials(),
      isLoading: false,
    ));
  }

  Future<void> save(TestimonialModel t) async {
    await AdminDataService.saveTestimonial(t);
    load();
  }

  Future<void> delete(String id) async {
    await AdminDataService.deleteTestimonial(id);
    load();
  }

  Future<void> toggleApproval(TestimonialModel t) async {
    t.isApproved = !t.isApproved;
    await AdminDataService.saveTestimonial(t);
    load();
  }
}

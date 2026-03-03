import 'package:equatable/equatable.dart';
import '../../../core/models/testimonial_model.dart';

class TestimonialsState extends Equatable {
  final List<TestimonialModel> testimonials;
  final bool isLoading;

  const TestimonialsState({
    this.testimonials = const [],
    this.isLoading = true,
  });

  TestimonialsState copyWith({
    List<TestimonialModel>? testimonials,
    bool? isLoading,
  }) {
    return TestimonialsState(
      testimonials: testimonials ?? this.testimonials,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  List<TestimonialModel> get approved =>
      testimonials.where((t) => t.isApproved).toList();
  List<TestimonialModel> get pending =>
      testimonials.where((t) => !t.isApproved).toList();

  @override
  List<Object?> get props => [testimonials, isLoading];
}

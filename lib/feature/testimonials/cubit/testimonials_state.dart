part of 'testimonials_cubit.dart';

class Testimonial extends Equatable {
  final String name;
  final String event;
  final String text;
  final String initials;
  final int rating;

  const Testimonial({
    required this.name,
    required this.event,
    required this.text,
    required this.initials,
    this.rating = 5,
  });

  @override
  List<Object?> get props => [name, event, text, initials, rating];
}

class TestimonialsState extends Equatable {
  final List<Testimonial> testimonials;

  const TestimonialsState({required this.testimonials});

  TestimonialsState copyWith({List<Testimonial>? testimonials}) =>
      TestimonialsState(testimonials: testimonials ?? this.testimonials);

  @override
  List<Object?> get props => [testimonials];
}

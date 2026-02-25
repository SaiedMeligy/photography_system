part of 'home_cubit.dart';

class HomeState extends Equatable {
  final int currentSlide;

  const HomeState({this.currentSlide = 0});

  HomeState copyWith({int? currentSlide}) =>
      HomeState(currentSlide: currentSlide ?? this.currentSlide);

  @override
  List<Object?> get props => [currentSlide];
}

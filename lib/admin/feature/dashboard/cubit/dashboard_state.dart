import 'package:equatable/equatable.dart';

class DashboardState extends Equatable {
  final int totalPackages;
  final int totalCategories;
  final int totalTestimonials;
  final int bookedDates;
  final String photographerName;
  final bool isLoading;

  const DashboardState({
    this.totalPackages = 0,
    this.totalCategories = 0,
    this.totalTestimonials = 0,
    this.bookedDates = 0,
    this.photographerName = 'iBrahiim',
    this.isLoading = true,
  });

  DashboardState copyWith({
    int? totalPackages,
    int? totalCategories,
    int? totalTestimonials,
    int? bookedDates,
    String? photographerName,
    bool? isLoading,
  }) {
    return DashboardState(
      totalPackages: totalPackages ?? this.totalPackages,
      totalCategories: totalCategories ?? this.totalCategories,
      totalTestimonials: totalTestimonials ?? this.totalTestimonials,
      bookedDates: bookedDates ?? this.bookedDates,
      photographerName: photographerName ?? this.photographerName,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
        totalPackages,
        totalCategories,
        totalTestimonials,
        bookedDates,
        photographerName,
        isLoading,
      ];
}

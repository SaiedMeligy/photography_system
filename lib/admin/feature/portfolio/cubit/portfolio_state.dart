import 'package:equatable/equatable.dart';
import '../../../core/models/portfolio_category.dart';

class PortfolioState extends Equatable {
  final List<PortfolioCategory> categories;
  final bool isLoading;

  const PortfolioState({
    this.categories = const [],
    this.isLoading = true,
  });

  PortfolioState copyWith({
    List<PortfolioCategory>? categories,
    bool? isLoading,
  }) {
    return PortfolioState(
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [categories, isLoading];
}

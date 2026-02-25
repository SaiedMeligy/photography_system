part of 'portfolio_cubit.dart';

class PortfolioState extends Equatable {
  final List<String> images;
  final int lightboxIndex; // -1 = closed
  final bool isLoaded;

  const PortfolioState({
    this.images = const [],
    this.lightboxIndex = -1,
    this.isLoaded = false,
  });

  bool get isLightboxOpen => lightboxIndex >= 0;

  PortfolioState copyWith({
    List<String>? images,
    int? lightboxIndex,
    bool? isLoaded,
  }) =>
      PortfolioState(
        images: images ?? this.images,
        lightboxIndex: lightboxIndex ?? this.lightboxIndex,
        isLoaded: isLoaded ?? this.isLoaded,
      );

  @override
  List<Object?> get props => [images, lightboxIndex, isLoaded];
}

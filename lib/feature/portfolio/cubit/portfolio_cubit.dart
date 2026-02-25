import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/image_assets.dart';

part 'portfolio_state.dart';

// Runs in a background isolate via compute()
List<String> _loadImages(List<String> raw) => List<String>.from(raw);

class PortfolioCubit extends Cubit<PortfolioState> {
  final int? previewCount;

  PortfolioCubit({this.previewCount}) : super(const PortfolioState()) {
    _loadImagesInBackground();
  }

  Future<void> _loadImagesInBackground() async {
    final source = previewCount != null
        ? portfolioImages.take(previewCount!).toList()
        : portfolioImages;
    // compute() spawns a real Dart isolate — keeps the main thread free
    final images = await compute(_loadImages, source);
    emit(state.copyWith(images: images, isLoaded: true));
  }

  void openLightbox(int index) => emit(state.copyWith(lightboxIndex: index));

  void closeLightbox() => emit(state.copyWith(lightboxIndex: -1));

  void prevImage() {
    if (state.lightboxIndex > 0) {
      emit(state.copyWith(lightboxIndex: state.lightboxIndex - 1));
    }
  }

  void nextImage() {
    if (state.lightboxIndex < state.images.length - 1) {
      emit(state.copyWith(lightboxIndex: state.lightboxIndex + 1));
    }
  }
}

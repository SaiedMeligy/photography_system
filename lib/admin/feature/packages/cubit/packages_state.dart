import 'package:equatable/equatable.dart';
import '../../../core/models/package_model.dart';

class PackagesState extends Equatable {
  final List<PackageModel> packages;
  final bool isLoading;

  const PackagesState({
    this.packages = const [],
    this.isLoading = true,
  });

  PackagesState copyWith({List<PackageModel>? packages, bool? isLoading}) {
    return PackagesState(
      packages: packages ?? this.packages,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [packages, isLoading];
}

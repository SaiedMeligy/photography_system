import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/models/portfolio_category.dart';
import '../../../core/services/admin_data_service.dart';
import 'portfolio_state.dart';

class PortfolioCubit extends Cubit<PortfolioState> {
  PortfolioCubit() : super(const PortfolioState());

  void load() {
    emit(state.copyWith(
      categories: AdminDataService.getCategories(),
      isLoading: false,
    ));
  }

  Future<void> addCategory(PortfolioCategory cat) async {
    await AdminDataService.saveCategory(cat);
    load();
  }

  Future<void> updateCategory(PortfolioCategory cat) async {
    await AdminDataService.saveCategory(cat);
    load();
  }

  Future<void> deleteCategory(String id) async {
    await AdminDataService.deleteCategory(id);
    load();
  }

  Future<void> addImage(PortfolioCategory cat, PortfolioImage img) async {
    cat.images.add(img);
    await AdminDataService.saveCategory(cat);
    load();
  }

  Future<void> removeImage(PortfolioCategory cat, String imageId) async {
    cat.images.removeWhere((e) => e.id == imageId);
    await AdminDataService.saveCategory(cat);
    load();
  }
}

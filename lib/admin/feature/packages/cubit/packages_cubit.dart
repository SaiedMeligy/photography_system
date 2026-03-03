import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/models/package_model.dart';
import '../../../core/services/admin_data_service.dart';
import 'packages_state.dart';

class PackagesCubit extends Cubit<PackagesState> {
  PackagesCubit() : super(const PackagesState());

  void load() {
    emit(state.copyWith(
      packages: AdminDataService.getPackages(),
      isLoading: false,
    ));
  }

  Future<void> save(PackageModel pkg) async {
    await AdminDataService.savePackage(pkg);
    load();
  }

  Future<void> delete(String id) async {
    await AdminDataService.deletePackage(id);
    load();
  }
}

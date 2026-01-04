import 'package:fittrack_mobile/app/modules/workouts/workouts_controller.dart';
import 'package:get/get.dart';

class WorkoutsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WorkoutsController>(() => WorkoutsController());
  }
}

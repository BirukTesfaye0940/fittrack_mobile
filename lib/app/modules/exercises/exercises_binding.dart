import 'package:get/get.dart';
import 'package:fittrack_mobile/app/modules/exercises/exercises_controller.dart';

class ExercisesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExercisesController>(() => ExercisesController());
  }
}

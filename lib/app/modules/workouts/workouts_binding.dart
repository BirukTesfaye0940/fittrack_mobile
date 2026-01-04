import 'package:get/get.dart';
import 'package:fittrack_mobile/app/modules/workouts/workouts_controller.dart';
import 'package:fittrack_mobile/app/modules/exercises/exercises_controller.dart';

class WorkoutsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WorkoutsController>(() => WorkoutsController());
    // We inject ExercisesController too, because the "Add Set" modal needs the list of exercises
    Get.lazyPut<ExercisesController>(() => ExercisesController());
  }
}

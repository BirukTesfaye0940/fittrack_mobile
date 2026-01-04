import 'package:get/get.dart';
import 'package:fittrack_mobile/app/modules/exercises/exercises_controller.dart';
import 'package:fittrack_mobile/app/modules/home/home_controller.dart';
import 'package:fittrack_mobile/app/modules/workouts/workouts_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    // Use Get.put for fragments used in BottomNavigationBar to ensure they are available
    Get.put<WorkoutsController>(WorkoutsController());
    Get.put<ExercisesController>(ExercisesController());
  }
}

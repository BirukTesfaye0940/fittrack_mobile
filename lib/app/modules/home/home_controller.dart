import 'package:get/get.dart';
import 'package:fittrack_mobile/app/modules/home/home_service.dart';

class HomeController extends GetxController {
  final HomeService _service = HomeService();

  // Navigation State
  var currentIndex = 0.obs;

  // Dashboard Data State
  var aiCoachFeedback = "".obs;
  var weeklyStats = "".obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    try {
      isLoading.value = true;
      // Fetch both in parallel
      final results = await Future.wait([
        _service.getWeeklyAiCoach(),
        _service.getWeeklyStats(),
      ]);
      aiCoachFeedback.value = results[0];
      weeklyStats.value = results[1];
    } catch (e) {
      print("Error fetching home data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void changePage(int index) {
    currentIndex.value = index;
  }
}

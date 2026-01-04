import 'package:get/get.dart';
import 'package:fittrack_mobile/app/modules/home/home_service.dart';

class HomeController extends GetxController {
  final HomeService _service = HomeService();

  // Navigation State
  var currentIndex = 0.obs;

  // Dashboard Data State
  var aiCoachFeedback = "".obs;
  var weeklyStats = "".obs;

  // Specific Error States
  var aiCoachError = "".obs;
  var weeklyStatsError = "".obs;

  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    isLoading.value = true;

    // Clear previous errors
    aiCoachError.value = "";
    weeklyStatsError.value = "";

    // Fetch both independently so one failure doesn't block the other
    await Future.wait([_fetchAiCoach(), _fetchStats()]);

    isLoading.value = false;
  }

  Future<void> _fetchAiCoach() async {
    try {
      aiCoachFeedback.value = await _service.getWeeklyAiCoach();
    } catch (e) {
      aiCoachError.value = e.toString();
      print("Error fetching AI Coach: $e");
    }
  }

  Future<void> _fetchStats() async {
    try {
      weeklyStats.value = await _service.getWeeklyStats();
    } catch (e) {
      weeklyStatsError.value = e.toString();
      print("Error fetching Weekly Stats: $e");
    }
  }

  void changePage(int index) {
    currentIndex.value = index;
  }
}

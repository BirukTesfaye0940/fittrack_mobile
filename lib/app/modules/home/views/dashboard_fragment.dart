import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fittrack_mobile/app/modules/home/home_controller.dart';
import 'package:fittrack_mobile/app/routes/app_routes.dart';

class DashboardFragment extends GetView<HomeController> {
  const DashboardFragment({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("FitTrack AI"),
        centerTitle: false,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.person_outline)),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: controller.fetchDashboardData,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              "Welcome back! 👋",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // AI Coach Insight Card
            _buildSectionHeader("AI Coaching Insight", Icons.auto_awesome),
            Obx(() {
              if (controller.isLoading.value) {
                return _buildInfoCard(
                  "Analyzing your progress...",
                  Colors.deepPurple[50]!,
                  Colors.deepPurple,
                );
              }
              if (controller.aiCoachError.value.isNotEmpty) {
                return _buildInfoCard(
                  "⚠️ ${controller.aiCoachError.value}",
                  Colors.red[50]!,
                  Colors.red[900]!,
                );
              }
              return _buildInfoCard(
                controller.aiCoachFeedback.value,
                Colors.deepPurple[50]!,
                Colors.deepPurple,
              );
            }),

            const SizedBox(height: 24),

            // Weekly Stats Card
            _buildSectionHeader("Weekly Performance", Icons.bar_chart),
            Obx(() {
              if (controller.isLoading.value) {
                return _buildInfoCard(
                  "Calculating stats...",
                  Colors.blue[50]!,
                  Colors.blue[800]!,
                );
              }
              if (controller.weeklyStatsError.value.isNotEmpty) {
                return _buildInfoCard(
                  "⚠️ ${controller.weeklyStatsError.value}",
                  Colors.red[50]!,
                  Colors.red[900]!,
                );
              }
              return _buildInfoCard(
                controller.weeklyStats.value,
                Colors.blue[50]!,
                Colors.blue[800]!,
              );
            }),

            const SizedBox(height: 30),

            // Quick Launchpad
            const Text(
              "Quick Actions",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.5,
              children: [
                _buildActionCard(
                  "Log Workout",
                  Icons.add_circle_outline,
                  Colors.orange,
                  () => Get.toNamed(Routes.AI_LOG),
                ),
                _buildActionCard(
                  "Exercises",
                  Icons.list_alt,
                  Colors.teal,
                  () => controller.changePage(2),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[700]),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String content, Color bgColor, Color textColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        content.isEmpty ? "No data available yet. Start training!" : content,
        style: TextStyle(color: textColor, fontSize: 15, height: 1.5),
      ),
    );
  }

  Widget _buildActionCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

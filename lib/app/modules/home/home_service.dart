import 'package:fittrack_mobile/app/core/network/api_client.dart';

class HomeService {
  final ApiClient _client = ApiClient();

  Future<String> getWeeklyAiCoach() async {
    final response = await _client.dio.get('/ai/coach/weekly');
    return response.data.toString();
  }

  Future<String> getWeeklyStats() async {
    final response = await _client.dio.get('/stats/weekly');
    return response.data.toString();
  }
}

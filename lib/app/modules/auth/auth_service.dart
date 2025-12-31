import 'package:fittrack_mobile/app/core/network/api_client.dart';
import 'package:fittrack_mobile/app/core/storage/token_storage.dart';
import 'package:get/get.dart';

class AuthService {
  final ApiClient _client = ApiClient();

  Future<void> login(String identifier, String password) async {
    // Determine if identifier is email or username
    final isEmail = GetUtils.isEmail(identifier);
    final data = {
      "username": isEmail ? null : identifier,
      "email": isEmail ? identifier : null,
      "password": password,
    };

    final response = await _client.dio.post('/auth/login', data: data);

    final token = response.data['access_token'];
    await TokenStorage.saveToken(token);
  }

  Future<void> register(String username, String email, String password) async {
    await _client.dio.post(
      '/auth/register',
      data: {"username": username, "email": email, "password": password},
    );

    // Auto-login after successful registration
    await login(username, password);
  }
}

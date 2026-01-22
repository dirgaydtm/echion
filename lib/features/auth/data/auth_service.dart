import '../../../core/dio_client.dart';
import 'user_model.dart';

class AuthService {
  /// Signup
  static Future<void> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    await DioClient.post(
      '/auth/signup',
      data: {'name': name, 'email': email, 'password': password},
    );
  }

  /// Login
  static Future<(String token, UserModel user)> login({
    required String email,
    required String password,
  }) async {
    final response = await DioClient.post(
      '/auth/login',
      data: {'email': email, 'password': password},
    );
    final token = response.data['token'] as String;
    final user = UserModel.fromJson(response.data['user']);
    return (token, user);
  }

  /// Ambil user skrg
  static Future<UserModel> getCurrentUser() async {
    final response = await DioClient.get('/auth/', auth: true);
    return UserModel.fromJson(response.data);
  }
}

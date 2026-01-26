import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/constants/constants.dart';
import '../data/auth_service.dart';
import '../data/user_model.dart';

class AuthState {
  final UserModel? user;
  final bool isLoading;
  final String? error;

  const AuthState({this.user, this.isLoading = false, this.error});

  bool get isLoggedIn => user != null;

  AuthState copyWith({UserModel? user, bool? isLoading, String? error}) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  Box get _box => Hive.box(authBoxName);

  @override
  AuthState build() => const AuthState();

  Future<void> checkAuthStatus() async {
    final token = _box.get(tokenKey);
    final userJson = _box.get(userKey);

    if (token != null && userJson != null) {
      final cachedUser = UserModel.fromJson(jsonDecode(userJson));
      state = state.copyWith(user: cachedUser);
      try {
        final currentUser = await AuthService.getCurrentUser();
        state = state.copyWith(user: currentUser);
        await _box.put(userKey, jsonEncode(currentUser.toJson()));
      } on DioException {
        if (_box.get(tokenKey) == null) {
          state = const AuthState();
        }
      }
    }
  }

  Future<bool> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await AuthService.signup(name: name, email: email, password: password);
      // otomatis login abis signup
      return await login(email: email, password: password);
    } on DioException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
      return false;
    }
  }

  Future<bool> login({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final (token, user) = await AuthService.login(
        email: email,
        password: password,
      );
      await _box.put(tokenKey, token);
      await _box.put(userKey, jsonEncode(user.toJson()));
      state = state.copyWith(user: user, isLoading: false);
      return true;
    } on DioException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
      return false;
    }
  }

  Future<void> logout() async {
    await _box.delete(tokenKey);
    await _box.delete(userKey);
    state = const AuthState();
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
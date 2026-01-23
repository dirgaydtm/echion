import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/constants.dart';
import '../../../core/data/cache_service.dart';

class SettingsState {
  final ThemeMode themeMode;
  final String cacheSize;
  final bool isClearingCache;

  const SettingsState({
    this.themeMode = ThemeMode.system,
    this.cacheSize = '0 B',
    this.isClearingCache = false,
  });

  SettingsState copyWith({
    ThemeMode? themeMode,
    String? cacheSize,
    bool? isClearingCache,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      cacheSize: cacheSize ?? this.cacheSize,
      isClearingCache: isClearingCache ?? this.isClearingCache,
    );
  }
}

class SettingsNotifier extends Notifier<SettingsState> {
  Box get _box => Hive.box(authBoxName);

  @override
  SettingsState build() {
    final themeMode = _loadThemeMode();
    _loadCacheSize();
    return SettingsState(themeMode: themeMode);
  }

  ThemeMode _loadThemeMode() {
    final savedMode = _box.get(themeModeKey, defaultValue: 'system');
    return _themeModeFromString(savedMode);
  }

  Future<void> _loadCacheSize() async {
    final size = await CacheService.getFormattedCacheSize();
    state = state.copyWith(cacheSize: size);
  }

  ThemeMode _themeModeFromString(String mode) {
    switch (mode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      default:
        return 'system';
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    await _box.put(themeModeKey, _themeModeToString(mode));
  }

  Future<void> clearCache() async {
    state = state.copyWith(isClearingCache: true);
    await CacheService.clearCache();
    await _loadCacheSize();
    state = state.copyWith(isClearingCache: false);
  }
}

final settingsProvider = NotifierProvider<SettingsNotifier, SettingsState>(
  SettingsNotifier.new,
);

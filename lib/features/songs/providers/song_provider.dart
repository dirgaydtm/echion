import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/constants.dart';
import '../data/song_model.dart';
import '../data/song_service.dart';

class SongsState {
  final List<SongModel> allSongs;
  final List<SongModel> mySongs;
  final bool isLoading;
  final String? error;

  const SongsState({
    this.allSongs = const [],
    this.mySongs = const [],
    this.isLoading = false,
    this.error,
  });

  SongsState copyWith({
    List<SongModel>? allSongs,
    List<SongModel>? mySongs,
    bool? isLoading,
    String? error,
  }) {
    return SongsState(
      allSongs: allSongs ?? this.allSongs,
      mySongs: mySongs ?? this.mySongs,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class SongsNotifier extends Notifier<SongsState> {
  Box get _box => Hive.box(songsBoxName);

  @override
  SongsState build() => const SongsState();

  Future<void> _refreshSongs() async {
    await fetchAllSongs();
    await fetchMySongs();
  }

  void loadFromCache() {
    final allSongsJson = _box.get('all_songs');
    final mySongsJson = _box.get('my_songs');

    if (allSongsJson != null) {
      final List decoded = jsonDecode(allSongsJson);
      final songs = decoded.map((e) => SongModel.fromJson(e)).toList();
      state = state.copyWith(allSongs: songs);
    }

    if (mySongsJson != null) {
      final List decoded = jsonDecode(mySongsJson);
      final songs = decoded.map((e) => SongModel.fromJson(e)).toList();
      state = state.copyWith(mySongs: songs);
    }
  }

  Future<void> fetchAllSongs() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final songs = await SongService.getAllSongs();
      state = state.copyWith(allSongs: songs, isLoading: false);
      final json = jsonEncode(songs.map((s) => s.toJson()).toList());
      await _box.put('all_songs', json);
    } on DioException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    }
  }

  Future<void> fetchMySongs() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final songs = await SongService.getMySongs();
      state = state.copyWith(mySongs: songs, isLoading: false);
      final json = jsonEncode(songs.map((s) => s.toJson()).toList());
      await _box.put('my_songs', json);
    } on DioException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    }
  }

  Future<bool> uploadSong({
    required String filePath,
    required String thumbnailPath,
    required String title,
    required String artist,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await SongService.uploadSong(
        filePath: filePath,
        thumbnailPath: thumbnailPath,
        title: title,
        artist: artist,
      );
      state = state.copyWith(isLoading: false);
      await _refreshSongs();
      return true;
    } on DioException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
      return false;
    }
  }

  Future<bool> updateSong({
    required String songId,
    required String title,
    required String artist,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await SongService.updateSong(
        songId: songId,
        title: title,
        artist: artist,
      );
      state = state.copyWith(isLoading: false);
      await _refreshSongs();
      return true;
    } on DioException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
      return false;
    }
  }

  Future<bool> deleteSong(String songId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await SongService.deleteSong(songId);
      state = state.copyWith(isLoading: false);
      await _refreshSongs();
      return true;
    } on DioException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
      return false;
    }
  }

  Future<void> clearData() async {
    await _box.delete('all_songs');
    await _box.delete('my_songs');
    state = const SongsState();
  }
}

final songsProvider = NotifierProvider<SongsNotifier, SongsState>(
  SongsNotifier.new,
);

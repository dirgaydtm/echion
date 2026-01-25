import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import '../../../core/data/cache_service.dart';
import '../data/song_model.dart';

class PlayerState {
  final SongModel? currentSong;
  final List<SongModel> playlist;
  final int currentIndex;
  final bool isPlaying;
  final bool isBuffering;
  final Duration position;
  final Duration duration;
  final String? error;

  const PlayerState({
    this.currentSong,
    this.playlist = const [],
    this.currentIndex = 0,
    this.isPlaying = false,
    this.isBuffering = false,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.error,
  });

  PlayerState copyWith({
    SongModel? currentSong,
    List<SongModel>? playlist,
    int? currentIndex,
    bool? isPlaying,
    bool? isBuffering,
    Duration? position,
    Duration? duration,
    String? error,
  }) {
    return PlayerState(
      currentSong: currentSong ?? this.currentSong,
      playlist: playlist ?? this.playlist,
      currentIndex: currentIndex ?? this.currentIndex,
      isPlaying: isPlaying ?? this.isPlaying,
      isBuffering: isBuffering ?? this.isBuffering,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      error: error,
    );
  }

  bool get hasPrevious => currentIndex > 0;
  bool get hasNext => currentIndex < playlist.length - 1;
}

class PlayerNotifier extends Notifier<PlayerState> {
  late final AudioPlayer _player;

  @override
  PlayerState build() {
    _player = AudioPlayer();
    _initPlayer();

    ref.onDispose(() {
      _player.dispose();
    });

    return const PlayerState();
  }

  void _initPlayer() {
    _player.playerStateStream.listen((playerState) {
      state = state.copyWith(isPlaying: playerState.playing);
    });

    _player.positionStream.listen((position) {
      state = state.copyWith(position: position);
    });

    _player.durationStream.listen((duration) {
      if (duration != null) {
        state = state.copyWith(duration: duration);
      }
    });

    _player.processingStateStream.listen((processingState) {
      if (processingState == ProcessingState.completed) {
        if (state.hasNext) {
          next();
        } else {
          state = state.copyWith(isPlaying: false);
        }
      }
      state = state.copyWith(
        isBuffering:
            processingState == ProcessingState.buffering ||
            processingState == ProcessingState.loading,
      );
    });
  }

  Future<void> _loadAndPlay(SongModel song) async {
    try {
      if (await CacheService.isDownloaded(song.id)) {
        final localPath = await CacheService.getLocalPath(song.id);
        await _player.setFilePath(localPath);
      } else {
        await _player.setUrl(song.songUrl);
        CacheService.downloadSong(songId: song.id, url: song.songUrl);
      }
      await _player.play();
    } catch (e) {
      if (state.hasNext) {
        await next();
      }
      state = state.copyWith(error: "Failed to load song");
    }
  }

  Future<void> playSong(SongModel song, List<SongModel> playlist) async {
    final index = playlist.indexWhere((s) => s.id == song.id);
    state = state.copyWith(
      currentSong: song,
      playlist: playlist,
      currentIndex: index >= 0 ? index : 0,
      isBuffering: true,
      error: null,
    );
    await _loadAndPlay(song);
  }

  Future<void> next() async {
    if (state.hasNext) {
      final nextIndex = state.currentIndex + 1;
      final nextSong = state.playlist[nextIndex];
      state = state.copyWith(
        currentSong: nextSong,
        currentIndex: nextIndex,
        isBuffering: true,
        error: null,
      );
      await _loadAndPlay(nextSong);
    }
  }

  Future<void> previous() async {
    if (state.hasPrevious) {
      final prevIndex = state.currentIndex - 1;
      final prevSong = state.playlist[prevIndex];
      state = state.copyWith(
        currentSong: prevSong,
        currentIndex: prevIndex,
        isBuffering: true,
        error: null,
      );
      await _loadAndPlay(prevSong);
    }
  }

  Future<void> playPause() async {
    if (_player.playing) {
      await _player.pause();
    } else {
      await _player.play();
    }
  }

  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  Future<void> stop() async {
    await _player.stop();
    state = const PlayerState();
  }
}

final playerProvider = NotifierProvider<PlayerNotifier, PlayerState>(
  PlayerNotifier.new,
);

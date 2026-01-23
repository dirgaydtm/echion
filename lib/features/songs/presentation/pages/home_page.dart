import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/song_provider.dart';
import '../../providers/player_provider.dart';
import '../widgets/song_tile.dart';
import '../widgets/mini_player.dart';
import '../widgets/search_bar.dart' as app;
import '../../../../core/widgets/empty_state.dart';
import 'player_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(songsProvider.notifier).loadFromCache();
      ref.read(songsProvider.notifier).fetchAllSongs();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final songsState = ref.watch(songsProvider);
    final playerState = ref.watch(playerProvider);

    final filteredSongs = songsState.allSongs.where((song) {
      final query = _searchQuery.toLowerCase();
      return song.title.toLowerCase().contains(query) ||
          song.artist.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Echion'), centerTitle: true),
      body: Column(
        children: [
          app.SearchBar(
            controller: _searchController,
            hintText: 'Search songs...',
            onChanged: (v) => setState(() => _searchQuery = v),
          ),
          Expanded(child: _buildContent(songsState, playerState, filteredSongs)),
          if (playerState.currentSong != null) const MiniPlayer(),
        ],
      ),
    );
  }

  Widget _buildContent(SongsState songsState, PlayerState playerState, List filteredSongs) {
    if (songsState.isLoading && songsState.allSongs.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (filteredSongs.isEmpty) {
      return EmptyState(
        icon: Icons.music_off_rounded,
        message: _searchQuery.isNotEmpty ? 'No songs found' : 'No songs yet',
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(songsProvider.notifier).fetchAllSongs(),
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 80),
        itemCount: filteredSongs.length,
        itemBuilder: (context, index) {
          final song = filteredSongs[index];
          return SongTile(
            song: song,
            isPlaying: playerState.currentSong?.id == song.id,
            onTap: () {
              ref.read(playerProvider.notifier).playSong(song, filteredSongs.cast());
              Navigator.push(context, MaterialPageRoute(builder: (_) => const PlayerPage()));
            },
          );
        },
      ),
    );
  }
}

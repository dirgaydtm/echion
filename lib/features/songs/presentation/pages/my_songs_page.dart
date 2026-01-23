import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/snackbar_helper.dart';
import '../../providers/song_provider.dart';
import '../../providers/player_provider.dart';
import '../../data/song_model.dart';
import '../widgets/song_tile.dart';
import '../widgets/mini_player.dart';
import '../widgets/edit_song_dialog.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/confirm_dialog.dart';
import 'player_page.dart';
import 'upload_page.dart';

class MySongsPage extends ConsumerStatefulWidget {
  const MySongsPage({super.key});

  @override
  ConsumerState<MySongsPage> createState() => _MySongsPageState();
}

class _MySongsPageState extends ConsumerState<MySongsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(songsProvider.notifier).fetchMySongs());
  }

  Future<void> _editSong(SongModel song) async {
    final result = await showEditSongDialog(
      context: context,
      initialTitle: song.title,
      initialArtist: song.artist,
    );
    if (result != null) {
      final success = await ref.read(songsProvider.notifier).updateSong(
            songId: song.id,
            title: result.$1,
            artist: result.$2,
          );
      if (mounted) {
        showSnackBar(context, success ? 'Song updated!' : 'Failed to update');
      }
    }
  }

  Future<void> _deleteSong(SongModel song) async {
    final confirmed = await showConfirmDialog(
      context: context,
      title: 'Delete Song',
      message: 'Are you sure you want to delete "${song.title}"?',
      confirmLabel: 'Delete',
      isDestructive: true,
    );
    if (confirmed) {
      final success = await ref.read(songsProvider.notifier).deleteSong(song.id);
      if (mounted) {
        showSnackBar(context, success ? 'Song deleted!' : 'Failed to delete');
      }
    }
  }

  void _goToUpload() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const UploadPage()));
  }

  @override
  Widget build(BuildContext context) {
    final songsState = ref.watch(songsProvider);
    final playerState = ref.watch(playerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Songs'), centerTitle: true),
      body: Column(
        children: [
          Expanded(child: _buildContent(songsState, playerState)),
          if (playerState.currentSong != null) const MiniPlayer(),
        ],
      ),
      floatingActionButton: songsState.mySongs.isNotEmpty
          ? FloatingActionButton(onPressed: _goToUpload, child: const Icon(Icons.add))
          : null,
    );
  }

  Widget _buildContent(SongsState songsState, PlayerState playerState) {
    if (songsState.isLoading && songsState.mySongs.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (songsState.mySongs.isEmpty) {
      return EmptyState(
        icon: Icons.library_music_outlined,
        message: "You haven't uploaded any songs yet",
        actionLabel: 'Upload Song',
        onAction: _goToUpload,
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(songsProvider.notifier).fetchMySongs(),
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 80),
        itemCount: songsState.mySongs.length,
        itemBuilder: (context, index) {
          final song = songsState.mySongs[index];
          return SongTile(
            song: song,
            isPlaying: playerState.currentSong?.id == song.id,
            onTap: () {
              ref.read(playerProvider.notifier).playSong(song, songsState.mySongs);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const PlayerPage()));
            },
            trailing: PopupMenuButton(
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'edit', child: Row(children: [Icon(Icons.edit), SizedBox(width: 8), Text('Edit')])),
                PopupMenuItem(value: 'delete', child: Row(children: [Icon(Icons.delete), SizedBox(width: 8), Text('Delete')])),
              ],
              onSelected: (v) => v == 'edit' ? _editSong(song) : _deleteSong(song),
            ),
          );
        },
      ),
    );
  }
}

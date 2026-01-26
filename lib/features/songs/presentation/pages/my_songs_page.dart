import 'package:echion/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_transition/page_transition.dart';
import '../../../../core/utils/snackbar_helper.dart';
import '../../providers/song_provider.dart';
import '../../providers/player_provider.dart';
import '../../data/song_model.dart';
import '../widgets/song_tile.dart';
import '../widgets/mini_player.dart';
import '../widgets/edit_song_dialog.dart';
import '../widgets/song_options_menu.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/confirm_dialog.dart';
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
      final success = await ref
          .read(songsProvider.notifier)
          .updateSong(songId: song.id, title: result.$1, artist: result.$2);
      if (!mounted) return;

      if (success) {
        showSnackBar(context, 'Song updated successfully');
      } else {
        final error = ref.read(songsProvider).error;
        showSnackBar(context, error ?? 'Failed to update song');
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
      final success = await ref
          .read(songsProvider.notifier)
          .deleteSong(song.id);

      if (!mounted) return;

      if (success) {
        showSnackBar(context, 'Song deleted successfully');
      } else {
        final error = ref.read(songsProvider).error;
        showSnackBar(context, error ?? 'Failed to delete song');
      }
    }
  }

  void _goToUpload() {
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.bottomToTop,
        duration: const Duration(milliseconds: 400),
        reverseDuration: const Duration(milliseconds: 200),
        isIos: true,
        child: const UploadPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final songsState = ref.watch(songsProvider);
    final playerState = ref.watch(playerProvider);

    ref.listen<PlayerState>(playerProvider, (previous, next) {
      if (next.error != null && next.error != previous?.error) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showSnackBar(context, next.error!);
        });
      }
    });

    return Scaffold(
      appBar: CustomAppBar(title: 'My Songs'),
      body: Column(
        children: [
          Expanded(child: _buildContent(songsState, playerState)),
          if (playerState.currentSong != null) const MiniPlayer(),
        ],
      ),
      floatingActionButton: songsState.mySongs.isNotEmpty
          ? Padding(
              padding: EdgeInsets.only(
                bottom: playerState.currentSong != null ? 64 : 0,
              ),
              child: FloatingActionButton(
                onPressed: _goToUpload,
                shape: const CircleBorder(),
                child: const Icon(Icons.add),
              ),
            )
          : null,
    );
  }

  Widget _buildContent(SongsState songsState, PlayerState playerState) {
    if (songsState.isLoading && songsState.mySongs.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (songsState.mySongs.isEmpty) {
      return EmptyState(
        icon: Icons.music_note_outlined,
        message: "It's a bit quiet here, let's add some tunes",
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
              ref
                  .read(playerProvider.notifier)
                  .playSong(song, songsState.mySongs);
            },
            trailing: SongOptionsMenu(
              onEdit: () => _editSong(song),
              onDelete: () => _deleteSong(song),
            ),
          );
        },
      ),
    );
  }
}

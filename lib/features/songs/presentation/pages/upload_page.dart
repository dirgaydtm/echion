import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../core/utils/snackbar_helper.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/loading_button.dart';
import '../../providers/song_provider.dart';
import '../widgets/file_picker_tile.dart';

class UploadPage extends ConsumerStatefulWidget {
  const UploadPage({super.key});

  @override
  ConsumerState<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends ConsumerState<UploadPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _artistController = TextEditingController();

  String? _songPath;
  String? _songName;
  String? _thumbnailPath;
  String? _thumbnailName;

  @override
  void dispose() {
    _titleController.dispose();
    _artistController.dispose();
    super.dispose();
  }

  Future<void> _pickSong() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result != null && result.files.single.path != null) {
      setState(() {
        _songPath = result.files.single.path;
        _songName = result.files.single.name;
      });
    }
  }

  Future<void> _pickThumbnail() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.single.path != null) {
      setState(() {
        _thumbnailPath = result.files.single.path;
        _thumbnailName = result.files.single.name;
      });
    }
  }

  Future<void> _upload() async {
    if (!_formKey.currentState!.validate()) return;
    if (_songPath == null || _thumbnailPath == null) {
      showSnackBar(context, 'Please select both song and thumbnail');
      return;
    }

    final success = await ref
        .read(songsProvider.notifier)
        .uploadSong(
          filePath: _songPath!,
          thumbnailPath: _thumbnailPath!,
          title: _titleController.text.trim(),
          artist: _artistController.text.trim(),
        );

    if (mounted) {
      if (success) {
        showSnackBar(context, 'Song uploaded successfully!');
        Navigator.pop(context);
      } else {
        final error = ref.read(songsProvider).error;
        showSnackBar(context, error ?? 'Failed to upload song');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final songsState = ref.watch(songsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Upload Song')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FilePickerTile(
                label: 'Song File',
                icon: Icons.music_note,
                fileName: _songName,
                onTap: _pickSong,
              ),
              const SizedBox(height: 16),
              FilePickerTile(
                label: 'Thumbnail',
                icon: Icons.image,
                fileName: _thumbnailName,
                onTap: _pickThumbnail,
              ),
              const SizedBox(height: 16),

              AppTextField(
                controller: _titleController,
                labelText: 'Title',
                prefixIcon: Icons.title,
                validator: (value) =>
                    AppValidator.required(value, 'song title'),
              ),
              const SizedBox(height: 16),

              AppTextField(
                controller: _artistController,
                labelText: 'Artist',
                prefixIcon: Icons.person,
                validator: (value) =>
                    AppValidator.required(value, 'artist name'),
              ),
              const SizedBox(height: 32),

              LoadingButton(
                isLoading: songsState.isLoading,
                onPressed: _upload,
                label: 'Upload',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

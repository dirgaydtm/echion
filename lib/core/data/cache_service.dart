import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import '../dio_client.dart';

class CacheService {
  static const String _audioCacheDir = 'audio_cache';

  static Future<Directory> _getCacheDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final cacheDir = Directory('${appDir.path}/$_audioCacheDir');
    if (!await cacheDir.exists()) {
      await cacheDir.create(recursive: true);
    }
    return cacheDir;
  }

  static Future<String> getLocalPath(String songId) async {
    final cacheDir = await _getCacheDirectory();
    return '${cacheDir.path}/$songId.mp3';
  }

  static Future<bool> isDownloaded(String songId) async {
    final path = await getLocalPath(songId);
    return File(path).exists();
  }

  static Future<void> downloadSong({
    required String songId,
    required String url,
  }) async {
    try {
      final localPath = await getLocalPath(songId);
      await DioClient.instance.download(url, localPath);
    } catch (e) {
      debugPrint('Download failed - $e');
    }
  }

  static Future<String> getFormattedCacheSize() async {
    try {
      final cacheDir = await _getCacheDirectory();
      if (!await cacheDir.exists()) return '0 B';

      int bytes = 0;
      await for (final entity in cacheDir.list()) {
        if (entity is File) bytes += await entity.length();
      }

      if (bytes < 1024) return '$bytes B';
      if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
      if (bytes < 1024 * 1024 * 1024) {
        return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
      }
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    } catch (e) {
      debugPrint('Cache size error: $e');
      return 'Calculating...';
    }
  }

  static Future<void> clearCache() async {
    try {
      final cacheDir = await _getCacheDirectory();
      if (await cacheDir.exists()) {
        await cacheDir.delete(recursive: true);
        await cacheDir.create();
      }
      await CachedNetworkImage.evictFromCache('');
      PaintingBinding.instance.imageCache.clear();
      PaintingBinding.instance.imageCache.clearLiveImages();
    } catch (e) {
      debugPrint('Clear cache error: $e');
    }
  }
}
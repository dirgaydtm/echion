import 'package:dio/dio.dart';
import '../../../core/dio_client.dart';
import 'song_model.dart';

class SongService {
  static Future<List<SongModel>> getAllSongs() async {
    final response = await DioClient.get('/songs/getall');
    final List data = response.data;
    return data.map((json) => SongModel.fromJson(json)).toList();
  }

  static Future<List<SongModel>> getMySongs() async {
    final response = await DioClient.get('/songs/me', auth: true);
    final List data = response.data;
    return data.map((json) => SongModel.fromJson(json)).toList();
  }

  static Future<SongModel> uploadSong({
    required String filePath,
    required String thumbnailPath,
    required String title,
    required String artist,
  }) async {
    final formData = FormData.fromMap({
      'song': await MultipartFile.fromFile(filePath),
      'thumbnail': await MultipartFile.fromFile(thumbnailPath),
      'title': title,
      'artist': artist,
    });

    final response = await DioClient.postFormData(
      '/songs/upload',
      formData: formData,
      auth: true,
    );
    return SongModel.fromJson(response.data);
  }

  static Future<SongModel> updateSong({
    required String songId,
    required String title,
    required String artist,
  }) async {
    final response = await DioClient.put(
      '/songs/update/$songId',
      data: {'title': title, 'artist': artist},
      auth: true,
    );
    return SongModel.fromJson(response.data);
  }

  static Future<void> deleteSong(String songId) async {
    await DioClient.delete('/songs/delete/$songId', auth: true);
  }
}


class SongModel {
  final String id;
  final String songUrl;
  final String thumbnailUrl;
  final String artist;
  final String title;
  final String userId;

  SongModel({
    required this.id,
    required this.songUrl,
    required this.thumbnailUrl,
    required this.artist,
    required this.title,
    required this.userId,
  });

  factory SongModel.fromJson(Map<String, dynamic> json) {
    return SongModel(
      id: json['id'] ?? '',
      songUrl: json['song_url'] ?? '',
      thumbnailUrl: json['thumbnail_url'] ?? '',
      artist: json['artist'] ?? '',
      title: json['title'] ?? '',
      userId: json['user_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'song_url': songUrl,
      'thumbnail_url': thumbnailUrl,
      'artist': artist,
      'title': title,
      'user_id': userId,
    };
  }
}

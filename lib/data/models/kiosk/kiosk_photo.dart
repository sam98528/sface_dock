/// Model for the /kiosk/photos API response.
/// Each object represents a single image (one feed can have multiple images).
class KioskPhoto {
  final String postId;
  final String ownerId;
  final String ownerUsername;
  final String attachedMediaDisplayUrl;
  final int timestamp;

  const KioskPhoto({
    required this.postId,
    required this.ownerId,
    required this.ownerUsername,
    required this.attachedMediaDisplayUrl,
    required this.timestamp,
  });

  factory KioskPhoto.fromJson(Map<String, dynamic> json) {
    return KioskPhoto(
      postId: json['post_id']?.toString() ?? '',
      ownerId: json['owner_id']?.toString() ?? '',
      ownerUsername: json['owner_username']?.toString() ?? '',
      attachedMediaDisplayUrl:
          json['attached_media_display_url']?.toString() ?? '',
      timestamp: (json['timestamp'] as num?)?.toInt() ?? 0,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KioskPhoto &&
          postId == other.postId &&
          attachedMediaDisplayUrl == other.attachedMediaDisplayUrl;

  @override
  int get hashCode => postId.hashCode ^ attachedMediaDisplayUrl.hashCode;
}

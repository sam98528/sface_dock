import 'package:sfacedock/core/constants/api_constants.dart';

/// User info embedded in /kiosk/photos response.
class KioskPhotoUserInfo {
  final String memNickname;
  final String? profileImgPath;

  const KioskPhotoUserInfo({
    required this.memNickname,
    this.profileImgPath,
  });

  factory KioskPhotoUserInfo.fromJson(Map<String, dynamic> json) {
    return KioskPhotoUserInfo(
      memNickname: json['mem_nickname']?.toString() ?? '',
      profileImgPath: json['profile_img_path']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'mem_nickname': memNickname,
    'profile_img_path': profileImgPath,
  };
}

/// Model for the /kiosk/photos API response.
/// Each object represents a single image (one feed can have multiple images).
class KioskPhoto {
  final String postId;
  final String ownerId;
  final String ownerUsername;

  /// 화면 표시용 URL (RESIZE_CDN + filters). 그리드/상세 등 UI에서 사용.
  final String attachedMediaDisplayUrl;

  /// 인쇄용 원본 URL (AWS_IP). 원본 화질로 출력 시 사용.
  final String originalImageUrl;

  final int timestamp;
  final String feedsContent;
  final int feedsLike;
  final int feedsFavorite;
  final KioskPhotoUserInfo feedUserInfo;

  const KioskPhoto({
    required this.postId,
    required this.ownerId,
    required this.ownerUsername,
    required this.attachedMediaDisplayUrl,
    required this.originalImageUrl,
    required this.timestamp,
    required this.feedsContent,
    required this.feedsLike,
    required this.feedsFavorite,
    required this.feedUserInfo,
  });

  factory KioskPhoto.fromJson(Map<String, dynamic> json) {
    final rawPath = json['attached_media_display_url']?.toString() ?? '';

    // 표시용: RESIZE_CDN + filters (Thumbor path 형식)
    final displayUrl = rawPath.startsWith('http')
        ? rawPath
        : '${ApiConstants.resizeCdn}filters:quality(90):format(webp)/$rawPath';

    // 인쇄용: AWS_IP 원본
    final originalUrl = rawPath.startsWith('http')
        ? rawPath
        : '${ApiConstants.awsIp}$rawPath';

    final userInfoJson = json['feed_user_info'];
    final feedUserInfo = userInfoJson is Map<String, dynamic>
        ? KioskPhotoUserInfo.fromJson(userInfoJson)
        : KioskPhotoUserInfo(
            memNickname: json['owner_username']?.toString() ?? '',
          );

    return KioskPhoto(
      postId: json['post_id']?.toString() ?? '',
      ownerId: json['owner_id']?.toString() ?? '',
      ownerUsername: json['owner_username']?.toString() ?? '',
      attachedMediaDisplayUrl: displayUrl,
      originalImageUrl: originalUrl,
      timestamp: (json['timestamp'] as num?)?.toInt() ?? 0,
      feedsContent: json['feeds_content']?.toString() ?? '',
      feedsLike: (json['feeds_like'] as num?)?.toInt() ?? 0,
      feedsFavorite: (json['feeds_favorite'] as num?)?.toInt() ?? 0,
      feedUserInfo: feedUserInfo,
    );
  }

  Map<String, dynamic> toJson() => {
    'post_id': postId,
    'owner_id': ownerId,
    'owner_username': ownerUsername,
    'attached_media_display_url': attachedMediaDisplayUrl,
    'original_image_url': originalImageUrl,
    'timestamp': timestamp,
    'feeds_content': feedsContent,
    'feeds_like': feedsLike,
    'feeds_favorite': feedsFavorite,
    'feed_user_info': feedUserInfo.toJson(),
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KioskPhoto &&
          postId == other.postId &&
          attachedMediaDisplayUrl == other.attachedMediaDisplayUrl;

  @override
  int get hashCode => postId.hashCode ^ attachedMediaDisplayUrl.hashCode;
}

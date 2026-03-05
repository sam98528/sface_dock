// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PhotoDetailImpl _$$PhotoDetailImplFromJson(Map<String, dynamic> json) =>
    _$PhotoDetailImpl(
      feedsIdx: (json['feeds_idx'] as num).toInt(),
      memIdx: (json['mem_idx'] as num).toInt(),
      groupIdx: (json['group_idx'] as num).toInt(),
      artistIdx: (json['artist_idx'] as num).toInt(),
      feedsContent: json['feeds_content'] as String,
      feedsImgAttach: (json['feeds_img_attach'] as List<dynamic>)
          .map((e) => FeedsImgAttach.fromJson(e as Map<String, dynamic>))
          .toList(),
      feedsCreatedAt: json['feeds_created_at'] as String,
      feedsLike: (json['feeds_like'] as num).toInt(),
      feedsViewCount: (json['feeds_view_count'] as num).toInt(),
      feedsCommentLength: (json['feeds_comment_length'] as num).toInt(),
      feedsType: json['feeds_type'] as String,
      feedsPrice: (json['feeds_price'] as num).toInt(),
      feedsMaxLimit: (json['feeds_max_limit'] as num).toInt(),
      feedsSellLimitDate: json['feeds_sell_limit_date'] as String?,
      feedUserInfo:
          FeedUserInfo.fromJson(json['feed_user_info'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$PhotoDetailImplToJson(_$PhotoDetailImpl instance) =>
    <String, dynamic>{
      'feeds_idx': instance.feedsIdx,
      'mem_idx': instance.memIdx,
      'group_idx': instance.groupIdx,
      'artist_idx': instance.artistIdx,
      'feeds_content': instance.feedsContent,
      'feeds_img_attach': instance.feedsImgAttach,
      'feeds_created_at': instance.feedsCreatedAt,
      'feeds_like': instance.feedsLike,
      'feeds_view_count': instance.feedsViewCount,
      'feeds_comment_length': instance.feedsCommentLength,
      'feeds_type': instance.feedsType,
      'feeds_price': instance.feedsPrice,
      'feeds_max_limit': instance.feedsMaxLimit,
      'feeds_sell_limit_date': instance.feedsSellLimitDate,
      'feed_user_info': instance.feedUserInfo,
    };

_$FeedsImgAttachImpl _$$FeedsImgAttachImplFromJson(Map<String, dynamic> json) =>
    _$FeedsImgAttachImpl(
      attachFilePath: json['attach_file_path'] as String,
      videoAttachIdx: (json['video_attach_idx'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$FeedsImgAttachImplToJson(
        _$FeedsImgAttachImpl instance) =>
    <String, dynamic>{
      'attach_file_path': instance.attachFilePath,
      'video_attach_idx': instance.videoAttachIdx,
    };

_$FeedUserInfoImpl _$$FeedUserInfoImplFromJson(Map<String, dynamic> json) =>
    _$FeedUserInfoImpl(
      memNickname: json['mem_nickname'] as String,
      profileImgPath: json['profile_img_path'] as String?,
    );

Map<String, dynamic> _$$FeedUserInfoImplToJson(_$FeedUserInfoImpl instance) =>
    <String, dynamic>{
      'mem_nickname': instance.memNickname,
      'profile_img_path': instance.profileImgPath,
    };

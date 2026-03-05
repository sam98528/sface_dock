import 'package:freezed_annotation/freezed_annotation.dart';

part 'photo_detail.freezed.dart';
part 'photo_detail.g.dart';

@freezed
class PhotoDetail with _$PhotoDetail {
  const factory PhotoDetail({
    @JsonKey(name: 'feeds_idx') required int feedsIdx,
    @JsonKey(name: 'mem_idx') required int memIdx,
    @JsonKey(name: 'group_idx') required int groupIdx,
    @JsonKey(name: 'artist_idx') required int artistIdx,
    @JsonKey(name: 'feeds_content') required String feedsContent,
    @JsonKey(name: 'feeds_img_attach')
    required List<FeedsImgAttach> feedsImgAttach,
    @JsonKey(name: 'feeds_created_at') required String feedsCreatedAt,
    @JsonKey(name: 'feeds_like') required int feedsLike,
    @JsonKey(name: 'feeds_view_count') required int feedsViewCount,
    @JsonKey(name: 'feeds_comment_length') required int feedsCommentLength,
    @JsonKey(name: 'feeds_type') required String feedsType,
    @JsonKey(name: 'feeds_price') required int feedsPrice,
    @JsonKey(name: 'feeds_max_limit') required int feedsMaxLimit,
    @JsonKey(name: 'feeds_sell_limit_date') String? feedsSellLimitDate,
    @JsonKey(name: 'feed_user_info') required FeedUserInfo feedUserInfo,
  }) = _PhotoDetail;

  factory PhotoDetail.fromJson(Map<String, dynamic> json) =>
      _$PhotoDetailFromJson(json);
}

@freezed
class FeedsImgAttach with _$FeedsImgAttach {
  const factory FeedsImgAttach({
    @JsonKey(name: 'attach_file_path') required String attachFilePath,
    @JsonKey(name: 'video_attach_idx') int? videoAttachIdx,
  }) = _FeedsImgAttach;

  factory FeedsImgAttach.fromJson(Map<String, dynamic> json) =>
      _$FeedsImgAttachFromJson(json);
}

@freezed
class FeedUserInfo with _$FeedUserInfo {
  const factory FeedUserInfo({
    @JsonKey(name: 'mem_nickname') required String memNickname,
    @JsonKey(name: 'profile_img_path') String? profileImgPath,
  }) = _FeedUserInfo;

  factory FeedUserInfo.fromJson(Map<String, dynamic> json) =>
      _$FeedUserInfoFromJson(json);
}

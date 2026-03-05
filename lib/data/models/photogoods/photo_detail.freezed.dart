// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'photo_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PhotoDetail _$PhotoDetailFromJson(Map<String, dynamic> json) {
  return _PhotoDetail.fromJson(json);
}

/// @nodoc
mixin _$PhotoDetail {
  @JsonKey(name: 'feeds_idx')
  int get feedsIdx => throw _privateConstructorUsedError;
  @JsonKey(name: 'mem_idx')
  int get memIdx => throw _privateConstructorUsedError;
  @JsonKey(name: 'group_idx')
  int get groupIdx => throw _privateConstructorUsedError;
  @JsonKey(name: 'artist_idx')
  int get artistIdx => throw _privateConstructorUsedError;
  @JsonKey(name: 'feeds_content')
  String get feedsContent => throw _privateConstructorUsedError;
  @JsonKey(name: 'feeds_img_attach')
  List<FeedsImgAttach> get feedsImgAttach => throw _privateConstructorUsedError;
  @JsonKey(name: 'feeds_created_at')
  String get feedsCreatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'feeds_like')
  int get feedsLike => throw _privateConstructorUsedError;
  @JsonKey(name: 'feeds_view_count')
  int get feedsViewCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'feeds_comment_length')
  int get feedsCommentLength => throw _privateConstructorUsedError;
  @JsonKey(name: 'feeds_type')
  String get feedsType => throw _privateConstructorUsedError;
  @JsonKey(name: 'feeds_price')
  int get feedsPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'feeds_max_limit')
  int get feedsMaxLimit => throw _privateConstructorUsedError;
  @JsonKey(name: 'feeds_sell_limit_date')
  String? get feedsSellLimitDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'feed_user_info')
  FeedUserInfo get feedUserInfo => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PhotoDetailCopyWith<PhotoDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PhotoDetailCopyWith<$Res> {
  factory $PhotoDetailCopyWith(
          PhotoDetail value, $Res Function(PhotoDetail) then) =
      _$PhotoDetailCopyWithImpl<$Res, PhotoDetail>;
  @useResult
  $Res call(
      {@JsonKey(name: 'feeds_idx') int feedsIdx,
      @JsonKey(name: 'mem_idx') int memIdx,
      @JsonKey(name: 'group_idx') int groupIdx,
      @JsonKey(name: 'artist_idx') int artistIdx,
      @JsonKey(name: 'feeds_content') String feedsContent,
      @JsonKey(name: 'feeds_img_attach') List<FeedsImgAttach> feedsImgAttach,
      @JsonKey(name: 'feeds_created_at') String feedsCreatedAt,
      @JsonKey(name: 'feeds_like') int feedsLike,
      @JsonKey(name: 'feeds_view_count') int feedsViewCount,
      @JsonKey(name: 'feeds_comment_length') int feedsCommentLength,
      @JsonKey(name: 'feeds_type') String feedsType,
      @JsonKey(name: 'feeds_price') int feedsPrice,
      @JsonKey(name: 'feeds_max_limit') int feedsMaxLimit,
      @JsonKey(name: 'feeds_sell_limit_date') String? feedsSellLimitDate,
      @JsonKey(name: 'feed_user_info') FeedUserInfo feedUserInfo});

  $FeedUserInfoCopyWith<$Res> get feedUserInfo;
}

/// @nodoc
class _$PhotoDetailCopyWithImpl<$Res, $Val extends PhotoDetail>
    implements $PhotoDetailCopyWith<$Res> {
  _$PhotoDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? feedsIdx = null,
    Object? memIdx = null,
    Object? groupIdx = null,
    Object? artistIdx = null,
    Object? feedsContent = null,
    Object? feedsImgAttach = null,
    Object? feedsCreatedAt = null,
    Object? feedsLike = null,
    Object? feedsViewCount = null,
    Object? feedsCommentLength = null,
    Object? feedsType = null,
    Object? feedsPrice = null,
    Object? feedsMaxLimit = null,
    Object? feedsSellLimitDate = freezed,
    Object? feedUserInfo = null,
  }) {
    return _then(_value.copyWith(
      feedsIdx: null == feedsIdx
          ? _value.feedsIdx
          : feedsIdx // ignore: cast_nullable_to_non_nullable
              as int,
      memIdx: null == memIdx
          ? _value.memIdx
          : memIdx // ignore: cast_nullable_to_non_nullable
              as int,
      groupIdx: null == groupIdx
          ? _value.groupIdx
          : groupIdx // ignore: cast_nullable_to_non_nullable
              as int,
      artistIdx: null == artistIdx
          ? _value.artistIdx
          : artistIdx // ignore: cast_nullable_to_non_nullable
              as int,
      feedsContent: null == feedsContent
          ? _value.feedsContent
          : feedsContent // ignore: cast_nullable_to_non_nullable
              as String,
      feedsImgAttach: null == feedsImgAttach
          ? _value.feedsImgAttach
          : feedsImgAttach // ignore: cast_nullable_to_non_nullable
              as List<FeedsImgAttach>,
      feedsCreatedAt: null == feedsCreatedAt
          ? _value.feedsCreatedAt
          : feedsCreatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      feedsLike: null == feedsLike
          ? _value.feedsLike
          : feedsLike // ignore: cast_nullable_to_non_nullable
              as int,
      feedsViewCount: null == feedsViewCount
          ? _value.feedsViewCount
          : feedsViewCount // ignore: cast_nullable_to_non_nullable
              as int,
      feedsCommentLength: null == feedsCommentLength
          ? _value.feedsCommentLength
          : feedsCommentLength // ignore: cast_nullable_to_non_nullable
              as int,
      feedsType: null == feedsType
          ? _value.feedsType
          : feedsType // ignore: cast_nullable_to_non_nullable
              as String,
      feedsPrice: null == feedsPrice
          ? _value.feedsPrice
          : feedsPrice // ignore: cast_nullable_to_non_nullable
              as int,
      feedsMaxLimit: null == feedsMaxLimit
          ? _value.feedsMaxLimit
          : feedsMaxLimit // ignore: cast_nullable_to_non_nullable
              as int,
      feedsSellLimitDate: freezed == feedsSellLimitDate
          ? _value.feedsSellLimitDate
          : feedsSellLimitDate // ignore: cast_nullable_to_non_nullable
              as String?,
      feedUserInfo: null == feedUserInfo
          ? _value.feedUserInfo
          : feedUserInfo // ignore: cast_nullable_to_non_nullable
              as FeedUserInfo,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $FeedUserInfoCopyWith<$Res> get feedUserInfo {
    return $FeedUserInfoCopyWith<$Res>(_value.feedUserInfo, (value) {
      return _then(_value.copyWith(feedUserInfo: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PhotoDetailImplCopyWith<$Res>
    implements $PhotoDetailCopyWith<$Res> {
  factory _$$PhotoDetailImplCopyWith(
          _$PhotoDetailImpl value, $Res Function(_$PhotoDetailImpl) then) =
      __$$PhotoDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'feeds_idx') int feedsIdx,
      @JsonKey(name: 'mem_idx') int memIdx,
      @JsonKey(name: 'group_idx') int groupIdx,
      @JsonKey(name: 'artist_idx') int artistIdx,
      @JsonKey(name: 'feeds_content') String feedsContent,
      @JsonKey(name: 'feeds_img_attach') List<FeedsImgAttach> feedsImgAttach,
      @JsonKey(name: 'feeds_created_at') String feedsCreatedAt,
      @JsonKey(name: 'feeds_like') int feedsLike,
      @JsonKey(name: 'feeds_view_count') int feedsViewCount,
      @JsonKey(name: 'feeds_comment_length') int feedsCommentLength,
      @JsonKey(name: 'feeds_type') String feedsType,
      @JsonKey(name: 'feeds_price') int feedsPrice,
      @JsonKey(name: 'feeds_max_limit') int feedsMaxLimit,
      @JsonKey(name: 'feeds_sell_limit_date') String? feedsSellLimitDate,
      @JsonKey(name: 'feed_user_info') FeedUserInfo feedUserInfo});

  @override
  $FeedUserInfoCopyWith<$Res> get feedUserInfo;
}

/// @nodoc
class __$$PhotoDetailImplCopyWithImpl<$Res>
    extends _$PhotoDetailCopyWithImpl<$Res, _$PhotoDetailImpl>
    implements _$$PhotoDetailImplCopyWith<$Res> {
  __$$PhotoDetailImplCopyWithImpl(
      _$PhotoDetailImpl _value, $Res Function(_$PhotoDetailImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? feedsIdx = null,
    Object? memIdx = null,
    Object? groupIdx = null,
    Object? artistIdx = null,
    Object? feedsContent = null,
    Object? feedsImgAttach = null,
    Object? feedsCreatedAt = null,
    Object? feedsLike = null,
    Object? feedsViewCount = null,
    Object? feedsCommentLength = null,
    Object? feedsType = null,
    Object? feedsPrice = null,
    Object? feedsMaxLimit = null,
    Object? feedsSellLimitDate = freezed,
    Object? feedUserInfo = null,
  }) {
    return _then(_$PhotoDetailImpl(
      feedsIdx: null == feedsIdx
          ? _value.feedsIdx
          : feedsIdx // ignore: cast_nullable_to_non_nullable
              as int,
      memIdx: null == memIdx
          ? _value.memIdx
          : memIdx // ignore: cast_nullable_to_non_nullable
              as int,
      groupIdx: null == groupIdx
          ? _value.groupIdx
          : groupIdx // ignore: cast_nullable_to_non_nullable
              as int,
      artistIdx: null == artistIdx
          ? _value.artistIdx
          : artistIdx // ignore: cast_nullable_to_non_nullable
              as int,
      feedsContent: null == feedsContent
          ? _value.feedsContent
          : feedsContent // ignore: cast_nullable_to_non_nullable
              as String,
      feedsImgAttach: null == feedsImgAttach
          ? _value._feedsImgAttach
          : feedsImgAttach // ignore: cast_nullable_to_non_nullable
              as List<FeedsImgAttach>,
      feedsCreatedAt: null == feedsCreatedAt
          ? _value.feedsCreatedAt
          : feedsCreatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      feedsLike: null == feedsLike
          ? _value.feedsLike
          : feedsLike // ignore: cast_nullable_to_non_nullable
              as int,
      feedsViewCount: null == feedsViewCount
          ? _value.feedsViewCount
          : feedsViewCount // ignore: cast_nullable_to_non_nullable
              as int,
      feedsCommentLength: null == feedsCommentLength
          ? _value.feedsCommentLength
          : feedsCommentLength // ignore: cast_nullable_to_non_nullable
              as int,
      feedsType: null == feedsType
          ? _value.feedsType
          : feedsType // ignore: cast_nullable_to_non_nullable
              as String,
      feedsPrice: null == feedsPrice
          ? _value.feedsPrice
          : feedsPrice // ignore: cast_nullable_to_non_nullable
              as int,
      feedsMaxLimit: null == feedsMaxLimit
          ? _value.feedsMaxLimit
          : feedsMaxLimit // ignore: cast_nullable_to_non_nullable
              as int,
      feedsSellLimitDate: freezed == feedsSellLimitDate
          ? _value.feedsSellLimitDate
          : feedsSellLimitDate // ignore: cast_nullable_to_non_nullable
              as String?,
      feedUserInfo: null == feedUserInfo
          ? _value.feedUserInfo
          : feedUserInfo // ignore: cast_nullable_to_non_nullable
              as FeedUserInfo,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PhotoDetailImpl implements _PhotoDetail {
  const _$PhotoDetailImpl(
      {@JsonKey(name: 'feeds_idx') required this.feedsIdx,
      @JsonKey(name: 'mem_idx') required this.memIdx,
      @JsonKey(name: 'group_idx') required this.groupIdx,
      @JsonKey(name: 'artist_idx') required this.artistIdx,
      @JsonKey(name: 'feeds_content') required this.feedsContent,
      @JsonKey(name: 'feeds_img_attach')
      required final List<FeedsImgAttach> feedsImgAttach,
      @JsonKey(name: 'feeds_created_at') required this.feedsCreatedAt,
      @JsonKey(name: 'feeds_like') required this.feedsLike,
      @JsonKey(name: 'feeds_view_count') required this.feedsViewCount,
      @JsonKey(name: 'feeds_comment_length') required this.feedsCommentLength,
      @JsonKey(name: 'feeds_type') required this.feedsType,
      @JsonKey(name: 'feeds_price') required this.feedsPrice,
      @JsonKey(name: 'feeds_max_limit') required this.feedsMaxLimit,
      @JsonKey(name: 'feeds_sell_limit_date') this.feedsSellLimitDate,
      @JsonKey(name: 'feed_user_info') required this.feedUserInfo})
      : _feedsImgAttach = feedsImgAttach;

  factory _$PhotoDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$PhotoDetailImplFromJson(json);

  @override
  @JsonKey(name: 'feeds_idx')
  final int feedsIdx;
  @override
  @JsonKey(name: 'mem_idx')
  final int memIdx;
  @override
  @JsonKey(name: 'group_idx')
  final int groupIdx;
  @override
  @JsonKey(name: 'artist_idx')
  final int artistIdx;
  @override
  @JsonKey(name: 'feeds_content')
  final String feedsContent;
  final List<FeedsImgAttach> _feedsImgAttach;
  @override
  @JsonKey(name: 'feeds_img_attach')
  List<FeedsImgAttach> get feedsImgAttach {
    if (_feedsImgAttach is EqualUnmodifiableListView) return _feedsImgAttach;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_feedsImgAttach);
  }

  @override
  @JsonKey(name: 'feeds_created_at')
  final String feedsCreatedAt;
  @override
  @JsonKey(name: 'feeds_like')
  final int feedsLike;
  @override
  @JsonKey(name: 'feeds_view_count')
  final int feedsViewCount;
  @override
  @JsonKey(name: 'feeds_comment_length')
  final int feedsCommentLength;
  @override
  @JsonKey(name: 'feeds_type')
  final String feedsType;
  @override
  @JsonKey(name: 'feeds_price')
  final int feedsPrice;
  @override
  @JsonKey(name: 'feeds_max_limit')
  final int feedsMaxLimit;
  @override
  @JsonKey(name: 'feeds_sell_limit_date')
  final String? feedsSellLimitDate;
  @override
  @JsonKey(name: 'feed_user_info')
  final FeedUserInfo feedUserInfo;

  @override
  String toString() {
    return 'PhotoDetail(feedsIdx: $feedsIdx, memIdx: $memIdx, groupIdx: $groupIdx, artistIdx: $artistIdx, feedsContent: $feedsContent, feedsImgAttach: $feedsImgAttach, feedsCreatedAt: $feedsCreatedAt, feedsLike: $feedsLike, feedsViewCount: $feedsViewCount, feedsCommentLength: $feedsCommentLength, feedsType: $feedsType, feedsPrice: $feedsPrice, feedsMaxLimit: $feedsMaxLimit, feedsSellLimitDate: $feedsSellLimitDate, feedUserInfo: $feedUserInfo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PhotoDetailImpl &&
            (identical(other.feedsIdx, feedsIdx) ||
                other.feedsIdx == feedsIdx) &&
            (identical(other.memIdx, memIdx) || other.memIdx == memIdx) &&
            (identical(other.groupIdx, groupIdx) ||
                other.groupIdx == groupIdx) &&
            (identical(other.artistIdx, artistIdx) ||
                other.artistIdx == artistIdx) &&
            (identical(other.feedsContent, feedsContent) ||
                other.feedsContent == feedsContent) &&
            const DeepCollectionEquality()
                .equals(other._feedsImgAttach, _feedsImgAttach) &&
            (identical(other.feedsCreatedAt, feedsCreatedAt) ||
                other.feedsCreatedAt == feedsCreatedAt) &&
            (identical(other.feedsLike, feedsLike) ||
                other.feedsLike == feedsLike) &&
            (identical(other.feedsViewCount, feedsViewCount) ||
                other.feedsViewCount == feedsViewCount) &&
            (identical(other.feedsCommentLength, feedsCommentLength) ||
                other.feedsCommentLength == feedsCommentLength) &&
            (identical(other.feedsType, feedsType) ||
                other.feedsType == feedsType) &&
            (identical(other.feedsPrice, feedsPrice) ||
                other.feedsPrice == feedsPrice) &&
            (identical(other.feedsMaxLimit, feedsMaxLimit) ||
                other.feedsMaxLimit == feedsMaxLimit) &&
            (identical(other.feedsSellLimitDate, feedsSellLimitDate) ||
                other.feedsSellLimitDate == feedsSellLimitDate) &&
            (identical(other.feedUserInfo, feedUserInfo) ||
                other.feedUserInfo == feedUserInfo));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      feedsIdx,
      memIdx,
      groupIdx,
      artistIdx,
      feedsContent,
      const DeepCollectionEquality().hash(_feedsImgAttach),
      feedsCreatedAt,
      feedsLike,
      feedsViewCount,
      feedsCommentLength,
      feedsType,
      feedsPrice,
      feedsMaxLimit,
      feedsSellLimitDate,
      feedUserInfo);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PhotoDetailImplCopyWith<_$PhotoDetailImpl> get copyWith =>
      __$$PhotoDetailImplCopyWithImpl<_$PhotoDetailImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PhotoDetailImplToJson(
      this,
    );
  }
}

abstract class _PhotoDetail implements PhotoDetail {
  const factory _PhotoDetail(
      {@JsonKey(name: 'feeds_idx') required final int feedsIdx,
      @JsonKey(name: 'mem_idx') required final int memIdx,
      @JsonKey(name: 'group_idx') required final int groupIdx,
      @JsonKey(name: 'artist_idx') required final int artistIdx,
      @JsonKey(name: 'feeds_content') required final String feedsContent,
      @JsonKey(name: 'feeds_img_attach')
      required final List<FeedsImgAttach> feedsImgAttach,
      @JsonKey(name: 'feeds_created_at') required final String feedsCreatedAt,
      @JsonKey(name: 'feeds_like') required final int feedsLike,
      @JsonKey(name: 'feeds_view_count') required final int feedsViewCount,
      @JsonKey(name: 'feeds_comment_length')
      required final int feedsCommentLength,
      @JsonKey(name: 'feeds_type') required final String feedsType,
      @JsonKey(name: 'feeds_price') required final int feedsPrice,
      @JsonKey(name: 'feeds_max_limit') required final int feedsMaxLimit,
      @JsonKey(name: 'feeds_sell_limit_date') final String? feedsSellLimitDate,
      @JsonKey(name: 'feed_user_info')
      required final FeedUserInfo feedUserInfo}) = _$PhotoDetailImpl;

  factory _PhotoDetail.fromJson(Map<String, dynamic> json) =
      _$PhotoDetailImpl.fromJson;

  @override
  @JsonKey(name: 'feeds_idx')
  int get feedsIdx;
  @override
  @JsonKey(name: 'mem_idx')
  int get memIdx;
  @override
  @JsonKey(name: 'group_idx')
  int get groupIdx;
  @override
  @JsonKey(name: 'artist_idx')
  int get artistIdx;
  @override
  @JsonKey(name: 'feeds_content')
  String get feedsContent;
  @override
  @JsonKey(name: 'feeds_img_attach')
  List<FeedsImgAttach> get feedsImgAttach;
  @override
  @JsonKey(name: 'feeds_created_at')
  String get feedsCreatedAt;
  @override
  @JsonKey(name: 'feeds_like')
  int get feedsLike;
  @override
  @JsonKey(name: 'feeds_view_count')
  int get feedsViewCount;
  @override
  @JsonKey(name: 'feeds_comment_length')
  int get feedsCommentLength;
  @override
  @JsonKey(name: 'feeds_type')
  String get feedsType;
  @override
  @JsonKey(name: 'feeds_price')
  int get feedsPrice;
  @override
  @JsonKey(name: 'feeds_max_limit')
  int get feedsMaxLimit;
  @override
  @JsonKey(name: 'feeds_sell_limit_date')
  String? get feedsSellLimitDate;
  @override
  @JsonKey(name: 'feed_user_info')
  FeedUserInfo get feedUserInfo;
  @override
  @JsonKey(ignore: true)
  _$$PhotoDetailImplCopyWith<_$PhotoDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FeedsImgAttach _$FeedsImgAttachFromJson(Map<String, dynamic> json) {
  return _FeedsImgAttach.fromJson(json);
}

/// @nodoc
mixin _$FeedsImgAttach {
  @JsonKey(name: 'attach_file_path')
  String get attachFilePath => throw _privateConstructorUsedError;
  @JsonKey(name: 'video_attach_idx')
  int? get videoAttachIdx => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FeedsImgAttachCopyWith<FeedsImgAttach> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeedsImgAttachCopyWith<$Res> {
  factory $FeedsImgAttachCopyWith(
          FeedsImgAttach value, $Res Function(FeedsImgAttach) then) =
      _$FeedsImgAttachCopyWithImpl<$Res, FeedsImgAttach>;
  @useResult
  $Res call(
      {@JsonKey(name: 'attach_file_path') String attachFilePath,
      @JsonKey(name: 'video_attach_idx') int? videoAttachIdx});
}

/// @nodoc
class _$FeedsImgAttachCopyWithImpl<$Res, $Val extends FeedsImgAttach>
    implements $FeedsImgAttachCopyWith<$Res> {
  _$FeedsImgAttachCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? attachFilePath = null,
    Object? videoAttachIdx = freezed,
  }) {
    return _then(_value.copyWith(
      attachFilePath: null == attachFilePath
          ? _value.attachFilePath
          : attachFilePath // ignore: cast_nullable_to_non_nullable
              as String,
      videoAttachIdx: freezed == videoAttachIdx
          ? _value.videoAttachIdx
          : videoAttachIdx // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FeedsImgAttachImplCopyWith<$Res>
    implements $FeedsImgAttachCopyWith<$Res> {
  factory _$$FeedsImgAttachImplCopyWith(_$FeedsImgAttachImpl value,
          $Res Function(_$FeedsImgAttachImpl) then) =
      __$$FeedsImgAttachImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'attach_file_path') String attachFilePath,
      @JsonKey(name: 'video_attach_idx') int? videoAttachIdx});
}

/// @nodoc
class __$$FeedsImgAttachImplCopyWithImpl<$Res>
    extends _$FeedsImgAttachCopyWithImpl<$Res, _$FeedsImgAttachImpl>
    implements _$$FeedsImgAttachImplCopyWith<$Res> {
  __$$FeedsImgAttachImplCopyWithImpl(
      _$FeedsImgAttachImpl _value, $Res Function(_$FeedsImgAttachImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? attachFilePath = null,
    Object? videoAttachIdx = freezed,
  }) {
    return _then(_$FeedsImgAttachImpl(
      attachFilePath: null == attachFilePath
          ? _value.attachFilePath
          : attachFilePath // ignore: cast_nullable_to_non_nullable
              as String,
      videoAttachIdx: freezed == videoAttachIdx
          ? _value.videoAttachIdx
          : videoAttachIdx // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FeedsImgAttachImpl implements _FeedsImgAttach {
  const _$FeedsImgAttachImpl(
      {@JsonKey(name: 'attach_file_path') required this.attachFilePath,
      @JsonKey(name: 'video_attach_idx') this.videoAttachIdx});

  factory _$FeedsImgAttachImpl.fromJson(Map<String, dynamic> json) =>
      _$$FeedsImgAttachImplFromJson(json);

  @override
  @JsonKey(name: 'attach_file_path')
  final String attachFilePath;
  @override
  @JsonKey(name: 'video_attach_idx')
  final int? videoAttachIdx;

  @override
  String toString() {
    return 'FeedsImgAttach(attachFilePath: $attachFilePath, videoAttachIdx: $videoAttachIdx)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FeedsImgAttachImpl &&
            (identical(other.attachFilePath, attachFilePath) ||
                other.attachFilePath == attachFilePath) &&
            (identical(other.videoAttachIdx, videoAttachIdx) ||
                other.videoAttachIdx == videoAttachIdx));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, attachFilePath, videoAttachIdx);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FeedsImgAttachImplCopyWith<_$FeedsImgAttachImpl> get copyWith =>
      __$$FeedsImgAttachImplCopyWithImpl<_$FeedsImgAttachImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FeedsImgAttachImplToJson(
      this,
    );
  }
}

abstract class _FeedsImgAttach implements FeedsImgAttach {
  const factory _FeedsImgAttach(
      {@JsonKey(name: 'attach_file_path') required final String attachFilePath,
      @JsonKey(name: 'video_attach_idx')
      final int? videoAttachIdx}) = _$FeedsImgAttachImpl;

  factory _FeedsImgAttach.fromJson(Map<String, dynamic> json) =
      _$FeedsImgAttachImpl.fromJson;

  @override
  @JsonKey(name: 'attach_file_path')
  String get attachFilePath;
  @override
  @JsonKey(name: 'video_attach_idx')
  int? get videoAttachIdx;
  @override
  @JsonKey(ignore: true)
  _$$FeedsImgAttachImplCopyWith<_$FeedsImgAttachImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FeedUserInfo _$FeedUserInfoFromJson(Map<String, dynamic> json) {
  return _FeedUserInfo.fromJson(json);
}

/// @nodoc
mixin _$FeedUserInfo {
  @JsonKey(name: 'mem_nickname')
  String get memNickname => throw _privateConstructorUsedError;
  @JsonKey(name: 'profile_img_path')
  String? get profileImgPath => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FeedUserInfoCopyWith<FeedUserInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeedUserInfoCopyWith<$Res> {
  factory $FeedUserInfoCopyWith(
          FeedUserInfo value, $Res Function(FeedUserInfo) then) =
      _$FeedUserInfoCopyWithImpl<$Res, FeedUserInfo>;
  @useResult
  $Res call(
      {@JsonKey(name: 'mem_nickname') String memNickname,
      @JsonKey(name: 'profile_img_path') String? profileImgPath});
}

/// @nodoc
class _$FeedUserInfoCopyWithImpl<$Res, $Val extends FeedUserInfo>
    implements $FeedUserInfoCopyWith<$Res> {
  _$FeedUserInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? memNickname = null,
    Object? profileImgPath = freezed,
  }) {
    return _then(_value.copyWith(
      memNickname: null == memNickname
          ? _value.memNickname
          : memNickname // ignore: cast_nullable_to_non_nullable
              as String,
      profileImgPath: freezed == profileImgPath
          ? _value.profileImgPath
          : profileImgPath // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FeedUserInfoImplCopyWith<$Res>
    implements $FeedUserInfoCopyWith<$Res> {
  factory _$$FeedUserInfoImplCopyWith(
          _$FeedUserInfoImpl value, $Res Function(_$FeedUserInfoImpl) then) =
      __$$FeedUserInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'mem_nickname') String memNickname,
      @JsonKey(name: 'profile_img_path') String? profileImgPath});
}

/// @nodoc
class __$$FeedUserInfoImplCopyWithImpl<$Res>
    extends _$FeedUserInfoCopyWithImpl<$Res, _$FeedUserInfoImpl>
    implements _$$FeedUserInfoImplCopyWith<$Res> {
  __$$FeedUserInfoImplCopyWithImpl(
      _$FeedUserInfoImpl _value, $Res Function(_$FeedUserInfoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? memNickname = null,
    Object? profileImgPath = freezed,
  }) {
    return _then(_$FeedUserInfoImpl(
      memNickname: null == memNickname
          ? _value.memNickname
          : memNickname // ignore: cast_nullable_to_non_nullable
              as String,
      profileImgPath: freezed == profileImgPath
          ? _value.profileImgPath
          : profileImgPath // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FeedUserInfoImpl implements _FeedUserInfo {
  const _$FeedUserInfoImpl(
      {@JsonKey(name: 'mem_nickname') required this.memNickname,
      @JsonKey(name: 'profile_img_path') this.profileImgPath});

  factory _$FeedUserInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$FeedUserInfoImplFromJson(json);

  @override
  @JsonKey(name: 'mem_nickname')
  final String memNickname;
  @override
  @JsonKey(name: 'profile_img_path')
  final String? profileImgPath;

  @override
  String toString() {
    return 'FeedUserInfo(memNickname: $memNickname, profileImgPath: $profileImgPath)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FeedUserInfoImpl &&
            (identical(other.memNickname, memNickname) ||
                other.memNickname == memNickname) &&
            (identical(other.profileImgPath, profileImgPath) ||
                other.profileImgPath == profileImgPath));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, memNickname, profileImgPath);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FeedUserInfoImplCopyWith<_$FeedUserInfoImpl> get copyWith =>
      __$$FeedUserInfoImplCopyWithImpl<_$FeedUserInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FeedUserInfoImplToJson(
      this,
    );
  }
}

abstract class _FeedUserInfo implements FeedUserInfo {
  const factory _FeedUserInfo(
          {@JsonKey(name: 'mem_nickname') required final String memNickname,
          @JsonKey(name: 'profile_img_path') final String? profileImgPath}) =
      _$FeedUserInfoImpl;

  factory _FeedUserInfo.fromJson(Map<String, dynamic> json) =
      _$FeedUserInfoImpl.fromJson;

  @override
  @JsonKey(name: 'mem_nickname')
  String get memNickname;
  @override
  @JsonKey(name: 'profile_img_path')
  String? get profileImgPath;
  @override
  @JsonKey(ignore: true)
  _$$FeedUserInfoImplCopyWith<_$FeedUserInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

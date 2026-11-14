// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AuthStatus {

 DateTime? get lastSuccessfulAuthAt; int get failedAttempts;/// PIN entry is refused until this moment.
 DateTime? get lockedUntil;
/// Create a copy of AuthStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthStatusCopyWith<AuthStatus> get copyWith => _$AuthStatusCopyWithImpl<AuthStatus>(this as AuthStatus, _$identity);

  /// Serializes this AuthStatus to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthStatus&&(identical(other.lastSuccessfulAuthAt, lastSuccessfulAuthAt) || other.lastSuccessfulAuthAt == lastSuccessfulAuthAt)&&(identical(other.failedAttempts, failedAttempts) || other.failedAttempts == failedAttempts)&&(identical(other.lockedUntil, lockedUntil) || other.lockedUntil == lockedUntil));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lastSuccessfulAuthAt,failedAttempts,lockedUntil);

@override
String toString() {
  return 'AuthStatus(lastSuccessfulAuthAt: $lastSuccessfulAuthAt, failedAttempts: $failedAttempts, lockedUntil: $lockedUntil)';
}


}

/// @nodoc
abstract mixin class $AuthStatusCopyWith<$Res>  {
  factory $AuthStatusCopyWith(AuthStatus value, $Res Function(AuthStatus) _then) = _$AuthStatusCopyWithImpl;
@useResult
$Res call({
 DateTime? lastSuccessfulAuthAt, int failedAttempts, DateTime? lockedUntil
});




}
/// @nodoc
class _$AuthStatusCopyWithImpl<$Res>
    implements $AuthStatusCopyWith<$Res> {
  _$AuthStatusCopyWithImpl(this._self, this._then);

  final AuthStatus _self;
  final $Res Function(AuthStatus) _then;

/// Create a copy of AuthStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lastSuccessfulAuthAt = freezed,Object? failedAttempts = null,Object? lockedUntil = freezed,}) {
  return _then(_self.copyWith(
lastSuccessfulAuthAt: freezed == lastSuccessfulAuthAt ? _self.lastSuccessfulAuthAt : lastSuccessfulAuthAt // ignore: cast_nullable_to_non_nullable
as DateTime?,failedAttempts: null == failedAttempts ? _self.failedAttempts : failedAttempts // ignore: cast_nullable_to_non_nullable
as int,lockedUntil: freezed == lockedUntil ? _self.lockedUntil : lockedUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [AuthStatus].
extension AuthStatusPatterns on AuthStatus {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthStatus value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthStatus() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthStatus value)  $default,){
final _that = this;
switch (_that) {
case _AuthStatus():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthStatus value)?  $default,){
final _that = this;
switch (_that) {
case _AuthStatus() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime? lastSuccessfulAuthAt,  int failedAttempts,  DateTime? lockedUntil)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthStatus() when $default != null:
return $default(_that.lastSuccessfulAuthAt,_that.failedAttempts,_that.lockedUntil);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime? lastSuccessfulAuthAt,  int failedAttempts,  DateTime? lockedUntil)  $default,) {final _that = this;
switch (_that) {
case _AuthStatus():
return $default(_that.lastSuccessfulAuthAt,_that.failedAttempts,_that.lockedUntil);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime? lastSuccessfulAuthAt,  int failedAttempts,  DateTime? lockedUntil)?  $default,) {final _that = this;
switch (_that) {
case _AuthStatus() when $default != null:
return $default(_that.lastSuccessfulAuthAt,_that.failedAttempts,_that.lockedUntil);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuthStatus implements AuthStatus {
  const _AuthStatus({this.lastSuccessfulAuthAt, this.failedAttempts = 0, this.lockedUntil});
  factory _AuthStatus.fromJson(Map<String, dynamic> json) => _$AuthStatusFromJson(json);

@override final  DateTime? lastSuccessfulAuthAt;
@override@JsonKey() final  int failedAttempts;
/// PIN entry is refused until this moment.
@override final  DateTime? lockedUntil;

/// Create a copy of AuthStatus
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthStatusCopyWith<_AuthStatus> get copyWith => __$AuthStatusCopyWithImpl<_AuthStatus>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuthStatusToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthStatus&&(identical(other.lastSuccessfulAuthAt, lastSuccessfulAuthAt) || other.lastSuccessfulAuthAt == lastSuccessfulAuthAt)&&(identical(other.failedAttempts, failedAttempts) || other.failedAttempts == failedAttempts)&&(identical(other.lockedUntil, lockedUntil) || other.lockedUntil == lockedUntil));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lastSuccessfulAuthAt,failedAttempts,lockedUntil);

@override
String toString() {
  return 'AuthStatus(lastSuccessfulAuthAt: $lastSuccessfulAuthAt, failedAttempts: $failedAttempts, lockedUntil: $lockedUntil)';
}


}

/// @nodoc
abstract mixin class _$AuthStatusCopyWith<$Res> implements $AuthStatusCopyWith<$Res> {
  factory _$AuthStatusCopyWith(_AuthStatus value, $Res Function(_AuthStatus) _then) = __$AuthStatusCopyWithImpl;
@override @useResult
$Res call({
 DateTime? lastSuccessfulAuthAt, int failedAttempts, DateTime? lockedUntil
});




}
/// @nodoc
class __$AuthStatusCopyWithImpl<$Res>
    implements _$AuthStatusCopyWith<$Res> {
  __$AuthStatusCopyWithImpl(this._self, this._then);

  final _AuthStatus _self;
  final $Res Function(_AuthStatus) _then;

/// Create a copy of AuthStatus
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lastSuccessfulAuthAt = freezed,Object? failedAttempts = null,Object? lockedUntil = freezed,}) {
  return _then(_AuthStatus(
lastSuccessfulAuthAt: freezed == lastSuccessfulAuthAt ? _self.lastSuccessfulAuthAt : lastSuccessfulAuthAt // ignore: cast_nullable_to_non_nullable
as DateTime?,failedAttempts: null == failedAttempts ? _self.failedAttempts : failedAttempts // ignore: cast_nullable_to_non_nullable
as int,lockedUntil: freezed == lockedUntil ? _self.lockedUntil : lockedUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on

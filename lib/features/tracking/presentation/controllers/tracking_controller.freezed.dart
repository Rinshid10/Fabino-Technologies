// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tracking_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TrackingState {

/// The session being recorded, or `null` when idle.
 TrackingSession? get session;/// Metres per second.
 double get currentSpeed; LocationFix? get lastFix;/// `start()` is in progress.
 bool get isStarting;
/// Create a copy of TrackingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrackingStateCopyWith<TrackingState> get copyWith => _$TrackingStateCopyWithImpl<TrackingState>(this as TrackingState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrackingState&&(identical(other.session, session) || other.session == session)&&(identical(other.currentSpeed, currentSpeed) || other.currentSpeed == currentSpeed)&&(identical(other.lastFix, lastFix) || other.lastFix == lastFix)&&(identical(other.isStarting, isStarting) || other.isStarting == isStarting));
}


@override
int get hashCode => Object.hash(runtimeType,session,currentSpeed,lastFix,isStarting);

@override
String toString() {
  return 'TrackingState(session: $session, currentSpeed: $currentSpeed, lastFix: $lastFix, isStarting: $isStarting)';
}


}

/// @nodoc
abstract mixin class $TrackingStateCopyWith<$Res>  {
  factory $TrackingStateCopyWith(TrackingState value, $Res Function(TrackingState) _then) = _$TrackingStateCopyWithImpl;
@useResult
$Res call({
 TrackingSession? session, double currentSpeed, LocationFix? lastFix, bool isStarting
});


$TrackingSessionCopyWith<$Res>? get session;$LocationFixCopyWith<$Res>? get lastFix;

}
/// @nodoc
class _$TrackingStateCopyWithImpl<$Res>
    implements $TrackingStateCopyWith<$Res> {
  _$TrackingStateCopyWithImpl(this._self, this._then);

  final TrackingState _self;
  final $Res Function(TrackingState) _then;

/// Create a copy of TrackingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? session = freezed,Object? currentSpeed = null,Object? lastFix = freezed,Object? isStarting = null,}) {
  return _then(_self.copyWith(
session: freezed == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as TrackingSession?,currentSpeed: null == currentSpeed ? _self.currentSpeed : currentSpeed // ignore: cast_nullable_to_non_nullable
as double,lastFix: freezed == lastFix ? _self.lastFix : lastFix // ignore: cast_nullable_to_non_nullable
as LocationFix?,isStarting: null == isStarting ? _self.isStarting : isStarting // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of TrackingState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TrackingSessionCopyWith<$Res>? get session {
    if (_self.session == null) {
    return null;
  }

  return $TrackingSessionCopyWith<$Res>(_self.session!, (value) {
    return _then(_self.copyWith(session: value));
  });
}/// Create a copy of TrackingState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocationFixCopyWith<$Res>? get lastFix {
    if (_self.lastFix == null) {
    return null;
  }

  return $LocationFixCopyWith<$Res>(_self.lastFix!, (value) {
    return _then(_self.copyWith(lastFix: value));
  });
}
}


/// Adds pattern-matching-related methods to [TrackingState].
extension TrackingStatePatterns on TrackingState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TrackingState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TrackingState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TrackingState value)  $default,){
final _that = this;
switch (_that) {
case _TrackingState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TrackingState value)?  $default,){
final _that = this;
switch (_that) {
case _TrackingState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TrackingSession? session,  double currentSpeed,  LocationFix? lastFix,  bool isStarting)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TrackingState() when $default != null:
return $default(_that.session,_that.currentSpeed,_that.lastFix,_that.isStarting);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TrackingSession? session,  double currentSpeed,  LocationFix? lastFix,  bool isStarting)  $default,) {final _that = this;
switch (_that) {
case _TrackingState():
return $default(_that.session,_that.currentSpeed,_that.lastFix,_that.isStarting);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TrackingSession? session,  double currentSpeed,  LocationFix? lastFix,  bool isStarting)?  $default,) {final _that = this;
switch (_that) {
case _TrackingState() when $default != null:
return $default(_that.session,_that.currentSpeed,_that.lastFix,_that.isStarting);case _:
  return null;

}
}

}

/// @nodoc


class _TrackingState extends TrackingState {
  const _TrackingState({this.session, this.currentSpeed = 0, this.lastFix, this.isStarting = false}): super._();
  

/// The session being recorded, or `null` when idle.
@override final  TrackingSession? session;
/// Metres per second.
@override@JsonKey() final  double currentSpeed;
@override final  LocationFix? lastFix;
/// `start()` is in progress.
@override@JsonKey() final  bool isStarting;

/// Create a copy of TrackingState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrackingStateCopyWith<_TrackingState> get copyWith => __$TrackingStateCopyWithImpl<_TrackingState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TrackingState&&(identical(other.session, session) || other.session == session)&&(identical(other.currentSpeed, currentSpeed) || other.currentSpeed == currentSpeed)&&(identical(other.lastFix, lastFix) || other.lastFix == lastFix)&&(identical(other.isStarting, isStarting) || other.isStarting == isStarting));
}


@override
int get hashCode => Object.hash(runtimeType,session,currentSpeed,lastFix,isStarting);

@override
String toString() {
  return 'TrackingState(session: $session, currentSpeed: $currentSpeed, lastFix: $lastFix, isStarting: $isStarting)';
}


}

/// @nodoc
abstract mixin class _$TrackingStateCopyWith<$Res> implements $TrackingStateCopyWith<$Res> {
  factory _$TrackingStateCopyWith(_TrackingState value, $Res Function(_TrackingState) _then) = __$TrackingStateCopyWithImpl;
@override @useResult
$Res call({
 TrackingSession? session, double currentSpeed, LocationFix? lastFix, bool isStarting
});


@override $TrackingSessionCopyWith<$Res>? get session;@override $LocationFixCopyWith<$Res>? get lastFix;

}
/// @nodoc
class __$TrackingStateCopyWithImpl<$Res>
    implements _$TrackingStateCopyWith<$Res> {
  __$TrackingStateCopyWithImpl(this._self, this._then);

  final _TrackingState _self;
  final $Res Function(_TrackingState) _then;

/// Create a copy of TrackingState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? session = freezed,Object? currentSpeed = null,Object? lastFix = freezed,Object? isStarting = null,}) {
  return _then(_TrackingState(
session: freezed == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as TrackingSession?,currentSpeed: null == currentSpeed ? _self.currentSpeed : currentSpeed // ignore: cast_nullable_to_non_nullable
as double,lastFix: freezed == lastFix ? _self.lastFix : lastFix // ignore: cast_nullable_to_non_nullable
as LocationFix?,isStarting: null == isStarting ? _self.isStarting : isStarting // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of TrackingState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TrackingSessionCopyWith<$Res>? get session {
    if (_self.session == null) {
    return null;
  }

  return $TrackingSessionCopyWith<$Res>(_self.session!, (value) {
    return _then(_self.copyWith(session: value));
  });
}/// Create a copy of TrackingState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocationFixCopyWith<$Res>? get lastFix {
    if (_self.lastFix == null) {
    return null;
  }

  return $LocationFixCopyWith<$Res>(_self.lastFix!, (value) {
    return _then(_self.copyWith(lastFix: value));
  });
}
}

// dart format on

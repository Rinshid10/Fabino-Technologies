// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'location_fix.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LocationFix {

 double get latitude; double get longitude;/// Estimated horizontal error, in metres.
 double get accuracy;/// Speed over ground, in metres per second (never negative).
 double get speed; DateTime get timestamp;/// The position came from a mock-location app, not real GPS.
 bool get isMocked;
/// Create a copy of LocationFix
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LocationFixCopyWith<LocationFix> get copyWith => _$LocationFixCopyWithImpl<LocationFix>(this as LocationFix, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LocationFix&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.accuracy, accuracy) || other.accuracy == accuracy)&&(identical(other.speed, speed) || other.speed == speed)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.isMocked, isMocked) || other.isMocked == isMocked));
}


@override
int get hashCode => Object.hash(runtimeType,latitude,longitude,accuracy,speed,timestamp,isMocked);

@override
String toString() {
  return 'LocationFix(latitude: $latitude, longitude: $longitude, accuracy: $accuracy, speed: $speed, timestamp: $timestamp, isMocked: $isMocked)';
}


}

/// @nodoc
abstract mixin class $LocationFixCopyWith<$Res>  {
  factory $LocationFixCopyWith(LocationFix value, $Res Function(LocationFix) _then) = _$LocationFixCopyWithImpl;
@useResult
$Res call({
 double latitude, double longitude, double accuracy, double speed, DateTime timestamp, bool isMocked
});




}
/// @nodoc
class _$LocationFixCopyWithImpl<$Res>
    implements $LocationFixCopyWith<$Res> {
  _$LocationFixCopyWithImpl(this._self, this._then);

  final LocationFix _self;
  final $Res Function(LocationFix) _then;

/// Create a copy of LocationFix
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? latitude = null,Object? longitude = null,Object? accuracy = null,Object? speed = null,Object? timestamp = null,Object? isMocked = null,}) {
  return _then(_self.copyWith(
latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,accuracy: null == accuracy ? _self.accuracy : accuracy // ignore: cast_nullable_to_non_nullable
as double,speed: null == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as double,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,isMocked: null == isMocked ? _self.isMocked : isMocked // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [LocationFix].
extension LocationFixPatterns on LocationFix {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LocationFix value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LocationFix() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LocationFix value)  $default,){
final _that = this;
switch (_that) {
case _LocationFix():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LocationFix value)?  $default,){
final _that = this;
switch (_that) {
case _LocationFix() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double latitude,  double longitude,  double accuracy,  double speed,  DateTime timestamp,  bool isMocked)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LocationFix() when $default != null:
return $default(_that.latitude,_that.longitude,_that.accuracy,_that.speed,_that.timestamp,_that.isMocked);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double latitude,  double longitude,  double accuracy,  double speed,  DateTime timestamp,  bool isMocked)  $default,) {final _that = this;
switch (_that) {
case _LocationFix():
return $default(_that.latitude,_that.longitude,_that.accuracy,_that.speed,_that.timestamp,_that.isMocked);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double latitude,  double longitude,  double accuracy,  double speed,  DateTime timestamp,  bool isMocked)?  $default,) {final _that = this;
switch (_that) {
case _LocationFix() when $default != null:
return $default(_that.latitude,_that.longitude,_that.accuracy,_that.speed,_that.timestamp,_that.isMocked);case _:
  return null;

}
}

}

/// @nodoc


class _LocationFix implements LocationFix {
  const _LocationFix({required this.latitude, required this.longitude, required this.accuracy, required this.speed, required this.timestamp, this.isMocked = false});
  

@override final  double latitude;
@override final  double longitude;
/// Estimated horizontal error, in metres.
@override final  double accuracy;
/// Speed over ground, in metres per second (never negative).
@override final  double speed;
@override final  DateTime timestamp;
/// The position came from a mock-location app, not real GPS.
@override@JsonKey() final  bool isMocked;

/// Create a copy of LocationFix
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LocationFixCopyWith<_LocationFix> get copyWith => __$LocationFixCopyWithImpl<_LocationFix>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LocationFix&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.accuracy, accuracy) || other.accuracy == accuracy)&&(identical(other.speed, speed) || other.speed == speed)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.isMocked, isMocked) || other.isMocked == isMocked));
}


@override
int get hashCode => Object.hash(runtimeType,latitude,longitude,accuracy,speed,timestamp,isMocked);

@override
String toString() {
  return 'LocationFix(latitude: $latitude, longitude: $longitude, accuracy: $accuracy, speed: $speed, timestamp: $timestamp, isMocked: $isMocked)';
}


}

/// @nodoc
abstract mixin class _$LocationFixCopyWith<$Res> implements $LocationFixCopyWith<$Res> {
  factory _$LocationFixCopyWith(_LocationFix value, $Res Function(_LocationFix) _then) = __$LocationFixCopyWithImpl;
@override @useResult
$Res call({
 double latitude, double longitude, double accuracy, double speed, DateTime timestamp, bool isMocked
});




}
/// @nodoc
class __$LocationFixCopyWithImpl<$Res>
    implements _$LocationFixCopyWith<$Res> {
  __$LocationFixCopyWithImpl(this._self, this._then);

  final _LocationFix _self;
  final $Res Function(_LocationFix) _then;

/// Create a copy of LocationFix
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? latitude = null,Object? longitude = null,Object? accuracy = null,Object? speed = null,Object? timestamp = null,Object? isMocked = null,}) {
  return _then(_LocationFix(
latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,accuracy: null == accuracy ? _self.accuracy : accuracy // ignore: cast_nullable_to_non_nullable
as double,speed: null == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as double,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,isMocked: null == isMocked ? _self.isMocked : isMocked // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on

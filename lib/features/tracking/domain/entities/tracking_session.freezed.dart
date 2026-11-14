// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tracking_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TrackPoint {

 double get latitude; double get longitude; double get accuracy;/// Metres per second.
 double get speed; DateTime get timestamp;
/// Create a copy of TrackPoint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrackPointCopyWith<TrackPoint> get copyWith => _$TrackPointCopyWithImpl<TrackPoint>(this as TrackPoint, _$identity);

  /// Serializes this TrackPoint to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrackPoint&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.accuracy, accuracy) || other.accuracy == accuracy)&&(identical(other.speed, speed) || other.speed == speed)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,latitude,longitude,accuracy,speed,timestamp);

@override
String toString() {
  return 'TrackPoint(latitude: $latitude, longitude: $longitude, accuracy: $accuracy, speed: $speed, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class $TrackPointCopyWith<$Res>  {
  factory $TrackPointCopyWith(TrackPoint value, $Res Function(TrackPoint) _then) = _$TrackPointCopyWithImpl;
@useResult
$Res call({
 double latitude, double longitude, double accuracy, double speed, DateTime timestamp
});




}
/// @nodoc
class _$TrackPointCopyWithImpl<$Res>
    implements $TrackPointCopyWith<$Res> {
  _$TrackPointCopyWithImpl(this._self, this._then);

  final TrackPoint _self;
  final $Res Function(TrackPoint) _then;

/// Create a copy of TrackPoint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? latitude = null,Object? longitude = null,Object? accuracy = null,Object? speed = null,Object? timestamp = null,}) {
  return _then(_self.copyWith(
latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,accuracy: null == accuracy ? _self.accuracy : accuracy // ignore: cast_nullable_to_non_nullable
as double,speed: null == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as double,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [TrackPoint].
extension TrackPointPatterns on TrackPoint {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TrackPoint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TrackPoint() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TrackPoint value)  $default,){
final _that = this;
switch (_that) {
case _TrackPoint():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TrackPoint value)?  $default,){
final _that = this;
switch (_that) {
case _TrackPoint() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double latitude,  double longitude,  double accuracy,  double speed,  DateTime timestamp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TrackPoint() when $default != null:
return $default(_that.latitude,_that.longitude,_that.accuracy,_that.speed,_that.timestamp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double latitude,  double longitude,  double accuracy,  double speed,  DateTime timestamp)  $default,) {final _that = this;
switch (_that) {
case _TrackPoint():
return $default(_that.latitude,_that.longitude,_that.accuracy,_that.speed,_that.timestamp);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double latitude,  double longitude,  double accuracy,  double speed,  DateTime timestamp)?  $default,) {final _that = this;
switch (_that) {
case _TrackPoint() when $default != null:
return $default(_that.latitude,_that.longitude,_that.accuracy,_that.speed,_that.timestamp);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TrackPoint implements TrackPoint {
  const _TrackPoint({required this.latitude, required this.longitude, required this.accuracy, required this.speed, required this.timestamp});
  factory _TrackPoint.fromJson(Map<String, dynamic> json) => _$TrackPointFromJson(json);

@override final  double latitude;
@override final  double longitude;
@override final  double accuracy;
/// Metres per second.
@override final  double speed;
@override final  DateTime timestamp;

/// Create a copy of TrackPoint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrackPointCopyWith<_TrackPoint> get copyWith => __$TrackPointCopyWithImpl<_TrackPoint>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TrackPointToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TrackPoint&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.accuracy, accuracy) || other.accuracy == accuracy)&&(identical(other.speed, speed) || other.speed == speed)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,latitude,longitude,accuracy,speed,timestamp);

@override
String toString() {
  return 'TrackPoint(latitude: $latitude, longitude: $longitude, accuracy: $accuracy, speed: $speed, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class _$TrackPointCopyWith<$Res> implements $TrackPointCopyWith<$Res> {
  factory _$TrackPointCopyWith(_TrackPoint value, $Res Function(_TrackPoint) _then) = __$TrackPointCopyWithImpl;
@override @useResult
$Res call({
 double latitude, double longitude, double accuracy, double speed, DateTime timestamp
});




}
/// @nodoc
class __$TrackPointCopyWithImpl<$Res>
    implements _$TrackPointCopyWith<$Res> {
  __$TrackPointCopyWithImpl(this._self, this._then);

  final _TrackPoint _self;
  final $Res Function(_TrackPoint) _then;

/// Create a copy of TrackPoint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? latitude = null,Object? longitude = null,Object? accuracy = null,Object? speed = null,Object? timestamp = null,}) {
  return _then(_TrackPoint(
latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,accuracy: null == accuracy ? _self.accuracy : accuracy // ignore: cast_nullable_to_non_nullable
as double,speed: null == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as double,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$TrackingSession {

 String get id; DateTime get startedAt;/// `null` while the session is still being recorded.
 DateTime? get endedAt; double get distanceMeters;/// Highest speed seen, in metres per second.
 double get maxSpeed;/// At least one position came from a mock-location app.
 bool get hadMockedLocation; List<TrackPoint> get points;
/// Create a copy of TrackingSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrackingSessionCopyWith<TrackingSession> get copyWith => _$TrackingSessionCopyWithImpl<TrackingSession>(this as TrackingSession, _$identity);

  /// Serializes this TrackingSession to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrackingSession&&(identical(other.id, id) || other.id == id)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.endedAt, endedAt) || other.endedAt == endedAt)&&(identical(other.distanceMeters, distanceMeters) || other.distanceMeters == distanceMeters)&&(identical(other.maxSpeed, maxSpeed) || other.maxSpeed == maxSpeed)&&(identical(other.hadMockedLocation, hadMockedLocation) || other.hadMockedLocation == hadMockedLocation)&&const DeepCollectionEquality().equals(other.points, points));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,startedAt,endedAt,distanceMeters,maxSpeed,hadMockedLocation,const DeepCollectionEquality().hash(points));

@override
String toString() {
  return 'TrackingSession(id: $id, startedAt: $startedAt, endedAt: $endedAt, distanceMeters: $distanceMeters, maxSpeed: $maxSpeed, hadMockedLocation: $hadMockedLocation, points: $points)';
}


}

/// @nodoc
abstract mixin class $TrackingSessionCopyWith<$Res>  {
  factory $TrackingSessionCopyWith(TrackingSession value, $Res Function(TrackingSession) _then) = _$TrackingSessionCopyWithImpl;
@useResult
$Res call({
 String id, DateTime startedAt, DateTime? endedAt, double distanceMeters, double maxSpeed, bool hadMockedLocation, List<TrackPoint> points
});




}
/// @nodoc
class _$TrackingSessionCopyWithImpl<$Res>
    implements $TrackingSessionCopyWith<$Res> {
  _$TrackingSessionCopyWithImpl(this._self, this._then);

  final TrackingSession _self;
  final $Res Function(TrackingSession) _then;

/// Create a copy of TrackingSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? startedAt = null,Object? endedAt = freezed,Object? distanceMeters = null,Object? maxSpeed = null,Object? hadMockedLocation = null,Object? points = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,endedAt: freezed == endedAt ? _self.endedAt : endedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,distanceMeters: null == distanceMeters ? _self.distanceMeters : distanceMeters // ignore: cast_nullable_to_non_nullable
as double,maxSpeed: null == maxSpeed ? _self.maxSpeed : maxSpeed // ignore: cast_nullable_to_non_nullable
as double,hadMockedLocation: null == hadMockedLocation ? _self.hadMockedLocation : hadMockedLocation // ignore: cast_nullable_to_non_nullable
as bool,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as List<TrackPoint>,
  ));
}

}


/// Adds pattern-matching-related methods to [TrackingSession].
extension TrackingSessionPatterns on TrackingSession {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TrackingSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TrackingSession() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TrackingSession value)  $default,){
final _that = this;
switch (_that) {
case _TrackingSession():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TrackingSession value)?  $default,){
final _that = this;
switch (_that) {
case _TrackingSession() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DateTime startedAt,  DateTime? endedAt,  double distanceMeters,  double maxSpeed,  bool hadMockedLocation,  List<TrackPoint> points)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TrackingSession() when $default != null:
return $default(_that.id,_that.startedAt,_that.endedAt,_that.distanceMeters,_that.maxSpeed,_that.hadMockedLocation,_that.points);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DateTime startedAt,  DateTime? endedAt,  double distanceMeters,  double maxSpeed,  bool hadMockedLocation,  List<TrackPoint> points)  $default,) {final _that = this;
switch (_that) {
case _TrackingSession():
return $default(_that.id,_that.startedAt,_that.endedAt,_that.distanceMeters,_that.maxSpeed,_that.hadMockedLocation,_that.points);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DateTime startedAt,  DateTime? endedAt,  double distanceMeters,  double maxSpeed,  bool hadMockedLocation,  List<TrackPoint> points)?  $default,) {final _that = this;
switch (_that) {
case _TrackingSession() when $default != null:
return $default(_that.id,_that.startedAt,_that.endedAt,_that.distanceMeters,_that.maxSpeed,_that.hadMockedLocation,_that.points);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TrackingSession extends TrackingSession {
  const _TrackingSession({required this.id, required this.startedAt, this.endedAt, this.distanceMeters = 0, this.maxSpeed = 0, this.hadMockedLocation = false, final  List<TrackPoint> points = const <TrackPoint>[]}): _points = points,super._();
  factory _TrackingSession.fromJson(Map<String, dynamic> json) => _$TrackingSessionFromJson(json);

@override final  String id;
@override final  DateTime startedAt;
/// `null` while the session is still being recorded.
@override final  DateTime? endedAt;
@override@JsonKey() final  double distanceMeters;
/// Highest speed seen, in metres per second.
@override@JsonKey() final  double maxSpeed;
/// At least one position came from a mock-location app.
@override@JsonKey() final  bool hadMockedLocation;
 final  List<TrackPoint> _points;
@override@JsonKey() List<TrackPoint> get points {
  if (_points is EqualUnmodifiableListView) return _points;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_points);
}


/// Create a copy of TrackingSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrackingSessionCopyWith<_TrackingSession> get copyWith => __$TrackingSessionCopyWithImpl<_TrackingSession>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TrackingSessionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TrackingSession&&(identical(other.id, id) || other.id == id)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.endedAt, endedAt) || other.endedAt == endedAt)&&(identical(other.distanceMeters, distanceMeters) || other.distanceMeters == distanceMeters)&&(identical(other.maxSpeed, maxSpeed) || other.maxSpeed == maxSpeed)&&(identical(other.hadMockedLocation, hadMockedLocation) || other.hadMockedLocation == hadMockedLocation)&&const DeepCollectionEquality().equals(other._points, _points));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,startedAt,endedAt,distanceMeters,maxSpeed,hadMockedLocation,const DeepCollectionEquality().hash(_points));

@override
String toString() {
  return 'TrackingSession(id: $id, startedAt: $startedAt, endedAt: $endedAt, distanceMeters: $distanceMeters, maxSpeed: $maxSpeed, hadMockedLocation: $hadMockedLocation, points: $points)';
}


}

/// @nodoc
abstract mixin class _$TrackingSessionCopyWith<$Res> implements $TrackingSessionCopyWith<$Res> {
  factory _$TrackingSessionCopyWith(_TrackingSession value, $Res Function(_TrackingSession) _then) = __$TrackingSessionCopyWithImpl;
@override @useResult
$Res call({
 String id, DateTime startedAt, DateTime? endedAt, double distanceMeters, double maxSpeed, bool hadMockedLocation, List<TrackPoint> points
});




}
/// @nodoc
class __$TrackingSessionCopyWithImpl<$Res>
    implements _$TrackingSessionCopyWith<$Res> {
  __$TrackingSessionCopyWithImpl(this._self, this._then);

  final _TrackingSession _self;
  final $Res Function(_TrackingSession) _then;

/// Create a copy of TrackingSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? startedAt = null,Object? endedAt = freezed,Object? distanceMeters = null,Object? maxSpeed = null,Object? hadMockedLocation = null,Object? points = null,}) {
  return _then(_TrackingSession(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,endedAt: freezed == endedAt ? _self.endedAt : endedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,distanceMeters: null == distanceMeters ? _self.distanceMeters : distanceMeters // ignore: cast_nullable_to_non_nullable
as double,maxSpeed: null == maxSpeed ? _self.maxSpeed : maxSpeed // ignore: cast_nullable_to_non_nullable
as double,hadMockedLocation: null == hadMockedLocation ? _self.hadMockedLocation : hadMockedLocation // ignore: cast_nullable_to_non_nullable
as bool,points: null == points ? _self._points : points // ignore: cast_nullable_to_non_nullable
as List<TrackPoint>,
  ));
}


}

// dart format on

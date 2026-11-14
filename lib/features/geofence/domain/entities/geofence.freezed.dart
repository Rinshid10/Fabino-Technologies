// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'geofence.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Geofence {

 String get id; String get name; double get latitude; double get longitude; double get radiusMeters; DateTime get createdAt;/// Remembered between positions (and restarts) so a notification is
/// sent only when the user actually crosses the boundary.
 GeofencePresence get presence;
/// Create a copy of Geofence
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GeofenceCopyWith<Geofence> get copyWith => _$GeofenceCopyWithImpl<Geofence>(this as Geofence, _$identity);

  /// Serializes this Geofence to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Geofence&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.radiusMeters, radiusMeters) || other.radiusMeters == radiusMeters)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.presence, presence) || other.presence == presence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,latitude,longitude,radiusMeters,createdAt,presence);

@override
String toString() {
  return 'Geofence(id: $id, name: $name, latitude: $latitude, longitude: $longitude, radiusMeters: $radiusMeters, createdAt: $createdAt, presence: $presence)';
}


}

/// @nodoc
abstract mixin class $GeofenceCopyWith<$Res>  {
  factory $GeofenceCopyWith(Geofence value, $Res Function(Geofence) _then) = _$GeofenceCopyWithImpl;
@useResult
$Res call({
 String id, String name, double latitude, double longitude, double radiusMeters, DateTime createdAt, GeofencePresence presence
});




}
/// @nodoc
class _$GeofenceCopyWithImpl<$Res>
    implements $GeofenceCopyWith<$Res> {
  _$GeofenceCopyWithImpl(this._self, this._then);

  final Geofence _self;
  final $Res Function(Geofence) _then;

/// Create a copy of Geofence
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? latitude = null,Object? longitude = null,Object? radiusMeters = null,Object? createdAt = null,Object? presence = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,radiusMeters: null == radiusMeters ? _self.radiusMeters : radiusMeters // ignore: cast_nullable_to_non_nullable
as double,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,presence: null == presence ? _self.presence : presence // ignore: cast_nullable_to_non_nullable
as GeofencePresence,
  ));
}

}


/// Adds pattern-matching-related methods to [Geofence].
extension GeofencePatterns on Geofence {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Geofence value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Geofence() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Geofence value)  $default,){
final _that = this;
switch (_that) {
case _Geofence():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Geofence value)?  $default,){
final _that = this;
switch (_that) {
case _Geofence() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  double latitude,  double longitude,  double radiusMeters,  DateTime createdAt,  GeofencePresence presence)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Geofence() when $default != null:
return $default(_that.id,_that.name,_that.latitude,_that.longitude,_that.radiusMeters,_that.createdAt,_that.presence);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  double latitude,  double longitude,  double radiusMeters,  DateTime createdAt,  GeofencePresence presence)  $default,) {final _that = this;
switch (_that) {
case _Geofence():
return $default(_that.id,_that.name,_that.latitude,_that.longitude,_that.radiusMeters,_that.createdAt,_that.presence);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  double latitude,  double longitude,  double radiusMeters,  DateTime createdAt,  GeofencePresence presence)?  $default,) {final _that = this;
switch (_that) {
case _Geofence() when $default != null:
return $default(_that.id,_that.name,_that.latitude,_that.longitude,_that.radiusMeters,_that.createdAt,_that.presence);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Geofence implements Geofence {
  const _Geofence({required this.id, required this.name, required this.latitude, required this.longitude, required this.radiusMeters, required this.createdAt, this.presence = GeofencePresence.unknown});
  factory _Geofence.fromJson(Map<String, dynamic> json) => _$GeofenceFromJson(json);

@override final  String id;
@override final  String name;
@override final  double latitude;
@override final  double longitude;
@override final  double radiusMeters;
@override final  DateTime createdAt;
/// Remembered between positions (and restarts) so a notification is
/// sent only when the user actually crosses the boundary.
@override@JsonKey() final  GeofencePresence presence;

/// Create a copy of Geofence
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GeofenceCopyWith<_Geofence> get copyWith => __$GeofenceCopyWithImpl<_Geofence>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GeofenceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Geofence&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.radiusMeters, radiusMeters) || other.radiusMeters == radiusMeters)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.presence, presence) || other.presence == presence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,latitude,longitude,radiusMeters,createdAt,presence);

@override
String toString() {
  return 'Geofence(id: $id, name: $name, latitude: $latitude, longitude: $longitude, radiusMeters: $radiusMeters, createdAt: $createdAt, presence: $presence)';
}


}

/// @nodoc
abstract mixin class _$GeofenceCopyWith<$Res> implements $GeofenceCopyWith<$Res> {
  factory _$GeofenceCopyWith(_Geofence value, $Res Function(_Geofence) _then) = __$GeofenceCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, double latitude, double longitude, double radiusMeters, DateTime createdAt, GeofencePresence presence
});




}
/// @nodoc
class __$GeofenceCopyWithImpl<$Res>
    implements _$GeofenceCopyWith<$Res> {
  __$GeofenceCopyWithImpl(this._self, this._then);

  final _Geofence _self;
  final $Res Function(_Geofence) _then;

/// Create a copy of Geofence
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? latitude = null,Object? longitude = null,Object? radiusMeters = null,Object? createdAt = null,Object? presence = null,}) {
  return _then(_Geofence(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,radiusMeters: null == radiusMeters ? _self.radiusMeters : radiusMeters // ignore: cast_nullable_to_non_nullable
as double,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,presence: null == presence ? _self.presence : presence // ignore: cast_nullable_to_non_nullable
as GeofencePresence,
  ));
}


}

// dart format on

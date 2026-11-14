// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'location_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LocationStatus {

 LocationPermissionStatus get permission;/// The device location service (GPS) is switched on.
 bool get serviceEnabled;
/// Create a copy of LocationStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LocationStatusCopyWith<LocationStatus> get copyWith => _$LocationStatusCopyWithImpl<LocationStatus>(this as LocationStatus, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LocationStatus&&(identical(other.permission, permission) || other.permission == permission)&&(identical(other.serviceEnabled, serviceEnabled) || other.serviceEnabled == serviceEnabled));
}


@override
int get hashCode => Object.hash(runtimeType,permission,serviceEnabled);

@override
String toString() {
  return 'LocationStatus(permission: $permission, serviceEnabled: $serviceEnabled)';
}


}

/// @nodoc
abstract mixin class $LocationStatusCopyWith<$Res>  {
  factory $LocationStatusCopyWith(LocationStatus value, $Res Function(LocationStatus) _then) = _$LocationStatusCopyWithImpl;
@useResult
$Res call({
 LocationPermissionStatus permission, bool serviceEnabled
});




}
/// @nodoc
class _$LocationStatusCopyWithImpl<$Res>
    implements $LocationStatusCopyWith<$Res> {
  _$LocationStatusCopyWithImpl(this._self, this._then);

  final LocationStatus _self;
  final $Res Function(LocationStatus) _then;

/// Create a copy of LocationStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? permission = null,Object? serviceEnabled = null,}) {
  return _then(_self.copyWith(
permission: null == permission ? _self.permission : permission // ignore: cast_nullable_to_non_nullable
as LocationPermissionStatus,serviceEnabled: null == serviceEnabled ? _self.serviceEnabled : serviceEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [LocationStatus].
extension LocationStatusPatterns on LocationStatus {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LocationStatus value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LocationStatus() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LocationStatus value)  $default,){
final _that = this;
switch (_that) {
case _LocationStatus():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LocationStatus value)?  $default,){
final _that = this;
switch (_that) {
case _LocationStatus() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LocationPermissionStatus permission,  bool serviceEnabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LocationStatus() when $default != null:
return $default(_that.permission,_that.serviceEnabled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LocationPermissionStatus permission,  bool serviceEnabled)  $default,) {final _that = this;
switch (_that) {
case _LocationStatus():
return $default(_that.permission,_that.serviceEnabled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LocationPermissionStatus permission,  bool serviceEnabled)?  $default,) {final _that = this;
switch (_that) {
case _LocationStatus() when $default != null:
return $default(_that.permission,_that.serviceEnabled);case _:
  return null;

}
}

}

/// @nodoc


class _LocationStatus extends LocationStatus {
  const _LocationStatus({required this.permission, required this.serviceEnabled}): super._();
  

@override final  LocationPermissionStatus permission;
/// The device location service (GPS) is switched on.
@override final  bool serviceEnabled;

/// Create a copy of LocationStatus
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LocationStatusCopyWith<_LocationStatus> get copyWith => __$LocationStatusCopyWithImpl<_LocationStatus>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LocationStatus&&(identical(other.permission, permission) || other.permission == permission)&&(identical(other.serviceEnabled, serviceEnabled) || other.serviceEnabled == serviceEnabled));
}


@override
int get hashCode => Object.hash(runtimeType,permission,serviceEnabled);

@override
String toString() {
  return 'LocationStatus(permission: $permission, serviceEnabled: $serviceEnabled)';
}


}

/// @nodoc
abstract mixin class _$LocationStatusCopyWith<$Res> implements $LocationStatusCopyWith<$Res> {
  factory _$LocationStatusCopyWith(_LocationStatus value, $Res Function(_LocationStatus) _then) = __$LocationStatusCopyWithImpl;
@override @useResult
$Res call({
 LocationPermissionStatus permission, bool serviceEnabled
});




}
/// @nodoc
class __$LocationStatusCopyWithImpl<$Res>
    implements _$LocationStatusCopyWith<$Res> {
  __$LocationStatusCopyWithImpl(this._self, this._then);

  final _LocationStatus _self;
  final $Res Function(_LocationStatus) _then;

/// Create a copy of LocationStatus
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? permission = null,Object? serviceEnabled = null,}) {
  return _then(_LocationStatus(
permission: null == permission ? _self.permission : permission // ignore: cast_nullable_to_non_nullable
as LocationPermissionStatus,serviceEnabled: null == serviceEnabled ? _self.serviceEnabled : serviceEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on

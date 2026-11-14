// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'biometric_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BiometricStatus {

/// The device has biometric hardware.
 bool get isSupported;/// Biometrics the user has enrolled in the system settings.
 List<BiometricKind> get enrolled;
/// Create a copy of BiometricStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BiometricStatusCopyWith<BiometricStatus> get copyWith => _$BiometricStatusCopyWithImpl<BiometricStatus>(this as BiometricStatus, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BiometricStatus&&(identical(other.isSupported, isSupported) || other.isSupported == isSupported)&&const DeepCollectionEquality().equals(other.enrolled, enrolled));
}


@override
int get hashCode => Object.hash(runtimeType,isSupported,const DeepCollectionEquality().hash(enrolled));

@override
String toString() {
  return 'BiometricStatus(isSupported: $isSupported, enrolled: $enrolled)';
}


}

/// @nodoc
abstract mixin class $BiometricStatusCopyWith<$Res>  {
  factory $BiometricStatusCopyWith(BiometricStatus value, $Res Function(BiometricStatus) _then) = _$BiometricStatusCopyWithImpl;
@useResult
$Res call({
 bool isSupported, List<BiometricKind> enrolled
});




}
/// @nodoc
class _$BiometricStatusCopyWithImpl<$Res>
    implements $BiometricStatusCopyWith<$Res> {
  _$BiometricStatusCopyWithImpl(this._self, this._then);

  final BiometricStatus _self;
  final $Res Function(BiometricStatus) _then;

/// Create a copy of BiometricStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isSupported = null,Object? enrolled = null,}) {
  return _then(_self.copyWith(
isSupported: null == isSupported ? _self.isSupported : isSupported // ignore: cast_nullable_to_non_nullable
as bool,enrolled: null == enrolled ? _self.enrolled : enrolled // ignore: cast_nullable_to_non_nullable
as List<BiometricKind>,
  ));
}

}


/// Adds pattern-matching-related methods to [BiometricStatus].
extension BiometricStatusPatterns on BiometricStatus {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BiometricStatus value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BiometricStatus() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BiometricStatus value)  $default,){
final _that = this;
switch (_that) {
case _BiometricStatus():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BiometricStatus value)?  $default,){
final _that = this;
switch (_that) {
case _BiometricStatus() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isSupported,  List<BiometricKind> enrolled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BiometricStatus() when $default != null:
return $default(_that.isSupported,_that.enrolled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isSupported,  List<BiometricKind> enrolled)  $default,) {final _that = this;
switch (_that) {
case _BiometricStatus():
return $default(_that.isSupported,_that.enrolled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isSupported,  List<BiometricKind> enrolled)?  $default,) {final _that = this;
switch (_that) {
case _BiometricStatus() when $default != null:
return $default(_that.isSupported,_that.enrolled);case _:
  return null;

}
}

}

/// @nodoc


class _BiometricStatus extends BiometricStatus {
  const _BiometricStatus({required this.isSupported, final  List<BiometricKind> enrolled = const <BiometricKind>[]}): _enrolled = enrolled,super._();
  

/// The device has biometric hardware.
@override final  bool isSupported;
/// Biometrics the user has enrolled in the system settings.
 final  List<BiometricKind> _enrolled;
/// Biometrics the user has enrolled in the system settings.
@override@JsonKey() List<BiometricKind> get enrolled {
  if (_enrolled is EqualUnmodifiableListView) return _enrolled;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_enrolled);
}


/// Create a copy of BiometricStatus
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BiometricStatusCopyWith<_BiometricStatus> get copyWith => __$BiometricStatusCopyWithImpl<_BiometricStatus>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BiometricStatus&&(identical(other.isSupported, isSupported) || other.isSupported == isSupported)&&const DeepCollectionEquality().equals(other._enrolled, _enrolled));
}


@override
int get hashCode => Object.hash(runtimeType,isSupported,const DeepCollectionEquality().hash(_enrolled));

@override
String toString() {
  return 'BiometricStatus(isSupported: $isSupported, enrolled: $enrolled)';
}


}

/// @nodoc
abstract mixin class _$BiometricStatusCopyWith<$Res> implements $BiometricStatusCopyWith<$Res> {
  factory _$BiometricStatusCopyWith(_BiometricStatus value, $Res Function(_BiometricStatus) _then) = __$BiometricStatusCopyWithImpl;
@override @useResult
$Res call({
 bool isSupported, List<BiometricKind> enrolled
});




}
/// @nodoc
class __$BiometricStatusCopyWithImpl<$Res>
    implements _$BiometricStatusCopyWith<$Res> {
  __$BiometricStatusCopyWithImpl(this._self, this._then);

  final _BiometricStatus _self;
  final $Res Function(_BiometricStatus) _then;

/// Create a copy of BiometricStatus
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isSupported = null,Object? enrolled = null,}) {
  return _then(_BiometricStatus(
isSupported: null == isSupported ? _self.isSupported : isSupported // ignore: cast_nullable_to_non_nullable
as bool,enrolled: null == enrolled ? _self._enrolled : enrolled // ignore: cast_nullable_to_non_nullable
as List<BiometricKind>,
  ));
}


}

// dart format on

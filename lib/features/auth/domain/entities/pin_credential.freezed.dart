// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pin_credential.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PinCredential {

/// Base64 of the derived key.
 String get hash;/// Base64 of the random salt used for this PIN.
 String get salt;/// Work factor used when the hash was created.
 int get iterations;
/// Create a copy of PinCredential
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PinCredentialCopyWith<PinCredential> get copyWith => _$PinCredentialCopyWithImpl<PinCredential>(this as PinCredential, _$identity);

  /// Serializes this PinCredential to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PinCredential&&(identical(other.hash, hash) || other.hash == hash)&&(identical(other.salt, salt) || other.salt == salt)&&(identical(other.iterations, iterations) || other.iterations == iterations));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hash,salt,iterations);

@override
String toString() {
  return 'PinCredential(hash: $hash, salt: $salt, iterations: $iterations)';
}


}

/// @nodoc
abstract mixin class $PinCredentialCopyWith<$Res>  {
  factory $PinCredentialCopyWith(PinCredential value, $Res Function(PinCredential) _then) = _$PinCredentialCopyWithImpl;
@useResult
$Res call({
 String hash, String salt, int iterations
});




}
/// @nodoc
class _$PinCredentialCopyWithImpl<$Res>
    implements $PinCredentialCopyWith<$Res> {
  _$PinCredentialCopyWithImpl(this._self, this._then);

  final PinCredential _self;
  final $Res Function(PinCredential) _then;

/// Create a copy of PinCredential
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hash = null,Object? salt = null,Object? iterations = null,}) {
  return _then(_self.copyWith(
hash: null == hash ? _self.hash : hash // ignore: cast_nullable_to_non_nullable
as String,salt: null == salt ? _self.salt : salt // ignore: cast_nullable_to_non_nullable
as String,iterations: null == iterations ? _self.iterations : iterations // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PinCredential].
extension PinCredentialPatterns on PinCredential {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PinCredential value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PinCredential() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PinCredential value)  $default,){
final _that = this;
switch (_that) {
case _PinCredential():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PinCredential value)?  $default,){
final _that = this;
switch (_that) {
case _PinCredential() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String hash,  String salt,  int iterations)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PinCredential() when $default != null:
return $default(_that.hash,_that.salt,_that.iterations);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String hash,  String salt,  int iterations)  $default,) {final _that = this;
switch (_that) {
case _PinCredential():
return $default(_that.hash,_that.salt,_that.iterations);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String hash,  String salt,  int iterations)?  $default,) {final _that = this;
switch (_that) {
case _PinCredential() when $default != null:
return $default(_that.hash,_that.salt,_that.iterations);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PinCredential implements PinCredential {
  const _PinCredential({required this.hash, required this.salt, required this.iterations});
  factory _PinCredential.fromJson(Map<String, dynamic> json) => _$PinCredentialFromJson(json);

/// Base64 of the derived key.
@override final  String hash;
/// Base64 of the random salt used for this PIN.
@override final  String salt;
/// Work factor used when the hash was created.
@override final  int iterations;

/// Create a copy of PinCredential
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PinCredentialCopyWith<_PinCredential> get copyWith => __$PinCredentialCopyWithImpl<_PinCredential>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PinCredentialToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PinCredential&&(identical(other.hash, hash) || other.hash == hash)&&(identical(other.salt, salt) || other.salt == salt)&&(identical(other.iterations, iterations) || other.iterations == iterations));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hash,salt,iterations);

@override
String toString() {
  return 'PinCredential(hash: $hash, salt: $salt, iterations: $iterations)';
}


}

/// @nodoc
abstract mixin class _$PinCredentialCopyWith<$Res> implements $PinCredentialCopyWith<$Res> {
  factory _$PinCredentialCopyWith(_PinCredential value, $Res Function(_PinCredential) _then) = __$PinCredentialCopyWithImpl;
@override @useResult
$Res call({
 String hash, String salt, int iterations
});




}
/// @nodoc
class __$PinCredentialCopyWithImpl<$Res>
    implements _$PinCredentialCopyWith<$Res> {
  __$PinCredentialCopyWithImpl(this._self, this._then);

  final _PinCredential _self;
  final $Res Function(_PinCredential) _then;

/// Create a copy of PinCredential
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hash = null,Object? salt = null,Object? iterations = null,}) {
  return _then(_PinCredential(
hash: null == hash ? _self.hash : hash // ignore: cast_nullable_to_non_nullable
as String,salt: null == salt ? _self.salt : salt // ignore: cast_nullable_to_non_nullable
as String,iterations: null == iterations ? _self.iterations : iterations // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on

import 'dart:convert';

import 'package:hive_ce/hive.dart';

/// Typed CRUD over a Hive box that stores each value as a JSON string.
///
/// Repositories build on this so none of them repeat encode/decode code.
class JsonBoxStore<T> {
  const JsonBoxStore({
    required Box<String> box,
    required T Function(Map<String, dynamic> json) fromJson,
    required Map<String, dynamic> Function(T value) toJson,
  }) : _box = box,
       _fromJson = fromJson,
       _toJson = toJson;

  final Box<String> _box;
  final T Function(Map<String, dynamic> json) _fromJson;
  final Map<String, dynamic> Function(T value) _toJson;

  List<T> readAll() => _box.values.map(_decode).toList();

  T? read(String key) {
    final raw = _box.get(key);
    return raw == null ? null : _decode(raw);
  }

  Future<void> write(String key, T value) => _box.put(key, _encode(value));

  Future<void> writeAll(Map<String, T> entries) {
    return _box.putAll(
      entries.map((key, value) => MapEntry(key, _encode(value))),
    );
  }

  Future<void> delete(String key) => _box.delete(key);

  Future<void> clear() => _box.clear();

  String _encode(T value) => jsonEncode(_toJson(value));

  T _decode(String raw) => _fromJson(jsonDecode(raw) as Map<String, dynamic>);
}

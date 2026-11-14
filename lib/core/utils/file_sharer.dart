import 'dart:io';
import 'dart:ui';

import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smart_access_security/core/errors/failures.dart';

part 'file_sharer.g.dart';

/// Writes text to a temporary file and opens the system share sheet.
// An interface keeps file and plugin access out of tests.
// ignore: one_member_abstracts
abstract interface class FileSharer {
  /// [origin] anchors the share popover on iPad.
  ///
  /// Throws an [ExportFailure] when the file cannot be written or shared.
  Future<void> shareText({
    required String fileName,
    required String content,
    required String mimeType,
    Rect? origin,
  });
}

/// [FileSharer] using `path_provider` and `share_plus`.
class SharePlusFileSharer implements FileSharer {
  const SharePlusFileSharer();

  @override
  Future<void> shareText({
    required String fileName,
    required String content,
    required String mimeType,
    Rect? origin,
  }) async {
    try {
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/$fileName');
      await file.writeAsString(content, flush: true);
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path, mimeType: mimeType, name: fileName)],
          subject: fileName,
          sharePositionOrigin: origin,
        ),
      );
    } on Exception {
      throw const ExportFailure();
    }
  }
}

@Riverpod(keepAlive: true)
FileSharer fileSharer(Ref ref) => const SharePlusFileSharer();

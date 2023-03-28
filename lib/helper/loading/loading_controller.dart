import 'package:flutter/foundation.dart' show immutable;

typedef CloseLoading = bool Function();
typedef UpdateLoading = bool Function(String text);

@immutable
class LoadingController {
  final CloseLoading close;
  final UpdateLoading update;

  const LoadingController({
    required this.close,
    required this.update,
  });
}

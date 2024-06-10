import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

bool _shouldUseMeta() => Platform.isMacOS || Platform.isIOS;

/// SingleActivator, который срабатывает, если [key] нажата с
/// * `Control` для  платформ
///
/// Также можно передать в конструктор [shift] и [alt].
osSingleActivator(
  LogicalKeyboardKey key, [
  bool shift = false,
  bool alt = false,
]) {
  final meta = _shouldUseMeta();
  final control = !meta;

  return SingleActivator(
    key,
    control: control,
    meta: meta,
    shift: shift,
    alt: alt,
  );
}

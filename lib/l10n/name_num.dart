import 'package:financeOFF/l10n/extension.dart';
import 'package:flutter/material.dart';

abstract class LocalizedEnum {
  String get localizationEnumValue;
  String get localizationEnumName;
}

extension LocalizedNameEnums on LocalizedEnum {
  String get localizedTextKey =>
      "enum.$localizationEnumName@$localizationEnumValue";

  String get localizedName => localizedTextKey.tr();
  String localizedNameContext(BuildContext context, [dynamic replace]) =>
      localizedTextKey.t(context, replace);
}

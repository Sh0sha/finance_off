  import 'package:financeOFF/l10n/extension.dart';

String? checkReqPole(String? input) {
  if (input == null || input.isEmpty || input.trim().isEmpty) {
    return "error.input.mustBeNotEmpty".tr();
  }

  return null;
}

import 'package:financeOFF/l10n/extension.dart';
import 'package:financeOFF/prefs.dart';
import 'package:financeOFF/theme/theme.dart';
import 'package:financeOFF/widgets/general/list_header.dart';
import 'package:flutter/material.dart';

class NumpadPreferencesPage extends StatefulWidget {
  const NumpadPreferencesPage({super.key});

  @override
  State<NumpadPreferencesPage> createState() => _NumpadPreferencesPageState();
}

class _NumpadPreferencesPageState extends State<NumpadPreferencesPage> {
  @override
  Widget build(BuildContext context) {
    final bool usePhoneNumpadLayout =
        LocalPreferences().usePhoneNumpadLayout.get();
    final bool enableNumpadHapticFeedback =
        LocalPreferences().enableNumpadHapticFeedback.get();

    return Scaffold(
      appBar: AppBar(
        title: Text("preferences.numpad".t(context)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16.0),
              ListHeader("preferences.numpad.layout".t(context)),
              const SizedBox(height: 32.0),
              CheckboxListTile.adaptive(
                title: Text("preferences.numpad.haptics".t(context)),
                value: enableNumpadHapticFeedback,
                onChanged: updateHapticUsage,
                subtitle:
                    Text("preferences.numpad.haptics.description".t(context)),
                activeColor: context.colorScheme.primary,
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }

  void updateLayoutPreference(bool usePhoneLayout) async {
    await LocalPreferences().usePhoneNumpadLayout.set(usePhoneLayout);

    if (mounted) setState(() {});
  }

  void updateHapticUsage(bool? enableHaptics) async {
    if (enableHaptics == null) return;

    await LocalPreferences().enableNumpadHapticFeedback.set(enableHaptics);
    if (mounted) setState(() {});
  }
}

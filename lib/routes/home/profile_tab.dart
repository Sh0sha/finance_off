import 'package:financeOFF/l10n/extension.dart';
import 'package:financeOFF/objectbox.dart';
import 'package:financeOFF/widgets/general/button.dart';
import 'package:financeOFF/widgets/home/prefs/profile_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';


class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  bool _debugDbBusy = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // padding: const EdgeInsets.all(16.0),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24.0),
          const Center(child: ProfileCard()),
          const SizedBox(height: 24.0),
          ListTile(
            title: Text("categories".t(context)),
            leading: const Icon(Symbols.category_rounded),
            onTap: () => context.push("/categories"),
          ),
          ListTile(
            title: Text("tabs.profile.preferences".t(context)),
            leading: const Icon(Symbols.settings_rounded),
            onTap: () => context.push("/preferences"),
          ),
          const SizedBox(height: 64.0),
          const SizedBox(height: 24.0),
          const SizedBox(height: 96.0),
        ],
      ),
    );
  }

  void resetDatabase() async {
    if (_debugDbBusy) return;

    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        title: const Text("[dev] Сбросить базу данных?"),
        actions: [
          Button(
            onTap: () => context.pop(true),
            child: const Text("Потвердить удаление"),
          ),
          Button(
            onTap: () => context.pop(false),
            child: const Text("Отмена"),
          ),
        ],
      ),
    );

    setState(() {
      _debugDbBusy = true;
    });

    try {
      if (confirm == true) {
        await ObjectBox().eraseMainData();
      }
    } finally {
      _debugDbBusy = false;

      if (mounted) {
        setState(() {});
      }
    }
  }


}

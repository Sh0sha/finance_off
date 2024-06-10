import 'package:financeOFF/l10n/extension.dart';
import 'package:financeOFF/prefs.dart';
import 'package:financeOFF/routes/preferences/transfer_preferences/combine_transfer_radio.dart.dart';
import 'package:financeOFF/theme/theme.dart';
import 'package:financeOFF/widgets/general/list_header.dart';
import 'package:flutter/material.dart';

class TransferPreferencesPage extends StatefulWidget {
  const TransferPreferencesPage({super.key});

  @override
  State<TransferPreferencesPage> createState() =>
      _TransferPreferencesPageState();
}

class _TransferPreferencesPageState extends State<TransferPreferencesPage> {
  @override
  Widget build(BuildContext context) {
    final bool excludeTransferFromFlow =
        LocalPreferences().excludeTransferFromFlow.get();
    final bool combineTransferTransactions =
        LocalPreferences().combineTransferTransactions.get();

    return Scaffold(
      appBar: AppBar(
        title: Text("preferences.transfer".t(context)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16.0),
              ListHeader(
                  "preferences.transfer.combineTransferTransaction".t(context)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: CombineTransferRadio.combine(
                        currentlyUsingCombineMode: combineTransferTransactions,
                        onTap: () => updateCombineTransferTransactions(true),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: CombineTransferRadio.separate(
                        currentlyUsingCombineMode: combineTransferTransactions,
                        onTap: () => updateCombineTransferTransactions(false),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }

  void updateExcludeTransferFromFlow(bool? excludeFromFlow) async {
    if (excludeFromFlow == null) return;

    await LocalPreferences().excludeTransferFromFlow.set(excludeFromFlow);

    if (mounted) setState(() {});
  }

  void updateCombineTransferTransactions(bool? combine) async {
    if (combine == null) return;

    await LocalPreferences().combineTransferTransactions.set(combine);

    if (mounted) setState(() {});
  }
}

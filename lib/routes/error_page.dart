import 'package:financeOFF/data/financeoff_icon.dart';
import 'package:financeOFF/l10n/extension.dart';
import 'package:financeOFF/theme/theme.dart';
import 'package:financeOFF/widgets/general/button.dart';
import 'package:financeOFF/widgets/general/fin_icon.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

class ErrorPage extends StatelessWidget {
  final String? error;

  const ErrorPage({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FinIcon(
                  FinIconData.icon(Icons.emoji_emotions_outlined),
                  size: 80.0,
                  plated: true,
                ),
                const SizedBox(height: 12.0),
                Text(
                  error ?? "error.route.404".t(context),
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.flowColors.rashod,
                  ),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
                if (context.canPop()) ...[
                  const SizedBox(height: 16.0),
                  Button(
                    onTap: () => context.pop(),
                    leading: const Icon(Symbols.chevron_left_rounded),
                    child: Text("general.back".t(context)),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:financeOFF/entity/transaction.dart';
import 'package:financeOFF/l10n/extension.dart';
import 'package:financeOFF/l10n/name_num.dart';
import 'package:financeOFF/main.dart';
import 'package:financeOFF/prefs.dart';
import 'package:financeOFF/theme/navbar_theme.dart';
import 'package:financeOFF/theme/theme.dart';
import 'package:flutter/material.dart' hide Flow;
import 'package:material_symbols_icons/symbols.dart';
import 'package:pie_menu/pie_menu.dart';

class NewOperationButton extends StatefulWidget {
  final Function(TransactionType type) onActionTap;

  const NewOperationButton({super.key, required this.onActionTap});

  @override
  State<NewOperationButton> createState() => _NewOperationButtonState();
}

class _NewOperationButtonState extends State<NewOperationButton> {
  double _buttonRotationTurns = 0.0;

  @override
  Widget build(BuildContext context) {
    final NavbarTheme navbarTheme = Theme.of(context).extension<NavbarTheme>()!;

    return ValueListenableBuilder(
        valueListenable:
            LocalPreferences().transactionButtonOrder.valueNotifier,
        builder: (context, buttonOrder, child) {
          buttonOrder ??= TransactionType.values;

          return PieMenu(
            theme: Fin.of(context).pieTheme.copyWith(
                  customAngle: 90.0,
                  customAngleDiff: 48.0,
                  radius: 108.0,
                  customAngleAnchor: PieAnchor.center,
                  leftClickShowsMenu: true,
                  rightClickShowsMenu: true,
                  delayDuration: Duration.zero,
                ),
            onToggle: onToggle,
            actions: [
              for (final transactionType in buttonOrder)
                PieAction(
                  tooltip: Text(transactionType.localizedNameContext(context)),
                  onSelect: () => widget.onActionTap(transactionType),
                  child: Icon(
                    transactionType.icon,
                    weight: 800.0,
                  ),
                  buttonTheme: PieButtonTheme(
                    backgroundColor:
                        transactionType.actionBackgroundColor(context),
                    iconColor: transactionType.actionColor(context),
                  ),
                ),
            ],
            child: StatefulBuilder(
              builder: (context, setState) => Tooltip(
                message: "transaction.new".t(context),
                child: Material(
                  color: navbarTheme.transactionButtonBackgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: AnimatedRotation(
                      turns: _buttonRotationTurns,
                      duration: const Duration(milliseconds: 600),
                      child: Icon(
                        Symbols.add_rounded,
                        fill: 0.0,
                        color: navbarTheme.transactionButtonForegroundColor,
                        weight: 600.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  void onToggle(bool toggled) {
    _buttonRotationTurns = toggled ? 0.125 : 0.25;
    setState(() {});
  }
}

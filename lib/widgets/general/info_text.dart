import 'package:financeOFF/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class InfoText extends StatelessWidget {
  /// Центрирует текст и значок вертикально, а не сверху.
  final bool singleLine;

  final Widget child;

  const InfoText({super.key, required this.child, this.singleLine = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment:
          singleLine ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Icon(
          Symbols.info_rounded,
          fill: 0,
          color: context.flowColors.semi,
          size: 16.0,
        ),
        const SizedBox(width: 4.0),
        Flexible(
          child: DefaultTextStyle(
            style: context.textTheme.bodySmall!.semi(context),
            child: child,
          ),
        ),
      ],
    );
  }
}

import 'package:financeOFF/prefs.dart';
import 'package:financeOFF/theme/theme.dart';
import 'package:financeOFF/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class NumpadButton extends StatelessWidget {
  /// Цвет материала
  final Color? backgroundColor;

  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onDoubleTap;

  final int crossAxisCellCount;
  final int mainAxisCellCount;

  final double borderRadiusSize;

  /// В идеале виджет [Icon] или [Text] с односимвольным текстом.
  final Widget child;

  const NumpadButton({
    super.key,
    required this.child,
    this.backgroundColor,
    this.onTap,
    this.onLongPress,
    this.onDoubleTap,
    this.borderRadiusSize = 16.0,
    this.crossAxisCellCount = 1,
    this.mainAxisCellCount = 1,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(borderRadiusSize);

    return StaggeredGridTile.count(
      crossAxisCellCount: crossAxisCellCount,
      mainAxisCellCount: mainAxisCellCount,
      child: Material(
        textStyle: DefaultTextStyle.of(context).style,
        type: MaterialType.button,
        color: backgroundColor ?? context.colorScheme.secondary,
        borderRadius: borderRadius,
        child: InkWell(
          borderRadius: borderRadius,
          onTap: onTap == null ? null : onTapHandler,
          onDoubleTap: onDoubleTap,
          onLongPress: onLongPress,
          child: Center(
            child: child,
          ),
        ),
      ),
    );
  }

  void onTapHandler() {
    if (LocalPreferences().enableNumpadHapticFeedback.get()) {
      numpadHaptic();
    }

    if (onTap != null) {
      onTap!();
    }
  }
}

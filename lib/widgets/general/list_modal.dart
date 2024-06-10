import 'dart:math';

import 'package:financeOFF/theme/theme.dart';
import 'package:flutter/material.dart';

class ListModal extends StatelessWidget {
  final Widget? title;

  final Widget? child;

  final Widget? leading;
  final Widget? trailing;

  final double leadingSpacing;
  final double trailingSpacing;

  final double topSpacing;
  final double titleSpacing;

  final bool scrollable;

  /// Если [scrollableContentMaxHeight] меньше [this], [this] будет использоваться вместо максимальной высоты.
  ///
  /// Высота прокрутки содержимого: `math.max(scrollableContentMaxHeight, minScrollableContentHeight)`
  final double minScrollableContentHeight;
  final double scrollableContentMaxHeight;

  const ListModal({
    super.key,
    this.title,
    this.child,
    this.leading,
    this.trailing,
    this.topSpacing = 16.0,
    this.titleSpacing = 16.0,
    this.leadingSpacing = 8.0,
    this.trailingSpacing = 8.0,
  })  : scrollable = false,
        scrollableContentMaxHeight = 0,
        minScrollableContentHeight = 0;

  const ListModal.scrollable({
    super.key,
    this.title,
    this.child,
    this.leading,
    this.trailing,
    this.minScrollableContentHeight = 280.0,
    this.topSpacing = 16.0,
    this.titleSpacing = 16.0,
    this.leadingSpacing = 8.0,
    this.trailingSpacing = 8.0,
    required this.scrollableContentMaxHeight,
  }) : scrollable = true;

  @override
  Widget build(BuildContext context) {
    final Widget? title = this.title == null
        ? null
        : DefaultTextStyle(
            style: context.textTheme.headlineSmall!,
            textAlign: TextAlign.center,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: this.title!,
            ),
          );

    final Widget? content = switch ((child, scrollable)) {
      (null, _) => null,
      (Widget child, false) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: child,
        ),
      (Widget scrollableChild, true) =>
        LayoutBuilder(builder: (context, constraints) {
          return AnimatedContainer(
            constraints: BoxConstraints.loose(
              Size(
                double.infinity,
                // TODO переместить это в родительский виджет (внизу)
                min(max(minScrollableContentHeight, scrollableContentMaxHeight),
                    constraints.maxHeight),
              ),
            ),
            duration: const Duration(milliseconds: 200),
            child: scrollableChild,
          );
        }),
    };

    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: topSpacing),
            if (title != null) title,
            if (title != null && (leading != null || content != null))
              SizedBox(height: titleSpacing),
            if (leading != null) ...[
              leading!,
              SizedBox(height: leadingSpacing),
            ],
            if (content != null) content,
            if (trailing != null) ...[
              SizedBox(height: trailingSpacing),
              trailing!,
            ],
          ],
        ),
      ),
    );
  }
}

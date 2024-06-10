import 'package:financeOFF/data/financeoff_icon.dart';
import 'package:financeOFF/l10n/extension.dart';
import 'package:financeOFF/widgets/general/list_modal.dart';
import 'package:financeOFF/widgets/select_flow_icon_sheet/select_icon_char.dart';
import 'package:financeOFF/widgets/select_flow_icon_sheet/select_icon_icon_list.dart';
import 'package:financeOFF/widgets/select_flow_icon_sheet/select_image_icon_list.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Pops with [FinIconData] or [null]
class SelectFlowIconSheet extends StatefulWidget {
  final FinIconData? current;

  final double iconSize;

  const SelectFlowIconSheet({
    super.key,
    this.current,
    this.iconSize = 96.0,
  });

  @override
  State<SelectFlowIconSheet> createState() => _SelectFlowIconSheetState();
}

class _SelectFlowIconSheetState extends State<SelectFlowIconSheet>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return ListModal.scrollable(
      scrollableContentMaxHeight: MediaQuery.of(context).size.height * .5,
      title: Text("flowIcon.change".t(context)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Symbols.category_rounded),
            title: Text("flowIcon.type.icon".t(context)),
            onTap: () => _selectIcon(),
          ),
          ListTile(
            leading: const Icon(Symbols.glyphs_rounded),
            title: Text("flowIcon.type.character".t(context)),
            onTap: () => _selectEmoji(),
          ),
          ListTile(
            leading: const Icon(Symbols.image_rounded),
            title: Text("flowIcon.type.image".t(context)),
            onTap: () => _selectImage(),
          ),
        ],
      ),
    );
  }

  void _selectIcon() async {
    final FinIconData? result = await showModalBottomSheet<IconFinIcon>(
      context: context,
      builder: (context) => SelectiIconIconList(
        initialValue: widget.current,
      ),
      isScrollControlled: true,
    );

    if (mounted) {
      context.pop(result);
    }
  }

  void _selectEmoji() async {
    final FinIconData? result = await showModalBottomSheet<CharacherFinIcon>(
      context: context,
      builder: (context) => SelectIconChar(
        iconSize: widget.iconSize,
        initialValue: widget.current,
      ),
      isScrollControlled: true,
    );

    if (mounted) {
      context.pop(result);
    }
  }

  void _selectImage() async {
    final FinIconData? result = await showModalBottomSheet<ImageFinIcon>(
      context: context,
      builder: (context) => SelectImageIconList(
        iconSize: widget.iconSize,
        initialValue: widget.current,
      ),
    );

    if (mounted) {
      context.pop(result);
    }
  }
}

import 'package:financeOFF/data/financeoff_icon.dart';
import 'package:financeOFF/data/icons.dart';
import 'package:financeOFF/l10n/extension.dart';
import 'package:financeOFF/widgets/general/list_modal.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

/// появляется с[IconFinIcon] или [null]
class SelectiIconIconList extends StatefulWidget {
  final FinIconData? initialValue;

  const SelectiIconIconList({super.key, this.initialValue});

  @override
  State<SelectiIconIconList> createState() =>
      _SelectiIconIconListState();
}

class _SelectiIconIconListState extends State<SelectiIconIconList>
    with SingleTickerProviderStateMixin {
  late final TabController _controller;

  String _query = "";

  IconFinIcon? value;

  @override
  void initState() {
    super.initState();

    value = widget.initialValue is IconFinIcon
        ? widget.initialValue as IconFinIcon
        : null;

    _controller = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double scrollableContentMaxHeight =
        MediaQuery.of(context).size.height * 0.4 -
            MediaQuery.of(context).viewInsets.vertical;

    final List<IconData> simpleIconsResult = querySimpleIcons(_query);
    final List<IconData> materialSymbolsResult = queryMaterialSymbols(_query);

    return ListModal.scrollable(
      scrollableContentMaxHeight: scrollableContentMaxHeight,
      title: Text("flowIcon.type.icon".t(context)),
      leadingSpacing: 0.0,
      leading: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              onChanged: _updateQuery,
              onSubmitted: _updateQuery,
              decoration: InputDecoration(
                hintText: "flowIcon.type.icon.search".t(context),
                prefixIcon: const Icon(Symbols.search_rounded),
              ),
            ),
          ),
          TabBar(
            tabs: [
              Tab(
                text: "flowIcon.type.icon.brands".t(context),
              ),
              Tab(
                text: "flowIcon.type.icon.symbols".t(context),
              ),
            ],
            controller: _controller,
          )
        ],
      ),
      trailing: ButtonBar(
        children: [
          TextButton.icon(
            onPressed: () => context.pop(value),
            icon: const Icon(Symbols.check_rounded),
            label: Text(
              "general.done".t(context),
            ),
          ),
        ],
      ),
      child: TabBarView(
        controller: _controller,
        children: [
          GridView.builder(
            itemBuilder: (context, index) => IconButton(
              onPressed: () => updateIcon(simpleIconsResult[index]),
              icon: Icon(simpleIconsResult[index]),
              iconSize: 48.0,
            ),
            itemCount: simpleIconsResult.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 72.0,
            ),
          ),
          GridView.builder(
            itemBuilder: (context, index) => IconButton(
              onPressed: () => updateIcon(materialSymbolsResult[index]),
              icon: Icon(materialSymbolsResult[index]),
              iconSize: 48.0,
            ),
            itemCount: materialSymbolsResult.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 72.0,
            ),
          ),
        ],
      ),
    );
  }

  void _updateQuery(String value) {
    _query = value;
    // if (_scrollController.hasClients) {
    //   _scrollController.jumpTo(0);
    // }
    setState(() {});
  }

  void updateIcon(IconData iconData) {
    value = IconFinIcon(iconData);
    setState(() {});
  }
}

import 'package:financeOFF/data/valyuta.dart';
import 'package:financeOFF/l10n/extension.dart';
import 'package:financeOFF/theme/theme.dart';
import 'package:financeOFF/utils/utils.dart';
import 'package:financeOFF/widgets/general/list_modal.dart';
import 'package:flutter/material.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:fuzzywuzzy/model/extracted_result.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Pops with a valid [ISO 4217](https://en.wikipedia.org/wiki/ISO_4217) currency code [String]
class SelectValyutaList extends StatefulWidget {
  final String? currentlySelected;

  const SelectValyutaList({super.key, this.currentlySelected});

  @override
  State<SelectValyutaList> createState() => _SelectValyutaListState();
}

class _SelectValyutaListState extends State<SelectValyutaList> {
  final ScrollController _scrollController = ScrollController();

  String _query = "";

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ISO4217Currencies.currencies.length

    final List<ExtractedResult<CurrencyData>> queryResults =
        extractTop<CurrencyData>(
      query: _query.trim(),
      choices: iso4217Currencies,
      limit: 10,
      getter: (currencyData) =>
          "${currencyData.code} ${currencyData.name} ${currencyData.country}",
    )
            .groupBy((resultItem) => resultItem.choice.code)
            .values
            .map((e) => e.firstOrNull)
            .nonNulls
            .toList();

    // Artificially deprioritize North Korean Won due to its unpopularity
    final int kpwIndex =
        queryResults.indexWhere((element) => element.choice.code == "KPW");

    if (kpwIndex > -1) {
      final ExtractedResult<CurrencyData> kpw = queryResults.removeAt(kpwIndex);
      queryResults.add(kpw);
    }

    // Переместить выбранный элемент наверх
    final int selectedItemIndex = queryResults.indexWhere(
        (element) => element.choice.code == widget.currentlySelected);

    if (selectedItemIndex > -1) {
      final ExtractedResult<CurrencyData> selectedItem =
          queryResults.removeAt(selectedItemIndex);
      queryResults.insert(0, selectedItem);
    }

    return ListModal.scrollable(
      leading: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: TextField(
          onChanged: _updateQuery,
          onSubmitted: _updateQuery,
          decoration: InputDecoration(
            hintText: "currency.searchHint".t(context),
            prefixIcon: const Icon(Symbols.search_rounded),
          ),
        ),
      ),
      title: Text("account.edit.selectCurrency".t(context)),
      scrollableContentMaxHeight: MediaQuery.of(context).size.height * 0.4 -
          MediaQuery.of(context).viewInsets.vertical,
      child: ListView.builder(
        controller: _scrollController,
        itemBuilder: (context, i) {
          final CurrencyData transformedCurrencyData =
              iso4217CurrenciesGrouped[queryResults[i].choice.code]!;

          return ListTile(
            selected: widget.currentlySelected == transformedCurrencyData.code,
            title: Text(
              transformedCurrencyData.name,
            ),
            subtitle: Text(
              transformedCurrencyData.country.titleCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Text(
              transformedCurrencyData.code,
              style: context.textTheme.bodyLarge?.copyWith(
                fontFeatures: [const FontFeature.tabularFigures()],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () => select(transformedCurrencyData.code),
          );
        },
        itemCount: queryResults.length,
      ),
    );
  }

  void _updateQuery(String value) {
    _query = value;
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
    setState(() {});
  }

  void select(String code) {
    context.pop(code);
  }
}

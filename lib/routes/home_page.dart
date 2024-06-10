import 'package:financeOFF/entity/account.dart';
import 'package:financeOFF/entity/transaction.dart';
import 'package:financeOFF/main.dart';
import 'package:financeOFF/objectbox.dart';
import 'package:financeOFF/prefs.dart';
import 'package:financeOFF/routes/home/accounts_tab.dart';
import 'package:financeOFF/routes/home/home_tab.dart';
import 'package:financeOFF/routes/home/profile_tab.dart';
import 'package:financeOFF/routes/home/stats_tab.dart';
import 'package:financeOFF/utils/shortcut.dart';
import 'package:financeOFF/widgets/home/navbar.dart';
import 'package:financeOFF/widgets/home/navbar/new_operation_button.dart';
import 'package:flutter/material.dart' hide Flow;
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';
import 'package:pie_menu/pie_menu.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  final ScrollController _homeTabScrollController = ScrollController();

  late int _currentIndex;

  @override
  void initState() {
    super.initState();

    _currentIndex = 0;
    _tabController = TabController(
      vsync: this,
      length: 4,
      initialIndex: _currentIndex,
    );

    _tabController.addListener(() {
      setState(() {
        _currentIndex = _tabController.index;
      });
    });

    Future.delayed(const Duration(milliseconds: 200)).then((_) {
      if (!LocalPreferences().completedInitialSetup.get()) {
        context.pushReplacement("/setup");
        LocalPreferences().completedInitialSetup.set(true);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {
        osSingleActivator(LogicalKeyboardKey.keyN): () =>
            _newTransactionPage(null),
      },
      child: Focus(
        autofocus: true,
        child: PieCanvas(
          theme: Fin.of(context).pieTheme,
          child: BottomBar(
            width: double.infinity,
            offset: 16.0,
            barColor: const Color.fromARGB(0, 86, 75, 75),
            borderRadius: BorderRadius.circular(32.0),
            body: (context, scrollController) => Scaffold(
              body: SafeArea(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    HomeTab(
                      scrollController: _homeTabScrollController,
                    ),
                    const StatsTab(),
                    const AccountsTab(),
                    const ProfileTab(),
                  ],
                ),
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Navbar(
                  onTap: (i) => _navigateTo(i),
                  activeIndex: _currentIndex,
                ),
                NewOperationButton(
                  onActionTap: (type) => _newTransactionPage(type),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateTo(int index) {
    if (index == _tabController.index) {
      if (index == 0 && _homeTabScrollController.hasClients) {
        _homeTabScrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
      return;
    }

    _tabController.animateTo(index);
  }

  void _newTransactionPage(TransactionType? type) {

    if (ObjectBox().box<Account>().count(limit: 1) == 0) {
      context.push("/account/new");
      return;
    }

    type ??= TransactionType.rashod;

    context.push("/transaction/new?type=${type.value}");
  }
}

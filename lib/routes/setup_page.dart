import 'package:financeOFF/l10n/extension.dart';
import 'package:financeOFF/theme/theme.dart';
import 'package:financeOFF/widgets/general/button.dart';
import 'package:financeOFF/widgets/setup/welcome_slide.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SetupPage extends StatefulWidget {
  const SetupPage({super.key});

  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  late final PageController _pageController;

  static const int slideCount = 1;

  bool lastSlide = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    _pageController.addListener(() {
      lastSlide =
          _pageController.hasClients && _pageController.page == slideCount - 1;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          children: const [
            WelcomeSlide(),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Row(
            children: [
              SmoothPageIndicator(
                controller: _pageController, // PageController
                count: slideCount,
                effect: WormEffect(
                  dotColor: context.flowColors.semi,
                  activeDotColor: context.colorScheme.primary,
                  dotWidth: .0,
                  dotHeight: 12.0,
                  radius: 12.0,
                  spacing: 6.0,
                ),
                onDotClicked: (index) => _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                ),
              ),
              const Spacer(),
              Button(
                onTap: next,
                trailing: const Icon(Symbols.chevron_right_rounded),
                child: Text(lastSlide
                    ? "setup.getStarted".t(context)
                    : "setup.next".t(context)),
              )
            ],
          ),
        ),
      ),
    );
  }

  void next() {
    if (_pageController.page == null) return;

    final int currentPage = _pageController.page!.round();

    if (currentPage < (slideCount - 1)) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    } else {
      context.push("/setup/profile");
    }
  }
}

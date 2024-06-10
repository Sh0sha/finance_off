import 'package:financeOFF/l10n/extension.dart';
import 'package:financeOFF/theme/theme.dart';
import 'package:flutter/material.dart';

class WelcomeSlide extends StatelessWidget {
  const WelcomeSlide({super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    late final String logoPath;

    if (width <= 256) {
      logoPath = "assets/images/icon@256.png";
    } else if (width <= 512) {
      logoPath = "assets/images/icon.png";
    } else {
      logoPath = "assets/images/flow@1024.png";
    }

    return Padding(
      padding: const EdgeInsets.all(70.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24.0),
              child: Image.asset(logoPath),
            ),
          ),
          SizedBox(height: 70,),
          Text(
            "appName".t(context),
            style: context.textTheme.displayMedium?.copyWith(
              color: context.colorScheme.primary
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            "appShortDesc".t(context),
            style: context.textTheme.bodyLarge,
          ),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }
}

import 'package:financeOFF/entity/profile.dart';
import 'package:financeOFF/l10n/extension.dart';
import 'package:financeOFF/objectbox.dart';
import 'package:financeOFF/objectbox/objectbox.g.dart';
import 'package:financeOFF/widgets/general/profile_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GreetingsBar extends StatelessWidget {
  QueryBuilder<Profile> qb() => ObjectBox().box<Profile>().query();

  const GreetingsBar({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Profile?>(
      stream: qb()
          .watch(triggerImmediately: true)
          .map((event) => event.findFirst()),
      builder: (context, snapshot) {
        final profile = snapshot.data;

        return Row(
          children: [
            Text(
              "tabs.home.greetings".t(context, profile?.name ?? "..."),
              style: Theme.of(context).textTheme.titleMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            const SizedBox(width: 12.0),
            ProfileImage(
              filePath: profile?.imagePath,
              size: 40.0,
              onTap: profile != null
                  ? () => context.push("/profile/${profile.id}")
                  : null,
            ),
          ],
        );
      },
    );
  }
}

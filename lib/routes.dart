import 'package:financeOFF/entity/transaction.dart';
import 'package:financeOFF/l10n/extension.dart';
import 'package:financeOFF/routes/account/account_edit_page.dart';
import 'package:financeOFF/routes/acc_page.dart';
import 'package:financeOFF/routes/categories_page.dart';
import 'package:financeOFF/routes/category/category_edit_page.dart';
import 'package:financeOFF/routes/category_page.dart';
import 'package:financeOFF/routes/error_page.dart';

import 'package:financeOFF/routes/home_page.dart';
import 'package:financeOFF/routes/preferences/list_option_button_order.dart';
import 'package:financeOFF/routes/preferences/numpad_preferences_page.dart';
import 'package:financeOFF/routes/preferences/transfer_preferences_page.dart';
import 'package:financeOFF/routes/profile_page.dart';
import 'package:financeOFF/routes/setup/setup_accounts_page.dart';
import 'package:financeOFF/routes/setup/setup_categories_page.dart';
import 'package:financeOFF/routes/setup/setup_currency_page.dart';
import 'package:financeOFF/routes/setup/setup_profile_page.dart';
import 'package:financeOFF/routes/setup/setup_profile_picture_page.dart';
import 'package:financeOFF/routes/setup_page.dart';
import 'package:financeOFF/routes/operation_page.dart';
import 'package:financeOFF/routes/option_page.dart';
import 'package:financeOFF/routes/operations_page.dart';
import 'package:financeOFF/routes/utils/obrezka_image.dart';

import 'package:financeOFF/utils/utils.dart';
import 'package:financeOFF/widgets/general/info_text.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:moment_dart/moment_dart.dart';

final router = GoRouter(
  errorBuilder: (context, state) => ErrorPage(error: state.error?.toString()),
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/transaction/new',
      builder: (context, state) {
        final TransactionType? type = TransactionType.values.firstWhereOrNull(
          (element) => element.value == state.uri.queryParameters["type"],
        );

        return TransactionPage.create(initialTransactionType: type);
      },
    ),
    GoRoute(
      path: '/transaction/:id',
      builder: (context, state) => TransactionPage.edit(
        transactionId: int.tryParse(state.pathParameters["id"]!) ?? -1,
      ),
    ),
    GoRoute(
      path: '/transactions',
      builder: (context, state) => TransactionsPage.all(
        title: "transactions.all".t(context),
      ),
    ),
    GoRoute(
      path: '/transactions/upcoming',
      builder: (context, state) => TransactionsPage.upcoming(
        title: "transactions.upcoming".t(context),
        header: InfoText(
          singleLine: true,
          child: Text(
            "account.balance.upcomingDescription".t(context),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    ),
    GoRoute(
      path: '/account/new',
      builder: (context, state) => const AccountEditPage.create(),
    ),
    GoRoute(
        path: '/account/:id',
        builder: (context, state) => AccountPage(
              accountId: int.tryParse(state.pathParameters["id"]!) ?? -1,
              initialRange: TimeRange.tryParse(
                state.uri.queryParameters["range"] ?? "",
              ),
            ),
        routes: [
          GoRoute(
            path: 'edit',
            builder: (context, state) => AccountEditPage(
              accountId: int.tryParse(state.pathParameters["id"]!) ?? -1,
            ),
          ),
          GoRoute(
            path: 'transactions',
            builder: (context, state) => TransactionsPage.account(
              accountId: int.tryParse(state.pathParameters["id"]!) ?? -1,
              title: state.uri.queryParameters["title"],
            ),
          ),
        ]),
    GoRoute(
      path: '/category/new',
      builder: (context, state) => const CategoryEditPage.create(),
    ),
    GoRoute(
      path: '/category/:id',
      builder: (context, state) => CategoryPage(
        categoryId: int.tryParse(state.pathParameters["id"]!) ?? -1,
        initialRange: TimeRange.tryParse(
          state.uri.queryParameters["range"] ?? "",
        ),
      ),
      routes: [
        GoRoute(
          path: 'edit',
          builder: (context, state) => CategoryEditPage(
            categoryId: int.tryParse(state.pathParameters["id"]!) ?? -1,
          ),
        ),
      ],
    ),
    GoRoute(
      path: '/categories',
      builder: (context, state) => const CategoriesPage(),
    ),
    GoRoute(
      path: '/preferences',
      builder: (context, state) => const OptionPage(),
      routes: [
        GoRoute(
          path: 'numpad',
          builder: (context, state) => const NumpadPreferencesPage(),
        ),
        GoRoute(
          path: 'transfer',
          builder: (context, state) => const TransferPreferencesPage(),
        ),
        GoRoute(
          path: 'transactionButtonOrder',
          builder: (context, state) => const ButtonOrderPreferencesPage(),
        ),
      ],
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfilePage(),
    ),
    GoRoute(
      path: '/profile/:id',
      builder: (context, state) => ProfilePage(
          profileId: int.tryParse(state.pathParameters['id']!) ?? -1),
    ),
    GoRoute(
      path: '/utils/cropsquare',
      builder: (context, state) {
        return switch (state.extra) {
          CropSquareImagePageProps props => CropSquareImagePage(
              image: props.image,
              maxDimension: props.maxDimension,
              returnBitmap: props.returnBitmap,
            ),
          _ => throw const ErrorPage(
              error:
                  "Недопустимое состояние. Передайте объект [CropSquareImagePageProps] в дополнительную опору.",
            )
        };
      },
    ),




    GoRoute(
      path: '/setup',
      builder: (context, state) => const SetupPage(),
      routes: [
        GoRoute(
          path: 'profile',
          builder: (context, state) => const SetupProfilePage(),
        ),
        GoRoute(
          path: 'profile/photo',
          builder: (context, state) => SetupProfilePhotoPage(
            profileImagePath: state.extra as String,
          ),
        ),
        GoRoute(
          path: 'currency',
          builder: (context, state) => const SetupCurrencyPage(),
        ),
        GoRoute(
          path: 'accounts',
          builder: (context, state) => const SetupAccountsPage(),
        ),
        GoRoute(
          path: 'categories',
          builder: (context, state) => const SetupCategoriesPage(),
        ),
      ],
    ),

  ],
);

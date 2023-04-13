import 'package:data_provider_sqlite/data_provider_sqlite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:overlay_support/overlay_support.dart';
import 'application/use_case/archive_gem/archive_gem_use_case.dart';
import 'application/use_case/create_owned_gem/create_owned_gem_use_case.dart';
import 'application/use_case/delete_gem/delete_gem_use_case.dart';
import 'application/use_case/delete_owned_gem/delete_owned_gem_use_case.dart';
import 'application/use_case/update_gem/update_gem_use_case.dart';
import 'application/use_case/update_gem_order/update_gem_order_use_case.dart';
import 'bloc/app/app_cubit.dart';
import 'bloc/gem_form/gem_form_cubit.dart';
import 'bloc/gem_list/gem_list_cubit.dart';
import 'bloc/owned_gem/owned_gem_cubit.dart';
import 'domain/entity/gem.dart';
import 'domain/entity/gem_icon.dart';
import 'domain/entity/owned_gem.dart';
import 'domain/entity/setting.dart';
import 'domain/repository/gem_icon_repository.dart';
import 'domain/repository/gem_repository.dart';
import 'domain/repository/owned_gem_repository.dart';
import 'domain/repository/setting_repository.dart';
import 'domain/repository/statistics_day_repository.dart';
import 'infrastructure/repository/data_provider/config.dart';
import 'infrastructure/repository/data_provider/migrations.dart';
import 'infrastructure/repository/gem_icon_sqlite_repository.dart';
import 'infrastructure/repository/gem_sqlite_repository.dart';
import 'infrastructure/repository/owned_gem_sqlite_repository.dart';
import 'infrastructure/repository/setting_sqlite_repository.dart';
import 'presentation/pages/gem_create.dart';
import 'presentation/pages/gem_list.dart';
import 'presentation/pages/gem_update.dart';
import 'presentation/pages/home.dart';
import 'presentation/pages/settings.dart';
import 'presentation/pages/statistics.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  App({super.key});

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(child: MultiRepositoryProvider(
      providers: _repositoryProviders,
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AppCubit>(
            create: (context) => AppCubit(
              settingRepository: context.read<SettingRepository>(),
            ),
          ),
          BlocProvider<GemListCubit>(
            create: (context) => GemListCubit(
              gemIconRepository: context.read<GemIconRepository>(),
              gemRepository: context.read<GemRepository>(),
              updateGemOrderUseCase: UpdateGemOrderUseCase(
                gemRepository: context.read<GemRepository>(),
              ),
              archiveGemUseCase: ArchiveGemUseCase(
                gemRepository: context.read<GemRepository>(),
              ),
              deleteGemUseCase: DeleteGemUseCase(
                gemRepository: context.read<GemRepository>(),
                ownedGemRepository: context.read<OwnedGemRepository>(),
              ),
            ),
          ),
          BlocProvider<OwnedGemCubit>(
            create: (context) => OwnedGemCubit(
              gemIconRepository: context.read<GemIconRepository>(),
              gemRepository: context.read<GemRepository>(),
              ownedGemRepository: context.read<OwnedGemRepository>(),
              createGemUseCase: CreateOwnedGemUseCase(
                repository: context.read<OwnedGemRepository>(),
              ),
              deleteGemUseCase: DeleteOwnedGemUseCase(
                repository: context.read<OwnedGemRepository>(),
              ),
            ),
          ),
        ],
        child: BlocBuilder<AppCubit, AppState>(
          builder: (context, state) => MaterialApp.router(
            title: 'Habit Gems',
            routerConfig: _router,
            theme: state.theme,
          ),
        ),
      ),
    ));
  }

  List<RepositoryProvider> get _repositoryProviders {
    return [
      RepositoryProvider<SettingRepository>(
        create: (context) => SettingSqliteRepository(
          dataProvider: buildSqliteDataProvider<Setting>(
            sqliteDataProviderConfig,
            sqliteDataProviderMigrations,
          ),
        ),
      ),
      RepositoryProvider<GemIconRepository>(
        create: (context) => GemIconSqliteRepository(
          dataProvider: buildSqliteDataProvider<GemIcon>(
            sqliteDataProviderConfig,
            sqliteDataProviderMigrations,
          ),
        ),
      ),
      RepositoryProvider<GemRepository>(
        create: (context) => GemSqliteRepository(
          dataProvider: buildSqliteDataProvider<Gem>(
            sqliteDataProviderConfig,
            sqliteDataProviderMigrations,
          ),
        ),
      ),
      RepositoryProvider<OwnedGemRepository>(
        create: (context) => OwnedGemSqliteRepository(
          dataProvider: buildSqliteDataProvider<OwnedGem>(
            sqliteDataProviderConfig,
            sqliteDataProviderMigrations,
          ),
          settingRepository: context.read<SettingRepository>(),
        ),
      ),
      RepositoryProvider<StatisticsDayRepository>(
        create: (context) => StatisticsDayRepository(
          gemRepository: context.read<GemRepository>(),
          ownedGemRepository: context.read<OwnedGemRepository>(),
          settingRepository: context.read<SettingRepository>(),
        ),
      ),
    ];
  }

  final _router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return HomePage();
        },
      ),
      GoRoute(
        path: '/statistics',
        builder: (BuildContext context, GoRouterState state) {
          return StatisticsPage();
        },
      ),
      GoRoute(
        path: '/gems',
        builder: (BuildContext context, GoRouterState state) {
          return GemListPage();
        },
      ),
      GoRoute(
        path: '/gems/create',
        builder: (BuildContext context, GoRouterState state) {
          return GemCreatePage();
        },
      ),
      GoRoute(
        path: '/gems/update/:id',
        builder: (BuildContext context, GoRouterState state) {
          final gemId = int.parse(state.params['id']!);
          return BlocProvider<GemFormCubit>(
            create: (context) => GemUpdateCubit(
              gemRepository: context.read<GemRepository>(),
              gemIconRepository: context.read<GemIconRepository>(),
              updateGemUseCase: UpdateGemUseCase(
                gemRepository: context.read<GemRepository>(),
              ),
              gemId: gemId,
            ),
            child: GemUpdatePage(),
          );
        },
      ),
      GoRoute(
        path: '/settings',
        builder: (BuildContext context, GoRouterState state) {
          return SettingsPage();
        },
      ),
    ],
  );
}

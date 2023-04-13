import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:overlay_support/overlay_support.dart';
import '../../bloc/home/home_cubit.dart';
import '../../bloc/owned_gem/owned_gem_cubit.dart';
import '../../domain/repository/gem_icon_repository.dart';
import '../../domain/repository/gem_repository.dart';
import '../../domain/repository/owned_gem_repository.dart';
import '../../domain/repository/setting_repository.dart';
import '../pages/base_page.dart';
import '../widgets/owned_gem_dialog.dart';

class HomePage extends BasePage {
  @override
  String? getPrevious(BuildContext context) {
    return null;
  }

  @override
  Widget getTitle(BuildContext context) {
    return const Text('Home');
  }

  @override
  Widget getBody(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(
        gemIconRepository: context.read<GemIconRepository>(),
        gemRepository: context.read<GemRepository>(),
        ownedGemRepository: context.read<OwnedGemRepository>(),
        settingRepository: context.read<SettingRepository>(),
      ),
      child: BlocListener<OwnedGemCubit, OwnedGemState>(
        listener: (context, state) {
          if (state is OwnedGemSuccess) {
            context.read<HomeCubit>().refresh();
            return;
          }
        },
        child: BlocConsumer<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is HomeInitial || state is HomeLoading && state.gems == null) {
              return Container(child: SpinKitRing(color: Colors.blue));
            }
            if (state.gems != null) {
              return ListView(
                children: _getGemRows(context, state.gems!),
                padding: EdgeInsets.only(bottom: 80),
              );
            }
            if (state is HomeLoadingError) {
              return Container(child: Text('Error'));
            }
            return Container(child: Text('Undefined state'));
          },
          listener: (context, state) {
            if (state is HomeLoadingError) {
              final theme = Theme.of(context);
              showSimpleNotification(
                Text('Failed to load gems'),
                background: theme.colorScheme.error,
              );
              return;
            }
          },
        ),
      ),
    );
  }

  @override
  List<Widget> getActions(BuildContext context) {
    return [];
  }

  @override
  Widget? getButton(context) {
    return FloatingActionButton(
      onPressed: () => _showAddGemDialog(context),
      tooltip: '',
      child: Icon(Icons.add),
    );
  }

  List<Widget> _getGemRows(BuildContext context, Map<int, Map> gems) {
    return gems.values.map((gem) => _gemToGemRow(context, gem)).toList();
  }

  Widget _gemToGemRow(BuildContext context, gem) {
    final theme = Theme.of(context);
    return  ListTile(
        leading: Icon(
          Icons.diamond,
          color: gem['color'],
          size: 30,
        ),
        title: Text(gem['title']),
        trailing: Row(
          children: [
            IconButton(
              icon: Icon(Icons.remove, color: theme.colorScheme.onSurface, size: 22),
              onPressed: () => context.read<OwnedGemCubit>().deleteGem(gem['gemId']),
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  child: CircularProgressIndicator(
                    value: min(1, (gem['goalCompleted'] + gem['count']) * 1.0
                        / max<num>(1, gem['goalCount'])),
                    color: gem['color'],
                    backgroundColor: theme.disabledColor,
                  ),
                  width: 34,
                  height: 34,
                ),
                Text(gem['count'].toString(), textScaleFactor: 1.4),
              ],
            ),
            IconButton(
              icon: Icon(Icons.add, color: theme.colorScheme.onSurface, size: 22),
              onPressed: () => context.read<OwnedGemCubit>().addGem(gem['gemId']),
            ),
          ],
          mainAxisSize: MainAxisSize.min,
        ),
        contentPadding: EdgeInsets.only(left: 20),
      );
  }

  Future<void> _showAddGemDialog(BuildContext context) async {
    final int? gemId = await showDialog(
      context: context,
      builder: (context) => OwnedGemDialog(),
    );
    if (gemId != null) {
      await context.read<OwnedGemCubit>().addGem(gemId);
    }
  }
}

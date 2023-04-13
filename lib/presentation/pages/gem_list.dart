import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:overlay_support/overlay_support.dart';
import '../../bloc/gem_list/gem_list_cubit.dart';
import '../widgets/gem_list_filter.dart';
import 'base_page.dart';

class GemListPage extends BasePage {
  @override
  String? getPrevious(BuildContext context) {
    return '/';
  }

  @override
  Widget getTitle(BuildContext context) {
    return const Text('Gems');
  }

  @override
  Widget getBody(BuildContext context) {
    return BlocConsumer<GemListCubit, GemListState>(
      builder: (context, state) {
        if (state is GemListInitial || state is GemListLoading && state.gems == null) {
          return Container(child: SpinKitRing(color: Colors.blue));
        }
        if (state is GemListLoadingError) {
          return Container(child: Text('Error'));
        }
        if (state.gems != null) {
          return Container(child: ReorderableListView(
            children: _getGemRows(context, state.gems!),
            padding: EdgeInsets.only(bottom: 80),
            onReorder: (oldIndex, newIndex) {
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }
              context.read<GemListCubit>().updateOrder(oldIndex, newIndex);
            },
          ));
        }
        return Container(child: Text('Undefined state'));
      },
      listener: (context, state) {
        if (state is GemListLoadingError) {
          final theme = Theme.of(context);
          showSimpleNotification(
            Text('Error'),
            background: theme.colorScheme.error,
          );
          return;
        }
      },
    );
  }

  @override
  List<Widget> getActions(BuildContext context) {
    return [GemListFilter()];
  }

  @override
  Widget? getButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => context.go('/gems/create'),
      tooltip: '',
      child: const Icon(Icons.add),
    );
  }

  List<Widget> _getGemRows(BuildContext context, List<Map<String, dynamic>> gems) {
    return gems.map((gem) => _gemToGemRow(context, gem)).toList();
  }

  Widget _gemToGemRow(BuildContext context, Map<String, dynamic> gem) {
    final theme = Theme.of(context);
    return ListTile(
      key: ValueKey<int>(gem['id']),
      leading: Icon(
        Icons.diamond,
        color: gem['color'],
      ),
      title: Text(gem['title']),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(
              Icons.archive,
              color: gem['isActive'] ? theme.disabledColor : theme.colorScheme.onSurface,
            ),
            onPressed: () {
              context.read<GemListCubit>().archive(gem['id']);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.delete_forever,
              color: theme.colorScheme.onSurface,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Delete gem'),
                  content: Text('Are you sure you want to delete gem '
                      '"${gem['title']}"?'),
                  actions: [
                    ElevatedButton(
                      child: Text('Confirm'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.error,
                      ),
                      onPressed: () {
                        context.read<GemListCubit>().delete(gem['id']);
                        Navigator.of(context).pop();
                      },
                    ),
                    ElevatedButton(
                      child: Text('Cancel'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.secondary,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      onTap: () {
        context.go('/gems/update/' + gem['id'].toString());
      },
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/gem_list/gem_list_cubit.dart';

class GemListFilter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: const Icon(Icons.filter_alt,),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem(
          child: Text('All'),
          onTap: () => context.read<GemListCubit>().filter(GemFilterOption.all),
        ),
        PopupMenuItem(
          child: Text('Active'),
          onTap: () => context.read<GemListCubit>().filter(GemFilterOption.active),
        ),
        PopupMenuItem(
          child: Text('Archived'),
          onTap: () => context.read<GemListCubit>().filter(GemFilterOption.archived),
        ),
      ],
    );
  }
}

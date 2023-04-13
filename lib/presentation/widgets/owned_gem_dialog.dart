
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/owned_gem/owned_gem_cubit.dart';

class OwnedGemDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OwnedGemCubit, OwnedGemState>(
      builder: (context, state) {
        return SimpleDialog(
          title: Text('Add gem'),
          children: _getGemItems(context, state.gems),
        );
      },
    );
  }

  List<SimpleDialogOption> _getGemItems(BuildContext context, gems) {
    final List<SimpleDialogOption> items = [];
    for (final gem in gems ?? []) {
      items.add(
        SimpleDialogOption(
          child: Row(
            children: [
              Icon(Icons.diamond, color: gem['color']),
              Text(gem['title']),
            ],
          ),
          onPressed: () {
            // context.read<OwnedGemCubit>().addGem(gem['id']);
            Navigator.pop(context, gem['id']);
          },
        ),
      );
    }
    return items;
  }
}
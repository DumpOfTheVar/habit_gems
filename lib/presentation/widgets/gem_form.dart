
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../../bloc/gem_form/gem_form_cubit.dart';

class GemForm extends StatelessWidget {
  const GemForm({
    super.key,
    required this.isNew,
    required this.form,
    required this.icons,
  });

  final bool isNew;
  final FormGroup form;
  final List<Map<String, dynamic>> icons;

  @override
  Widget build(BuildContext context) {
    return ReactiveForm(
      formGroup: form,
      child: Padding(
        child: Column(
          children: _getFields(context),
        ),
        padding: EdgeInsets.all(20),
      ),
    );
  }

  List<Widget> _getFields(BuildContext context) {
    final theme = Theme.of(context);
    return [
      ReactiveDropdownField<String>(
        formControlName: 'iconId',
        items: _getIconItems(),
        decoration: InputDecoration(
          labelText: 'Icon',
        ),
        onChanged: (control) => _onFieldChange(context, 'iconId', control.value),
      ),
      ReactiveTextField(
        formControlName: 'title',
        decoration: InputDecoration(
          labelText: 'Title',
          labelStyle: TextStyle(
            color: theme.hintColor,
          ),
        ),
        cursorColor: theme.hintColor,
        onChanged: (control) => _onFieldChange(context, 'title', control.value),
      ),
      ReactiveTextField(
        formControlName: 'trigger',
        decoration: InputDecoration(
          labelText: 'Trigger',
          labelStyle: TextStyle(
            color: theme.hintColor,
          ),
        ),
        cursorColor: theme.hintColor,
        onChanged: (control) => _onFieldChange(context, 'trigger', control.value),
      ),
      ReactiveTextField(
        formControlName: 'description',
        decoration: InputDecoration(
          labelText: 'Description',
          labelStyle: TextStyle(
            color: theme.hintColor,
          ),
        ),
        cursorColor: theme.hintColor,
        onChanged: (control) => _onFieldChange(context, 'description', control.value),
      ),
      ReactiveTextField(
        formControlName: 'goalCount',
        decoration: InputDecoration(
          labelText: 'Goal Count',
          labelStyle: TextStyle(
            color: theme.hintColor,
          ),
        ),
        cursorColor: theme.hintColor,
        onChanged: (control) => _onFieldChange(context, 'goalCount', control.value),
      ),
      ReactiveDropdownField<int>(
        formControlName: 'goalPeriod',
        items: _getGoalPeriodItems(),
        decoration: InputDecoration(
          labelText: 'Goal Period',
        ),
        onChanged: (control) => _onFieldChange(context, 'goalPeriod', control.value),
      ),
      if (!isNew)
        ListTile(
          leading: Text('Is archived', style: TextStyle(color: theme.hintColor)),
          trailing: ReactiveSwitch(
            formControlName: 'isArchived',
            activeColor: Theme.of(context).colorScheme.secondary,
            onChanged: (control) => _onFieldChange(context, 'isArchived', control.value),
          ),
          contentPadding: EdgeInsets.zero,
        ),
      ElevatedButton(
        child: Text(isNew ? 'Create' : 'Update',
          style: TextStyle(color: theme.colorScheme.onSecondary),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
        onPressed: () async {
          await context.read<GemFormCubit>().submit();
          form.controls.forEach((_, control) => control.markAsTouched());
        },
      ),
    ];
  }

  List<DropdownMenuItem<String>> _getIconItems() {
    final List<DropdownMenuItem<String>> items = [];
    for (final icon in icons) {
      items.add(DropdownMenuItem<String>(
        value: icon['id'].toString(),
        child: Row(
          children: [
            Icon(Icons.diamond, color: icon['color']),
            Text(icon['src']),
          ],
        ),
      ));
    }
    return items;
  }

  List<DropdownMenuItem<int>> _getGoalPeriodItems() {
    final periodMap = {
      1: 'Day',
      7: 'Week',
      30: 'Month',
    };
    final List<DropdownMenuItem<int>> items = [];
    for (final key in periodMap.keys) {
      items.add(DropdownMenuItem<int>(
        value: key,
        child: Text(periodMap[key]!),
      ));
    }
    return items;
  }

  void _onFieldChange(BuildContext context, String field, value) {
    context.read<GemFormCubit>().onFieldChange(field, value);
  }
}
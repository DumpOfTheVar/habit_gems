import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:overlay_support/overlay_support.dart';
import '../../bloc/gem_form/gem_form_cubit.dart';
import '../widgets/gem_form.dart';
import 'base_page.dart';

class GemUpdatePage extends BasePage {
  @override
  String? getPrevious(BuildContext context) {
    return '/gems';
  }

  @override
  Widget getTitle(BuildContext context) {
    return BlocBuilder<GemFormCubit, GemFormState>(
        builder: (context, state) {
          if (state.gem == null) {
            return Text('Update gem');
          }
          return Text('Update gem "${state.gem!.title.toString()}"');
        }
    );
  }

  @override
  Widget getBody(BuildContext context) {
    return BlocConsumer<GemFormCubit, GemFormState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: GemForm(
            isNew: false,
            form: state.form,
            icons: state.icons,
          ),
        );
      },
      listener: (context, state) {
        if (state is GemFormSuccess) {
          context.go('/gems');
          return;
        }
        if (state is GemFormError) {
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
    return [

    ];
  }

  @override
  Widget? getButton(BuildContext context) {
    return null;
  }
}
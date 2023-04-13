import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:overlay_support/overlay_support.dart';
import '../../application/use_case/create_gem/create_gem_use_case.dart';
import '../../bloc/gem_form/gem_form_cubit.dart';
import '../../domain/repository/gem_icon_repository.dart';
import '../../domain/repository/gem_repository.dart';
import '../pages/base_page.dart';
import '../widgets/gem_form.dart';

class GemCreatePage extends BasePage {
  @override
  String? getPrevious(BuildContext context) {
    return '/gems';
  }

  @override
  Widget getTitle(BuildContext context) {
    return const Text('New habit');
  }

  @override
  Widget getBody(BuildContext context) {
    return Container(
      child: BlocProvider<GemFormCubit>(
        create: (context) => GemCreateCubit(
          gemRepository: context.read<GemRepository>(),
          gemIconRepository: context.read<GemIconRepository>(),
          createGemUseCase: CreateGemUseCase(
            gemRepository: context.read<GemRepository>(),
          ),
        ),
        child: BlocConsumer<GemFormCubit, GemFormState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: GemForm(
                isNew: true,
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
        ),
      ),
    );
  }

  @override
  List<Widget> getActions(BuildContext context) {
    return [];
  }

  @override
  Widget? getButton(BuildContext context) {
    return null;
  }
}

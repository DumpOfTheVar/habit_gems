part of 'gem_form_cubit.dart';

@immutable
abstract class GemFormState {
  GemFormState({
    required this.icons,
    required this.form,
    this.gem,
  });

  final List<Map<String, dynamic>> icons;
  final FormGroup form;
  final Gem? gem;

  String? get iconId => form.control('iconId').value;
  String? get title => form.control('title').value;
  String? get trigger => form.control('trigger').value;
  String? get description => form.control('description').value;
  int? get goalCount => form.control('goalCount').value;
  int? get goalPeriod => form.control('goalPeriod').value;
  bool get isArchived => form.control('isArchived').value;
}

class GemFormInitial extends GemFormState {
  GemFormInitial({
    icons = const <Map<String, dynamic>>[],
    required form,
  }): super(icons: icons, form: form);
  GemFormInitial.fromState(GemFormState state):
    super(icons: state.icons, form: state.form, gem: state.gem);
}

class GemFormReady extends GemFormState {
  GemFormReady({
    required super.icons,
    required super.form,
    super.gem,
  });
  GemFormReady.fromState(GemFormState state):
    super(icons: state.icons, form: state.form, gem: state.gem);
}

class GemFormInProgress extends GemFormState {
  GemFormInProgress({
    required super.icons,
    required super.form,
    super.gem,
  });
  GemFormInProgress.fromState(GemFormState state):
    super(icons: state.icons, form: state.form, gem: state.gem);
}

class GemFormSuccess extends GemFormState {
  GemFormSuccess({
    required super.icons,
    required super.form,
    super.gem,
  });
  GemFormSuccess.fromState(GemFormState state):
    super(icons: state.icons, form: state.form, gem: state.gem);
}

class GemFormError extends GemFormState {
  GemFormError({
    required super.icons,
    required super.form,
    super.gem,
  });
  GemFormError.fromState(GemFormState state):
    super(icons: state.icons, form: state.form, gem: state.gem);
}

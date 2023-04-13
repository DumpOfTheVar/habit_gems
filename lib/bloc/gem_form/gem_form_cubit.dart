import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../../application/use_case/create_gem/create_gem_use_case.dart';
import '../../application/use_case/create_gem/dto/create_gem_dto.dart';
import '../../application/use_case/update_gem/update_gem_use_case.dart';
import '../../application/use_case/update_gem/dto/update_gem_dto.dart';
import '../../domain/entity/gem.dart';
import '../../domain/repository/gem_icon_repository.dart';
import '../../domain/repository/gem_repository.dart';

part 'gem_form_state.dart';
part 'gem_create_cubit.dart';
part 'gem_update_cubit.dart';

abstract class GemFormCubit extends Cubit<GemFormState> {
  GemFormCubit({
    required this.gemRepository,
    required this.gemIconRepository,
    this.gemId,
  }): super(GemFormInitial(form: _makeForm())) {
    init();
  }

  final GemRepository gemRepository;
  final GemIconRepository gemIconRepository;
  final int? gemId;

  Future<void> init() async {
    // try {
      Gem? gem;
      final List<Map<String, dynamic>> icons = [];
      final rawIcons = await gemIconRepository.getAll();
      for (final icon in rawIcons) {
        icons.add({
          'id': icon.id,
          'color': icon.getColor(),
          'src': icon.title,
        });
      }
      final form = state.form;
      if (gemId != null) {
        gem = await gemRepository.getById(gemId!);
        if (gem == null) {
          throw Exception('Gem with id $gemId was not found.');
        }
        form.value = {
          'iconId': gem.iconId.toString(),
          'title': gem.title,
          'trigger': gem.trigger,
          'description': gem.description,
          'goalCount': gem.goalCount,
          'goalPeriod': gem.goalPeriod.days,
          'isArchived': !gem.isActive,
        };
      }
      emit(GemFormReady(icons: icons, form: form, gem: gem));
    // } catch (e) {
    //   emit(GemFormError.fromState(state));
    // }
  }

  Future<void> submit() async {
    // try {
      if (state.form.valid) {
        emit(GemFormInProgress.fromState(state));
        await onSubmit();
        emit(GemFormSuccess.fromState(state));
      } else {
        emit(GemFormError.fromState(state));
      }
    // } catch (e) {
    //   emit(GemFormError.fromState(state));
    // }
  }

  void onFieldChange(String field, value) {
    final form = state.form;
    form.control(field).value = value;
    emit(GemFormReady(icons: state.icons, form: form, gem: state.gem));
  }

  Future<void> onSubmit();

  static FormGroup _makeForm() {
    return FormGroup({
      'iconId': FormControl<String>(validators: [Validators.required]),
      'title': FormControl<String>(validators: [Validators.required]),
      'trigger': FormControl<String>(),
      'description': FormControl<String>(),
      'goalCount': FormControl<int>(),
      'goalPeriod': FormControl<int>(),
      'isArchived': FormControl<bool>(),
    });
  }
}

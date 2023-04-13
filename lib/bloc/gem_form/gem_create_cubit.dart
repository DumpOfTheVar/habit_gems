part of 'gem_form_cubit.dart';

class GemCreateCubit extends GemFormCubit {
  GemCreateCubit({
    required super.gemRepository,
    required super.gemIconRepository,
    required this.createGemUseCase,
  });

  final CreateGemUseCase createGemUseCase;

  @override
  Future<void> onSubmit() async {
    final dto = CreateGemDto(
      iconId: int.parse(state.iconId!),
      title: state.title ?? '',
      trigger: state.trigger ?? '',
      description: state.description ?? '',
      goalCount: state.goalCount ?? 0,
      goalPeriod: state.goalPeriod ?? 1,
    );
    try {
      await createGemUseCase.execute(dto);
      emit(GemFormSuccess.fromState(state));
    } catch (e) {
      emit(GemFormError.fromState(state));
    }
  }
}

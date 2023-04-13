part of 'gem_form_cubit.dart';

class GemUpdateCubit extends GemFormCubit {
  GemUpdateCubit({
    required super.gemRepository,
    required super.gemIconRepository,
    required this.updateGemUseCase,
    required super.gemId,
  });

  final UpdateGemUseCase updateGemUseCase;

  @override
  Future<void> onSubmit() async {
    final dto = UpdateGemDto(
      id: gemId!,
      iconId: int.parse(state.iconId!),
      title: state.title ?? '',
      trigger: state.trigger ?? '',
      description: state.description ?? '',
      goalCount: state.goalCount ?? 0,
      goalPeriod: state.goalPeriod ?? 1,
      isActive: !state.isArchived,
    );
    await updateGemUseCase.execute(dto);
  }
}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../services/mock_api.dart';

/// PromptBloc: controls prompt generation flow and navigation state.
/// - Events: `GeneratePrompt` (user requested generation), `PopResult` (go back to prompt).
/// - States: `PromptInitial`, `PromptLoading`, `PromptResult`, `PromptError`.
/// - This bloc expects a service that returns `Future<String>` (image path). The repo's `MockApi.generate` satisfies this contract.

abstract class PromptEvent extends Equatable {
  const PromptEvent();
  @override
  List<Object?> get props => [];
}

class GeneratePrompt extends PromptEvent {
  final String prompt;
  const GeneratePrompt(this.prompt);
  @override
  List<Object?> get props => [prompt];
}

class PopResult extends PromptEvent {}

abstract class PromptState extends Equatable {
  const PromptState();
  @override
  List<Object?> get props => [];
}

class PromptInitial extends PromptState {}

class PromptLoading extends PromptState {}

class PromptResult extends PromptState {
  final String prompt;
  final String imagePath;

  const PromptResult(this.prompt, this.imagePath);

  @override
  List<Object?> get props => [prompt, imagePath];
}

class PromptError extends PromptState {
  final String message;
  final String prompt;
  const PromptError(this.message, [this.prompt = '']);

  @override
  List<Object?> get props => [message, prompt];
}

class PromptBloc extends Bloc<PromptEvent, PromptState> {
  PromptBloc() : super(PromptInitial()) {
    on<GeneratePrompt>(_onGenerate);
    on<PopResult>(_onPop);
  }

  void _onGenerate(GeneratePrompt event, Emitter<PromptState> emit) async {
    emit(PromptLoading());
    try {
      final imagePath = await MockApi.generate(event.prompt);
      emit(PromptResult(event.prompt, imagePath));
    } catch (e) {
      final message = e.toString();
      emit(PromptError(message, event.prompt));
    }
  }

  void _onPop(PopResult event, Emitter<PromptState> emit) {
    emit(PromptInitial());
  }
}

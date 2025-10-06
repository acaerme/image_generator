import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

// Events
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

// States
abstract class PromptState extends Equatable {
  const PromptState();
  @override
  List<Object?> get props => [];
}

class PromptInitial extends PromptState {}

class PromptLoading extends PromptState {}

class PromptResult extends PromptState {
  final String prompt;
  const PromptResult(this.prompt);
  @override
  List<Object?> get props => [prompt];
}

// Bloc
class PromptBloc extends Bloc<PromptEvent, PromptState> {
  PromptBloc() : super(PromptInitial()) {
    on<GeneratePrompt>(_onGenerate);
    on<PopResult>(_onPop);
  }

  void _onGenerate(GeneratePrompt event, Emitter<PromptState> emit) async {
    // Simple synchronous flow for now. Replace with async generation if needed.
    emit(PromptLoading());
    // simulate a short delay to show loading state in UI (non-blocking)
    await Future.delayed(const Duration(milliseconds: 250));
    emit(PromptResult(event.prompt));
  }

  void _onPop(PopResult event, Emitter<PromptState> emit) {
    emit(PromptInitial());
  }
}

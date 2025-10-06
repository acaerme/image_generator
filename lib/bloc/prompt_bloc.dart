import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../services/mock_api.dart';

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
  final String imagePath;

  const PromptResult(this.prompt, this.imagePath);

  @override
  List<Object?> get props => [prompt, imagePath];
}

// Bloc
class PromptBloc extends Bloc<PromptEvent, PromptState> {
  PromptBloc() : super(PromptInitial()) {
    on<GeneratePrompt>(_onGenerate);
    on<PopResult>(_onPop);
  }

  void _onGenerate(GeneratePrompt event, Emitter<PromptState> emit) async {
    // Start loading and call the Mock API to generate an image.
    emit(PromptLoading());
    try {
      final imagePath = await MockApi.generate(event.prompt);
      emit(PromptResult(event.prompt, imagePath));
    } catch (e) {
      // For this simple mock, fall back to initial state on error.
      emit(PromptInitial());
    }
  }

  void _onPop(PopResult event, Emitter<PromptState> emit) {
    emit(PromptInitial());
  }
}

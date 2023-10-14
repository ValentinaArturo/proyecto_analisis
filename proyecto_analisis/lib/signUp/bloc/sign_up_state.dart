import 'package:proyecto_analisis/common/bloc/base_state.dart';
import 'package:proyecto_analisis/common/models/success_response.dart';
import 'package:proyecto_analisis/signUp/model/genre_response.dart';
import 'package:proyecto_analisis/signUp/model/question.dart';
import 'package:proyecto_analisis/signUp/model/question_response.dart';

abstract class SignUpState extends BaseState {
  const SignUpState();
}

class SignUpInitial extends SignUpState {}

class SignUpInProgress extends SignUpState {}

class SignUpSuccess extends SignUpState {
  final SuccessResponse successResponse;

  const SignUpSuccess({
    required this.successResponse,
  });
}

class SignUpError extends SignUpState {
  final String? error;

  const SignUpError(
    this.error,
  );
}

class GenreSuccess extends SignUpState {
  final GenreResponse genreResponse;

  const GenreSuccess({
    required this.genreResponse,
  });
}

class QuestionsSuccess extends SignUpState {
  final Questions question;

  QuestionsSuccess(
    this.question,
  );
}

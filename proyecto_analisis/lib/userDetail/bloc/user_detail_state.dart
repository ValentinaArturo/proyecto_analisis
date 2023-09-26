import 'package:proyecto_analisis/common/bloc/base_state.dart';
import 'package:proyecto_analisis/common/models/success_response.dart';
import 'package:proyecto_analisis/signUp/model/genre_response.dart';
import 'package:proyecto_analisis/signUp/model/question.dart';

abstract class UserDetailState extends BaseState {
  const UserDetailState();
}

class UserDetailInitial extends UserDetailState {}

class UserDetailInProgress extends UserDetailState {}

class UserDetailSuccess extends UserDetailState {
  final SuccessResponse successResponse;

  const UserDetailSuccess({
    required this.successResponse,
  });
}

class UserDetailError extends UserDetailState {
  final String? error;

  const UserDetailError(
    this.error,
  );
}

class GenreSuccess extends UserDetailState {
  final GenreResponse genreResponse;

  const GenreSuccess({
    required this.genreResponse,
  });
}

class QuestionsSuccess extends UserDetailState {
  final QuestionRepsonse question;

  QuestionsSuccess(
    this.question,
  );
}

part of 'user_detail_bloc.dart';

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
class BranchSuccess extends UserDetailState {
  final BranchResponse branchResponse;

  BranchSuccess({
    required this.branchResponse,
  });
}

class StatusSuccess extends UserDetailState {
  final StatusResponse statusResponse;

  StatusSuccess({
    required this.statusResponse,
  });
}
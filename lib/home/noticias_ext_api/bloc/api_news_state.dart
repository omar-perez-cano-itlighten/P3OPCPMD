part of 'api_news_bloc.dart';

abstract class ApiNewsState extends Equatable {
  const ApiNewsState();

  @override
  List<Object> get props => [];
}

class ApiNewsInit extends ApiNewsState {}

class LoadingState extends ApiNewsState {}

class LoadNewsState extends ApiNewsState {
  final List<NewAdapter> noticiasList;

  LoadNewsState({@required this.noticiasList});
  @override
  List<Object> get props => [noticiasList];
}

class LoadSavedNewsState extends ApiNewsState {
  final List<NewAdapter> noticiasList;

  LoadSavedNewsState({@required this.noticiasList});
  @override
  List<Object> get props => [noticiasList];
}

class ErrorState extends ApiNewsState {
  final String errorMsg;

  ErrorState({@required this.errorMsg});
  @override
  List<Object> get props => [errorMsg];
}

part of 'api_news_bloc.dart';

abstract class ApiNewsEvent extends Equatable {
  const ApiNewsEvent();

  @override
  List<Object> get props => [];
}

class GetApiNewsEvent extends ApiNewsEvent {
  final String query;

  GetApiNewsEvent({@required this.query});
  @override
  List<Object> get props => [query];
}

class SaveNewsEvent extends ApiNewsEvent {
  final NewAdapter article;

  SaveNewsEvent({@required this.article});
  @override
  List<Object> get props => [article];
}

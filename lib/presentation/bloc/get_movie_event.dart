import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class GetMovieEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetMovieByIdEvent extends GetMovieEvent {
  final int id;

  GetMovieByIdEvent(this.id);

  @override
  List<Object> get props => [id];
}

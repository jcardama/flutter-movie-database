import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class WatchListMoviesEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetWatchListMoviesEvent extends WatchListMoviesEvent {}

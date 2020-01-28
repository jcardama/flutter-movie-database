import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:moviedatabase/core/error/failure.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class EmptyParams extends Equatable {
  @override
  List<Object> get props => [];
}

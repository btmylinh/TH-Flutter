import 'package:equatable/equatable.dart';
import '../../../domain/entities/review_entity.dart';

abstract class ReviewState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ReviewInitial extends ReviewState {}

class ReviewLoading extends ReviewState {}

class ReviewLoaded extends ReviewState {
  final List<ReviewEntity> reviews;

  ReviewLoaded({required this.reviews});

  @override
  List<Object?> get props => [reviews];
}

class ReviewError extends ReviewState {
  final String message;

  ReviewError({required this.message});

  @override
  List<Object?> get props => [message];
}

class ReviewAddSuccess extends ReviewState {}

class ReviewAdding extends ReviewState {}

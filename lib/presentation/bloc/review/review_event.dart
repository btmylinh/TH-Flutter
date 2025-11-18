import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class ReviewEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadReviews extends ReviewEvent {
  final String restaurantId;

  LoadReviews({required this.restaurantId});

  @override
  List<Object?> get props => [restaurantId];
}

class AddReviewEvent extends ReviewEvent {
  final String restaurantId;
  final double rating;
  final String comment;
  final List<File> images;

  AddReviewEvent({
    required this.restaurantId,
    required this.rating,
    required this.comment,
    required this.images,
  });

  @override
  List<Object?> get props => [restaurantId, rating, comment, images];
}

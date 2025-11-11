import 'dart:io';
import 'package:equatable/equatable.dart';
import '../../domain/entities/review.dart';

abstract class ReviewEvent extends Equatable {
  const ReviewEvent();

  @override
  List<Object> get props => [];
}

class GetReviewsEvent extends ReviewEvent {
  final String restaurantId;

  const GetReviewsEvent(this.restaurantId);

  @override
  List<Object> get props => [restaurantId];
}

class AddReviewEvent extends ReviewEvent {
  final Review review;
  final List<File> images;

  const AddReviewEvent(this.review, this.images);

  @override
  List<Object> get props => [review, images];
}

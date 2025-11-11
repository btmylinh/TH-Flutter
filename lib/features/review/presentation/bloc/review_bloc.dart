import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/add_review.dart';
import '../../domain/usecases/get_reviews.dart';
import '../../domain/usecases/upload_image.dart';
import 'review_event.dart';
import 'review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final AddReview addReview;
  final GetReviews getReviews;
  final UploadImage uploadImage;

  ReviewBloc({
    required this.addReview,
    required this.getReviews,
    required this.uploadImage,
  }) : super(ReviewInitial()) {
    on<GetReviewsEvent>(_onGetReviews);
    on<AddReviewEvent>(_onAddReview);
  }

  Future<void> _onGetReviews(
      GetReviewsEvent event, Emitter<ReviewState> emit) async {
    emit(ReviewLoading());
    final result = await getReviews(event.restaurantId);
    result.fold(
      (failure) => emit(ReviewError(failure.message)),
      (reviews) => emit(ReviewsLoaded(reviews)),
    );
  }

  Future<void> _onAddReview(
      AddReviewEvent event, Emitter<ReviewState> emit) async {
    emit(ReviewLoading());
    final result = await addReview(AddReviewParams(
      review: event.review,
      images: event.images,
    ));
    result.fold(
      (failure) => emit(ReviewError(failure.message)),
      (_) => emit(ReviewAdded()),
    );
  }
}

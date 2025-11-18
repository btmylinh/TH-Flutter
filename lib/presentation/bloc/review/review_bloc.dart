import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_reviews.dart';
import '../../../domain/usecases/add_review.dart';
import 'review_event.dart';
import 'review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final GetReviews getReviews;
  final AddReview addReview;
  StreamSubscription? _reviewSubscription;

  ReviewBloc({required this.getReviews, required this.addReview})
    : super(ReviewInitial()) {
    on<LoadReviews>(_onLoadReviews);
    on<AddReviewEvent>(_onAddReview);
  }

  Future<void> _onLoadReviews(
    LoadReviews event,
    Emitter<ReviewState> emit,
  ) async {
    print('📡 [ReviewBloc] LoadReviews cho restaurantId=${event.restaurantId}');
    emit(ReviewLoading());
    await _reviewSubscription?.cancel();

    await emit.forEach(
      getReviews(GetReviewsParams(restaurantId: event.restaurantId)),
      onData: (result) {
        print('📡 [ReviewBloc] Nhận stream reviews...');
        return result.fold(
          (failure) {
            print(
              '❌ [ReviewBloc] Lỗi khi lấy reviews: ${failure.message}',
            );
            return ReviewError(message: failure.message);
          },
          (reviews) {
            print(
              '✅ [ReviewBloc] Nhận được ${reviews.length} review(s)',
            );
            return ReviewLoaded(reviews: reviews);
          },
        );
      },
    );
  }

  Future<void> _onAddReview(
    AddReviewEvent event,
    Emitter<ReviewState> emit,
  ) async {
    emit(ReviewAdding());
    final result = await addReview(
      AddReviewParams(
        restaurantId: event.restaurantId,
        rating: event.rating,
        comment: event.comment,
        images: event.images,
      ),
    );
    if (!emit.isDone) {
      result.fold(
        (failure) => emit(ReviewError(message: failure.message)),
        (_) => emit(ReviewAddSuccess()),
      );
    }
  }

  @override
  Future<void> close() {
    _reviewSubscription?.cancel();
    return super.close();
  }
}

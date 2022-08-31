import 'package:Challet/blocs/review/review_event.dart';
import 'package:Challet/blocs/review/review_state.dart';
import 'package:Challet/models/review_model.dart';
import 'package:Challet/repositories/review_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final ReviewRepository reviewRepository;
  ReviewBloc({required this.reviewRepository}) : super(ReviewStateInitial());

  List<ReviewModel> _reviewList = [];
  bool _displayShowMoreReviewsButton = false;

  ReviewState get initialState => ReviewStateInitial();

  @override
  void onTransition(Transition<ReviewEvent, ReviewState> transition) {
    super.onTransition(transition);
  }

  @override
  Stream<ReviewState> mapEventToState(ReviewEvent event) async* {
    if (event is GetReviewsEvent) {
      yield* _hanleGetReviewsEvent(event);
    }
    if (event is GetMoreReviewsForChalet) {
      yield* _hanleGetMoreReviewsEvent(event);
    }
    if (event is ResetReviewBloc) {
      yield* _hanleResetReviewBlocEvent(event);
    }
  }

  Stream<ReviewState> _hanleGetReviewsEvent(GetReviewsEvent event) async* {
    yield ReviewStateLoading();
    try {
      _reviewList = await reviewRepository.getReviewsForChalet(event.chaletId);
      _displayShowMoreReviewsButton = _reviewList.length == 5;
      if (_reviewList.isEmpty)
        yield ReviewStateLoadedEmpty(displayShowMoreReviewsButton: _displayShowMoreReviewsButton);
      else
        yield ReviewStateLoaded(reviewList: _reviewList, displayShowMoreReviewsButton: _displayShowMoreReviewsButton);
    } catch (e) {
      yield ReviewStateError(e.toString());
    }
  }

  Stream<ReviewState> _hanleGetMoreReviewsEvent(GetMoreReviewsForChalet event) async* {
    yield MoreReviewStateLoading();
    try {
      List<ReviewModel> newReviews = await reviewRepository.getMoreReviewsForChalet(event.chaletId, event.lastReview);
      _displayShowMoreReviewsButton = newReviews.length == 5;
      yield MoreReviewStateLoaded(reviewList: newReviews, displayShowMoreReviewsButton: _displayShowMoreReviewsButton);
    } catch (e) {
      yield ReviewStateError(e.toString());
    }
  }

  Stream<ReviewState> _hanleResetReviewBlocEvent(ResetReviewBloc event) async* {
    yield ReviewStateInitial();
  }
}

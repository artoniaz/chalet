import 'package:chalet/blocs/add_review/add_review_event.dart';
import 'package:chalet/blocs/add_review/add_review_state.dart';
import 'package:chalet/config/functions/timestamp_methods.dart';
import 'package:chalet/models/review_model.dart';
import 'package:chalet/repositories/review_repository.dart';
import 'package:chalet/services/review_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class AddReviewBloc extends Bloc<AddReviewEvent, AddReviewState> {
  final ReviewRepository reviewRepository;
  AddReviewBloc({required this.reviewRepository}) : super(AddReviewStateInitial());

  String _currentReviewId = '';
  double _chaletRating = 0.0;

  AddReviewState get initialState => AddReviewStateInitial();

  @override
  void onTransition(Transition<AddReviewEvent, AddReviewState> transition) {
    super.onTransition(transition);
  }

  @override
  Stream<AddReviewState> mapEventToState(AddReviewEvent event) async* {
    if (event is GetLastUserReviewForChalet) {
      yield* _handleGetLastUserReviewForChalet(event);
    }
    if (event is CreateQuickReview) {
      yield* _handleCreateQuickReview(event);
    }
    if (event is GoToFullReviewDialog) {
      yield AddReviewStateFullRatingDialog(_currentReviewId, _chaletRating);
    }
    if (event is AddDetailsReviewToQuickReview) {
      yield* _handleAddDetailsReviewToQuickReview(event);
    }
  }

  Stream<AddReviewState> _handleGetLastUserReviewForChalet(GetLastUserReviewForChalet event) async* {
    yield AddReviewValidateRatingsLoading();
    try {
      List<ReviewModel> _reviewList = await reviewRepository.getLastUserReviewForChalet(event.chaletId, event.userId);
      if (_reviewList.isEmpty) {
        yield AddReviewStateQuickRating();
      } else {
        ReviewModel _review = _reviewList.first;
        _chaletRating = _review.rating;
        _currentReviewId = _review.id;
        int _daysSinceLastReview = calcDaysBetween(_review.created);
        if (_daysSinceLastReview > 0) {
          yield AddReviewStateQuickRating();
        } else if (_daysSinceLastReview <= 0 && !_review.hasUserAddedFullReview) {
          yield AddReviewStateQuickRatingConfirm(chaletRating: _review.rating);
        } else {
          yield AddReviewStateQuickRatingNotAllowed(chaletRating: _review.rating);
        }
      }
    } catch (e) {
      yield AddReviewStateError('Nie udało się dodać oceny.');
    }
  }

  Stream<AddReviewState> _handleCreateQuickReview(CreateQuickReview event) async* {
    yield AddReviewStateRequestLoading();
    try {
      final review = event.review;
      if (review.rating > 0 && review.description.length > 0) {
        String reviewId = await ReviewService().createQuickReview(review);
        _currentReviewId = reviewId;
        _chaletRating = event.review.rating;
        yield AddReviewStateFullRatingDialog(_currentReviewId, _chaletRating);
      }
    } catch (e) {
      yield AddReviewStateError('Nie udało się dodać oceny.');
    }
  }

  Stream<AddReviewState> _handleAddDetailsReviewToQuickReview(AddDetailsReviewToQuickReview event) async* {
    yield AddReviewStateRequestLoading();
    try {
      await ReviewService().addDetailsReviewToQuickReview(event.chaletId, event.reviewId, event.reviewDetails);
      EasyLoading.showSuccess('Dodano ocenę szaletu');
      yield AddReviewStateClear();
    } catch (e) {
      yield AddReviewStateError('Nie udało się dodać oceny.');
    }
  }
}

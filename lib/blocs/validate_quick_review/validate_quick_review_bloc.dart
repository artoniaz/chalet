import 'package:chalet/blocs/add_review/add_review_bloc.dart';
import 'package:chalet/blocs/add_review/add_review_event.dart';
import 'package:chalet/blocs/validate_quick_review/validate_quick_review_event.dart';
import 'package:chalet/blocs/validate_quick_review/validate_quick_review_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ValidateQuickReviewBloc extends Bloc<ValidateQuickReviewEvent, ValidateQuickReviewState> {
  final AddReviewBloc addReviewBloc;
  ValidateQuickReviewBloc({
    required this.addReviewBloc,
  }) : super(ValidateQuickReviewStateInitial());

  ValidateQuickReviewState get initialState => ValidateQuickReviewStateInitial();

  @override
  void onTransition(Transition<ValidateQuickReviewEvent, ValidateQuickReviewState> transition) {
    super.onTransition(transition);
  }

  @override
  Stream<ValidateQuickReviewState> mapEventToState(ValidateQuickReviewEvent event) async* {
    if (event is ValidateQuickReview) {
      yield* _handleQuickReviewValidation(event);
    }
    if (event is ResetQuickReview) {
      yield* _handleResetValidation(event);
    }
  }

  Stream<ValidateQuickReviewState> _handleQuickReviewValidation(ValidateQuickReview event) async* {
    yield ValidateQuickReviewStateValidating();
    if (event.describtion == '' || event.rating == 0.0) {
      yield ValidateQuickReviewStateInvalid();
    } else {
      yield ValidateQuickReviewStateValid();
      addReviewBloc.add(CreateQuickReview(review: event.review, feedInfo: event.feedInfo));
    }
  }

  Stream<ValidateQuickReviewState> _handleResetValidation(ResetQuickReview event) async* {
    yield ValidateQuickReviewStateInitial();
  }
}

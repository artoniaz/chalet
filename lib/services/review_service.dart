import 'package:chalet/models/review_details_model.dart';
import 'package:chalet/models/review_model.dart';
import 'package:chalet/repositories/review_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewService implements ReviewRepository {
  final CollectionReference reviewsCollection = FirebaseFirestore.instance.collection('reviews');

  @override
  Future<List<ReviewModel>> getReviewsForChalet(String chaletId) async {
    try {
      final data = await reviewsCollection
          .doc('$chaletId')
          .collection('chalet_reviews')
          .orderBy('created', descending: true)
          .limit(5)
          .get();
      return data.docs.map((doc) => ReviewModel.fromJson(doc.data(), doc.id)).toList();
    } catch (e) {
      print(e);
      throw 'Błąd pobierania ocen szaletu';
    }
  }

  @override
  Future<List<ReviewModel>> getMoreReviewsForChalet(String chaletId, ReviewModel lastReview) async {
    try {
      final data = await reviewsCollection
          .doc('$chaletId')
          .collection('chalet_reviews')
          .orderBy('created', descending: true)
          .startAfter([lastReview.created])
          .limit(5)
          .get();
      return data.docs.map((doc) => ReviewModel.fromJson(doc.data(), doc.id)).toList();
    } catch (e) {
      print(e);
      throw 'Błąd pobierania ocen szaletu';
    }
  }

  Future<String> createQuickReview(ReviewModel review) async {
    try {
      DocumentReference<Object?> res =
          await reviewsCollection.doc('${review.chaletId}').collection('chalet_reviews').add(ReviewModel(
                id: '',
                userId: review.userId,
                chaletId: review.chaletId,
                userName: review.userName,
                rating: review.rating,
                description: review.description,
                created: review.created,
                hasUserAddedFullReview: review.hasUserAddedFullReview,
                reviewDetails: review.reviewDetails,
              ).toJson());
      return res.id;
    } catch (e) {
      print(e);
      throw 'Błąd dodawania oceny szaletu.';
    }
  }

  Future<List<ReviewModel>> getLastUserReviewForChalet(String chaletId, String userId) async {
    try {
      final data = await reviewsCollection
          .doc(chaletId)
          .collection('chalet_reviews')
          .where('userId', isEqualTo: userId)
          .orderBy('created', descending: true)
          .limit(1)
          .get();
      if (data.docs.isNotEmpty) {
        return [data.docs.map((doc) => ReviewModel.fromJson(doc.data(), doc.id)).toList().first];
      } else
        return [];
    } catch (e) {
      print(e);
      throw 'Wystąpił błąd dodawania oceny.';
    }
  }

  Future<void> addDetailsReviewToQuickReview(String chaletId, String reviewId, ReviewDetailsModel reviewDetails) async {
    try {
      reviewsCollection.doc('$chaletId').collection('chalet_reviews').doc(reviewId).update({
        'hasUserAddedFullReview': true,
        'reviewDetails': reviewDetails.toJson(),
      });
    } catch (e) {
      print(e);
      throw 'Błąd zapisu szczegółow oceny.';
    }
  }
}

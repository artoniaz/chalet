const functions = require("firebase-functions");
const admin = require('firebase-admin');
admin.initializeApp();

// auth trigger (new user signup)
exports.newUserSignup = functions.auth.user().onCreate(user => {
    return admin.firestore().collection('users').doc(user.uid).set({
        uid: user.uid,
        email: user.email,
        displayName: user.displayName,
        photoURL: user.photoURL,
    });
});

exports.updateChaletRatingOnReviewCreate = functions.firestore.document('/reviews/{chaletId}/chalet_reviews/{reviewId}')
    .onCreate((snapshot, context) => {
        const chaletId = snapshot.data().chaletId;
        const chaletDocRef = admin.firestore().collection('chalets').doc(chaletId);

        chaletDocRef.get().then(chalet => {
            const newNumberRatings = chalet.data().numberRating + 1;
            const oldRatingTotal = parseInt(chalet.data().rating) * parseInt(chalet.data().numberRating);
            const newAvgRating = (oldRatingTotal + parseInt(snapshot.data().rating)) / newNumberRatings;

            return chaletDocRef.update({
                rating: newAvgRating,
                numberRating: newNumberRatings
            });
        });
    });

exports.updateChaletRatingOnReviewUpdate = functions.firestore.document('/reviews/{chaletId}/chalet_reviews/{reviewId}')
    .onUpdate((change, context) => {
        const chaletId = change.after.data().chaletId;
        const chaletDocRef = admin.firestore().collection('chalets').doc(chaletId);

        chaletDocRef.get().then(chalet => {
            const newNumberDetailedRatings = chalet.data().numberDetailedRating + 1;

            const oldPaperRatingTotal = chalet.data().paper * chalet.data().numberDetailedRating;
            const newAvgPaperRating = (oldPaperRatingTotal + parseInt(change.after.data().reviewDetails.paper)) / newNumberDetailedRatings;

            const oldCleanRatingTotal = chalet.data().clean * chalet.data().numberDetailedRating;
            const newAvgCleanRating = (oldCleanRatingTotal + parseInt(change.after.data().reviewDetails.clean)) / newNumberDetailedRatings;

            const oldPrivacyRatingTotal = chalet.data().privacy * chalet.data().numberDetailedRating;
            const newAvgPrivacyRating = (oldPrivacyRatingTotal + parseInt(change.after.data().reviewDetails.privacy)) / newNumberDetailedRatings;


            return chaletDocRef.update({
                paper: newAvgPaperRating,
                clean: newAvgCleanRating,
                privacy: newAvgPrivacyRating,
                numberDetailedRating: newNumberDetailedRatings
            });
        });
    });
const functions = require("firebase-functions");
const admin = require('firebase-admin');
const { Storage } = require('@google-cloud/storage');

admin.initializeApp();

// auth trigger (new user signup)
// correct function, currently not used in the project
// exports.newUserSignup = functions.auth.user().onCreate(user => {
//     return admin.firestore().collection('users').doc(user.uid).set({
//         uid: user.uid,
//         email: user.email,
//         displayName: user.displayName,
//         photoURL: user.photoURL,
//     });
// });

// correct function, currently not used in the project
// exports.deleteUserDataOnDelete = functions.auth.user().onDelete((user) => {
//     const userDocRef = admin.firestore().collection('users').doc(userId);
//     return userDocRef.delete();
// });

exports.updateChaletRatingOnReviewCreate = functions.firestore.document('/reviews/{chaletId}/chalet_reviews/{reviewId}')
    .onCreate((snapshot, context) => {
        const chaletId = snapshot.data().chaletId;
        const userId = snapshot.data().userId;
        const chaletDocRef = admin.firestore().collection('chalets').doc(chaletId);
        const userDocRef = admin.firestore().collection('users').doc(userId);

        chaletDocRef.get().then(chalet => {
            const newNumberRatings = chalet.data().numberRating + 1;
            const oldRatingTotal = parseInt(chalet.data().rating) * parseInt(chalet.data().numberRating);
            const newAvgRating = (oldRatingTotal + parseInt(snapshot.data().rating)) / newNumberRatings;

            return chaletDocRef.update({
                rating: newAvgRating,
                numberRating: newNumberRatings
            });
        });

        userDocRef.get().then(user => {
            const chaletsReviewsCreatedByUser = user.data().chaletReviewsNumber;

            const sittingKingAchievementName = 'sittingKing';
            const userAchievementsCompleted = user.data().achievementsIds;
            const newNumberReviewsAdded = chaletsReviewsCreatedByUser + 1;
            if (newNumberReviewsAdded > 4 && userAchievementsCompleted.indexOf(sittingKingAchievementName) == -1) {
                userAchievementsCompleted.push(sittingKingAchievementName);
                return userDocRef.update({
                    chaletReviewsNumber: newNumberReviewsAdded,
                    achievementsIds: userAchievementsCompleted,
                });
            } else {
                return userDocRef.update({
                    chaletReviewsNumber: newNumberReviewsAdded,
                });
            }
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

exports.updateUserDataOnChaletCreated = functions.firestore.document('/chalets/{chaletId}')
    .onCreate((snapshot, context) => {
        const userId = snapshot.data().creatorId;
        const userDocRef = admin.firestore().collection('users').doc(userId);

        userDocRef.get().then(user => {
            const newChaletsAddedNumber = user.data().chaletsAddedNumber + 1;
            const achievementName = 'traveller';
            const userAchievementsCompleted = user.data().achievementsIds;

            if (newChaletsAddedNumber > 9 && userAchievementsCompleted.indexOf(achievementName) == -1) {
                userAchievementsCompleted.push(achievementName);
                return userDocRef.update({
                    chaletsAddedNumber: newChaletsAddedNumber,
                    achievementsIds: userAchievementsCompleted,
                });
            } else {
                return userDocRef.update({
                    chaletsAddedNumber: newChaletsAddedNumber,
                });
            }
        });
    });
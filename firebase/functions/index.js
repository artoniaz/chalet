const functions = require("firebase-functions");
const admin = require('firebase-admin');
admin.initializeApp();

// auth trigger (new user signup)

exports.newUserSignup = functions.auth.user().onCreate(user => {
    console.log('user created', user.email, user.uid);
    return admin.firestore().collection('users').doc(user.uid).set({
        email: user.email,
        favouriteChaletIds: []
    });
});
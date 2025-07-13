const admin = require("firebase-admin");
admin.initializeApp();

// Imports
exports.likes = require("./Notifications/onLike_notif");
exports.comments = require("./Notifications/onComment_notif");
exports.offers = require("./Notifications/onOffering_notif");
exports.follows = require("./Notifications/onFollow_notif");
exports.messages = require("./Notifications/onMessaging");
exports.usertypesValidation = require("./Notifications/onUsertypeValidation");

const { onDocumentUpdated } = require("firebase-functions/firestore");
const admin = require("./firebaseAdmin");

exports.onUserTypeValidation = onDocumentUpdated("Users/{userId}", async (event) => {
  const before = event.data.before.data();
  const after = event.data.after.data();

  const userId = event.params.userId;

  const beforeUserTypes = before.userType || {};
  const afterUserTypes = after.userType || {};

  // Go through each type in the after update
  for (const type in afterUserTypes) {
    const beforeValidation = beforeUserTypes?.[type]?.validation;
    const afterValidation = afterUserTypes?.[type]?.validation;

    // Check if validation just became true
    if (beforeValidation !== true && afterValidation === true) {
      console.log(`Validation activated for ${type} of user ${userId}`);

      try {
        const userSnap = await admin.firestore().collection("Users").doc(userId).get();
        const userData = userSnap.data();
        const token = userData?.fcmToken;

        if (!token) {
          console.log("No FCM token found");
          return;
        }

        // Send FCM notification
        await admin.messaging().send({
          token,
          notification: {
            title: "User Type Approved ✅",
            body: `Your request to become a ${type} has been approved!`,
          },
        });

        // Store in Firestore
        await admin.firestore()
          .collection("Notifications")
          .doc(userId)
          .collection("items")
          .add({
            type: "userType_verified",
            userType: type,
            timestamp: admin.firestore.FieldValue.serverTimestamp(),
            read: false,
          });

        console.log(`Notification sent for ${type}`);

      } catch (error) {
        console.error("Notification error:", error);
      }
    }
  }
});

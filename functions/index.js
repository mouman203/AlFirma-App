const { onDocumentUpdated } = require("firebase-functions/firestore");
const admin = require("firebase-admin");

admin.initializeApp();

exports.onUserUpdate = onDocumentUpdated("Users/{userId}", async (event) => {
  const before = event.data.before.data();
  const after = event.data.after.data();

  const oldFollowers = before.followers || [];
  const newFollowers = after.followers || [];

  const addedFollowers = newFollowers.filter((id) => !oldFollowers.includes(id));

  console.log("Before followers:", oldFollowers);
  console.log("After followers:", newFollowers);

  if (addedFollowers.length === 0) {
    console.log("No new followers");
    return;
  }

  const newFollowerId = addedFollowers[0];

  try {
    const followerSnap = await admin.firestore().collection("Users").doc(newFollowerId).get();
    const followerData = followerSnap.data();

    if (!followerData) {
      console.log(`No data found for follower ID: ${newFollowerId}`);
      return;
    }

    const followerName = followerData.first_name || "Someone";

    const followedSnap = await admin.firestore().collection("Users").doc(event.params.userId).get();
    const followedData = followedSnap.data();

    if (!followedData) {
      console.log(`No data found for followed user ID: ${event.params.userId}`);
      return;
    }

    const userToken = followedData.fcmToken;

    if (!userToken) {
      console.log("No FCM token found for followed user.");
      return;
    }

    console.log("Sending notification to token:", userToken);

    await admin.messaging().send({
  token: userToken,
  notification: {
    title: "New Follower 🎉",
    body: `${followerName} just followed you!`,
  },
});


    console.log("Notification sent successfully");

     await admin.firestore()
  .collection('Notifications')
  .doc(event.params.userId)
  .collection('items')
  .add({
    type: 'follow',
    fromUserId: newFollowerId,
    fromUserName: followerName,
    timestamp: admin.firestore.FieldValue.serverTimestamp(),
    read: false,
  });

console.log("Notification document created in Firestore");

  } catch (error) {
    console.error("Error sending follower notification:", error);
  }
});

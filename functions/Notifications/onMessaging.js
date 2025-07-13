const { onDocumentCreated } = require("firebase-functions/firestore");
const admin = require("./firebaseAdmin");

// Trigger for new vet messages
exports.onVetMessageCreated = onDocumentCreated("Vet Messages/{docId}", async (event) => {
  const messageData = event.data.data();

  if (!messageData) {
    console.log("No message data found.");
    return;
  }

  const { senderId, receiverId, content } = messageData;

  if (!senderId || !receiverId || !content) {
    console.log("Missing sender, receiver, or content.");
    return;
  }

  try {
    const senderSnap = await admin.firestore().collection("Users").doc(senderId).get();
    const senderData = senderSnap.data();

    const receiverSnap = await admin.firestore().collection("Users").doc(receiverId).get();
    const receiverData = receiverSnap.data();

    if (!senderData || !receiverData) {
      console.log("Sender or receiver data not found.");
      return;
    }

    const receiverToken = receiverData.fcmToken;

    if (!receiverToken) {
      console.log("No FCM token found for receiver.");
      return;
    }

    const senderName = senderData.first_name || "Someone";

    await admin.messaging().send({
      token: receiverToken,
      notification: {
        title: `New Message`,
        body: `${senderName} : `+content.length > 50 ? content.substring(0, 47) + "..." : content,
      },
      data: {
        type: "message",
        senderId: senderId,
      },
    });

    console.log("Message notification sent to", receiverId);

    // Optional: Log it in Firestore under Notifications
    await admin.firestore()
      .collection("Notifications")
      .doc(receiverId)
      .collection("items")
      .add({
        type: "message",
        fromUserId: senderId,
        fromUserName: senderName,
        content: content,
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
        read: false,
      });

  } catch (error) {
    console.error("Error sending message notification:", error);

    if (error.code === 'messaging/registration-token-not-registered') {
      await admin.firestore().collection('Users').doc(receiverId).update({
        fcmToken: admin.firestore.FieldValue.delete(),
      });
      console.warn('Invalid FCM token removed from Firestore.');
    }
  }
});

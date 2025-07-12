const { onDocumentWritten } = require("firebase-functions/firestore");
const admin = require("./firebaseAdmin");

//  One trigger for all offer logic
exports.onOfferWritten = onDocumentWritten("offers/{docId}", async (event) => {
  const before = event.data.before.exists ? event.data.before.data() : null;
  const after = event.data.after.exists ? event.data.after.data() : null;

  if (!after) return; // deleted

  const senderId = after.senderId;
  const receiverId = after.receiverId;
  const content = after.content;

  if (!senderId || !receiverId || senderId === receiverId) return;

  // ================== New Offer or Updated Offer ==================
  const isNewOffer = !before;
  const isUpdatedOffer =
    before &&
    before.senderId === after.senderId &&
    before.content !== after.content &&
    !after.accepted && !after.refused;

  if (isNewOffer || isUpdatedOffer) {
    // Fetch sender name
    const senderSnap = await admin.firestore().collection("Users").doc(senderId).get();
    const senderData = senderSnap.data();
    const senderName = senderData?.first_name || "Someone";

    // Fetch receiver token
    const receiverSnap = await admin.firestore().collection("Users").doc(receiverId).get();
    const receiverData = receiverSnap.data();
    const token = receiverData?.fcmToken;
    if (token) {
      await admin.messaging().send({
        token,
        notification: {
          title: "New Offer 📦",
          body: `${senderName} sent you an offer: "${content}"`,
        },
      });

      await admin.firestore()
        .collection("Notifications")
        .doc(receiverId)
        .collection("items")
        .add({
          type: "offer",
          fromUserId: senderId,
          fromUserName: senderName,
          targetType: "offer",
          targetId: event.params.docId,
          content: content,
          timestamp: admin.firestore.FieldValue.serverTimestamp(),
          read: false,
        });
    }
  }

  // ================== Accepted or Refused ==================
  const wasAccepted = before && !before.accepted && after.accepted === true;
  const wasRefused = before && !before.refused && after.refused === true;

  if (wasAccepted || wasRefused) {
    const senderSnap = await admin.firestore().collection("Users").doc(senderId).get();
    const senderData = senderSnap.data();
    const token = senderData?.fcmToken;

    const receiverSnap = await admin.firestore().collection("Users").doc(receiverId).get();
    const receiverData = receiverSnap.data();
    const receiverName = receiverData?.first_name || "the user";

    let message = "";
    let type = "";

    if (wasAccepted) {
      message = `${receiverName} accepted your offer: "${content}"`;
      type = "offer_accepted";
    } else if (wasRefused) {
      message = `${receiverName} refused your offer: "${content}"`;
      type = "offer_refused";
    }

    if (token) {
      await admin.messaging().send({
        token,
        notification: {
          title: "Offer Update 📩",
          body: message,
        },
      });

      await admin.firestore()
        .collection("Notifications")
        .doc(senderId)
        .collection("items")
        .add({
          type,
          toUserId: receiverId,
          toUserName: receiverName,
          targetType: "offer",
          targetId: event.params.docId,
          content: content,
          timestamp: admin.firestore.FieldValue.serverTimestamp(),
          read: false,
        });
    }
  }
});

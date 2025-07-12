const { onDocumentUpdated } = require("firebase-functions/firestore");
const admin = require("./firebaseAdmin");


// 🔹 Trigger for Product Likes
exports.onProductLikeUpdate = onDocumentUpdated("item/Products/Products/{docId}", async (event) => {
  await handleLikeNotification(event, "product");
});

// 🔹 Trigger for Service Likes
exports.onServiceLikeUpdate = onDocumentUpdated("item/Services/Services/{docId}", async (event) => {
  await handleLikeNotification(event, "service");
});

// 🔁 Shared Like Notification Logic
async function handleLikeNotification(event, type) {
  const beforeLikes = event.data.before.data().liked || [];
  const afterLikes = event.data.after.data().liked || [];

  const newLikes = afterLikes.filter((id) => !beforeLikes.includes(id));
  if (newLikes.length === 0) return;

  const likerId = newLikes[0];
  const postData = event.data.after.data();
  const ownerId = postData.ownerId;

  if (!ownerId || likerId === ownerId) return;

  const likerSnap = await admin.firestore().collection("Users").doc(likerId).get();
  const likerData = likerSnap.data();
  const likerName = likerData?.first_name || "Someone";

  const ownerSnap = await admin.firestore().collection("Users").doc(ownerId).get();
  const ownerData = ownerSnap.data();
  const token = ownerData?.fcmToken;
  if (!token) return;

  await admin.messaging().send({
    token,
    notification: {
      title: "New Like ❤️",
      body: `${likerName} liked your ${type}.`,
    },
  });

  await admin.firestore()
    .collection("Notifications")
    .doc(ownerId)
    .collection("items")
    .add({
      type: "like",
      fromUserId: likerId,
      fromUserName: likerName,
      targetType: type,
      targetId: event.params.docId,
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
      read: false,
    });
}

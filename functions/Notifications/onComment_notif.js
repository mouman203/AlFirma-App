const { onDocumentUpdated } = require("firebase-functions/firestore");
const admin = require("./firebaseAdmin");

// 🔹 Trigger for Product Comments
exports.onProductCommentUpdate = onDocumentUpdated("item/Products/Products/{docId}", async (event) => {
  await handleCommentNotification(event, "product");
});

// 🔹 Trigger for Service Comments
exports.onServiceCommentUpdate = onDocumentUpdated("item/Services/Services/{docId}", async (event) => {
  await handleCommentNotification(event, "service");
});

// 🔁 Shared Comment Notification Logic
async function handleCommentNotification(event, type) {
  const beforeComments = event.data.before.data().comments || [];
  const afterComments = event.data.after.data().comments || [];

  if (afterComments.length <= beforeComments.length) return;

  const newComment = afterComments[afterComments.length - 1];
  const commenterId = newComment.userId;
  const commentText = newComment.text || "Commented on your post.";

  const postData = event.data.after.data();
  const ownerId = postData.ownerId;

  if (!ownerId || commenterId === ownerId) return;

  // Fetch commenter name
  const commenterSnap = await admin.firestore().collection("Users").doc(commenterId).get();
  const commenterData = commenterSnap.data();
  const commenterName = commenterData?.first_name || "Someone";

  // Fetch owner token
  const ownerSnap = await admin.firestore().collection("Users").doc(ownerId).get();
  const ownerData = ownerSnap.data();
  const token = ownerData?.fcmToken;
  if (!token) return;

  // 🔔 Send push notification
  await admin.messaging().send({
    token,
    notification: {
      title: `New Comment 💬 from ${commenterName}`,
      body: commentText,
    },
  });

  // 📄 Store notification in Firestore
  await admin.firestore()
    .collection("Notifications")
    .doc(ownerId)
    .collection("items")
    .add({
      type: "comment",
      fromUserId: commenterId,
      fromUserName: commenterName,
      commentText: commentText,
      targetType: type,
      targetId: event.params.docId,
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
      read: false,
    });
}

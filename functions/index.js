const { onCall } = require("firebase-functions/v2/https");
const { initializeApp } = require("firebase-admin/app");
const { getMessaging } = require("firebase-admin/messaging");
const { getFirestore } = require("firebase-admin/firestore");

initializeApp();

exports.sendNotification = onCall(
  {
    region: "europe-west1",
    memory: "256MiB",
    timeoutSeconds: 30,
    cpu: 1,
  },
  async (request) => {
    const data = request.data;
    const context = request.auth;

    const { token, title, body, receiverId, receiverName, image } = data;
    const senderId = context?.uid;

    if (!token || !title || !body || !receiverId || !senderId) {
      throw new Error("Missing required fields");
    }

    const ids = [senderId, receiverId].sort();
    const chatRoomId = ids.join("_");

    const db = getFirestore();

    //  Check mute status for both users
    const [receiverMuteDoc, senderMuteDoc] = await Promise.all([
      db.collection("mutedChats").doc(receiverId).get(),
      db.collection("mutedChats").doc(senderId).get(),
    ]);

    const isReceiverMuted = receiverMuteDoc.exists && receiverMuteDoc.data()?.[chatRoomId] === true;
    const isSenderMuted = senderMuteDoc.exists && senderMuteDoc.data()?.[chatRoomId] === true;

    if (isReceiverMuted || isSenderMuted) {
      console.log(`🔕 Chat is muted by one or both users for ${chatRoomId}. Skipping notification.`);
      return { success: false, muted: true };
    }

    const message = {
      token,
      notification: { title, body },
      data: {
        receiverId: receiverId,
        receiverName: receiverName || "",
        image: image || "",
        click_action: "FLUTTER_NOTIFICATION_CLICK",
        type: "chat",
        chatRoomId,
      },
      android: {
        notification: { sound: "default" },
      },
      apns: {
        payload: {
          aps: { sound: "default" },
        },
      },
    };

    try {
      const response = await getMessaging().send(message);
      console.log("✅ Notification sent:", response);
      return { success: true };
    } catch (error) {
      console.error("❌ Error sending notification:", error);
      throw new Error("Failed to send notification");
    }
  }
);

const { onCall } = require("firebase-functions/v2/https");
const { initializeApp } = require("firebase-admin/app");
const { getMessaging } = require("firebase-admin/messaging");

initializeApp();

exports.sendNotification = onCall(
  {
    region: "europe-west1", // or "us-central1"
    memory: "256MiB",
    timeoutSeconds: 30,
    cpu: 1, // ✅ Now allowed in Gen 2
  },
  async (request) => {
    const data = request.data;
    console.log("Function called with data:", data);

    const { token, title, body, receiverId, receiverName, image } = data;

    if (!token || !title || !body) {
      throw new Error("Missing fields: token, title, or body");
    }

    const message = {
      token,
      notification: { title, body },
      data: {
        receiverId: receiverId || "",
        receiverName: receiverName || "",
        image: image || "",
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

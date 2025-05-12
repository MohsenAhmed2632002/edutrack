const admin = require("firebase-admin");
const fs = require("fs");

const serviceAccount = require("./serviceAccountKey.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

async function deleteSubcollection(parentRef, subcollectionName) {
  const snapshot = await parentRef.collection(subcollectionName).get();
  for (const doc of snapshot.docs) {
    await doc.ref.delete();
  }
}

async function deleteLectures() {
  const classRef = db.collection("classes").doc("first_year");
  const daysSnapshot = await classRef.collection("days").get();

  for (const dayDoc of daysSnapshot.docs) {
    await deleteSubcollection(dayDoc.ref, "lectures");
    await dayDoc.ref.delete();
  }

  console.log("🗑️ تم حذف جميع المحاضرات");
}

async function deleteSections() {
  const classRef = db.collection("classes").doc("first_year");
  const sectionsSnapshot = await classRef.collection("sections").get();

  for (const sectionDoc of sectionsSnapshot.docs) {
    await deleteSubcollection(sectionDoc.ref, "entries");
    await sectionDoc.ref.delete();
  }

  console.log("🗑️ تم حذف جميع السكاشن");
}

async function run() {
  await deleteLectures();
  await deleteSections();
  console.log("✅ تم الحذف بالكامل");
}

run();

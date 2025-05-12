const admin = require("firebase-admin");
const XLSX = require("xlsx");
const fs = require("fs");

// تحميل المفتاح
const serviceAccount = require("./serviceAccountKey.json");

// تهيئة Firebase
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

// دالة لقراءة ملف Excel وتحويله إلى JSON
function excelToJson(filePath) {
  const workbook = XLSX.readFile(filePath);
  const sheetName = workbook.SheetNames[0];
  const worksheet = workbook.Sheets[sheetName];
  return XLSX.utils.sheet_to_json(worksheet);
}

// تحميل البيانات من ملفات Excel للفرقة الرابعة فقط
const lecturesFourthYearTeacher = excelToJson("محاضرات الفرقة الرابعة - معلم.xlsx");
const lecturesFourthYearSpecialist = excelToJson("محاضرات الفرقة الرابعة - أخصائي.xlsx");

// دالة لتنظيم البيانات حسب الأيام
function organizeByDay(data) {
  const daysMap = {};

  data.forEach(row => {
    const day = row["اليوم"];
    if (!daysMap[day]) {
      daysMap[day] = [];
    }

    // إزالة عمود اليوم من البيانات
    const { اليوم, ...rest } = row;
    daysMap[day].push(rest);
  });

  return Object.keys(daysMap).map(day => ({
    day,
    lectures: daysMap[day]
  }));
}

// دالة رفع المحاضرات
async function uploadLectures(data, yearLabel) {
  const organizedData = organizeByDay(data);
  const baseRef = db.collection("محاضرات").doc(yearLabel).collection("الأيام");

  for (const day of organizedData) {
    const dayRef = baseRef.doc(day.day);
    await dayRef.set({ day: day.day });
    
    const batch = db.batch();
    day.lectures.forEach(lecture => {
      const newRef = dayRef.collection("محاضرات").doc();
      batch.set(newRef, lecture);
    });
    await batch.commit();
  }

  console.log(`✅ تم رفع محاضرات ${yearLabel}`);
}

// تشغيل كل شيء للفرقة الرابعة فقط
async function run() {
  try {
    // رفع محاضرات للفرقة الرابعة فقط
    await uploadLectures(lecturesFourthYearTeacher, "الفرقة الرابعة - معلم");
    await uploadLectures(lecturesFourthYearSpecialist, "الفرقة الرابعة - أخصائي");

    console.log("🚀 تم رفع جميع المحاضرات للفرقة الرابعة بنجاح!");
  } catch (error) {
    console.error("❌ حدث خطأ أثناء رفع المحاضرات:", error);
  } finally {
    process.exit(0);
  }
}

run();

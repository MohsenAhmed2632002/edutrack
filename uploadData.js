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

// تحميل البيانات من ملفات Excel
const sectionsFirstYear = excelToJson("سكاشن الفرقة الأولى.xlsx");
const lecturesFirstYear = excelToJson("محاضرات الفرقة الأولى.xlsx");

const sectionsSecondYear = excelToJson("سكاشن الفرقة الثانية.xlsx");
const lecturesSecondYear = excelToJson("محاضرات الفرقة الثانية.xlsx");

const sectionsThirdYearSpecialist = excelToJson("محاضرات الفرقة الثالثة - معلم.xlsx");
const lecturesThirdYearSpecialist = excelToJson("محاضرات الفرقة الثالثة - أخصائي.xlsx");


const sectionsFourthYearTeacher = excelToJson("سكاشن الفرقة الرابعة - معلم.xlsx");
const sectionsThirdYearTeacher = excelToJson("سكاشن الفرقة الرابعة - أخصائي.xlsx");



const sectionsFourthYearSpecialist = excelToJson("محاضرات الفرقة الرابعة - أخصائي.xlsx");
const lecturesThirdYearTeacher = excelToJson("محاضرات الفرقة الرابعة - معلم.xlsx");

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

// دالة رفع محاضرات
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

// دالة رفع السكاشن
async function uploadSections(data, yearLabel) {
  const organizedData = organizeByDay(data);
  const baseRef = db.collection("سكاشن").doc(yearLabel).collection("الأيام");

  for (const day of organizedData) {
    const dayRef = baseRef.doc(day.day);
    await dayRef.set({ day: day.day });
    
    const batch = db.batch();
    day.lectures.forEach(section => {
      const newRef = dayRef.collection("سكاشن").doc();
      batch.set(newRef, section);
    });
    await batch.commit();
  }

  console.log(`✅ تم رفع سكاشن ${yearLabel}`);
}

// تشغيل كل شيء
async function run() {
  try {
    // رفع محاضرات
    await uploadLectures(lecturesFirstYear, "الفرقة الأولى");
    await uploadLectures(lecturesSecondYear, "الفرقة الثانية");
    await uploadLectures(lecturesThirdYearSpecialist, "الفرقة الثالثة - أخصائي");
    await uploadLectures(lecturesThirdYearTeacher, "الفرقة الثالثة - معلم");

    // رفع سكاشن
    await uploadSections(sectionsFirstYear, "الفرقة الأولى");
    await uploadSections(sectionsSecondYear, "الفرقة الثانية");
    await uploadSections(sectionsThirdYearSpecialist, "الفرقة الثالثة - أخصائي");
    await uploadSections(sectionsThirdYearTeacher, "الفرقة الثالثة - معلم");
    await uploadSections(sectionsFourthYearSpecialist, "الفرقة الرابعة - أخصائي");
    await uploadSections(sectionsFourthYearTeacher, "الفرقة الرابعة - معلم");

    console.log("🚀 تم رفع جميع البيانات بنجاح!");
  } catch (error) {
    console.error("❌ حدث خطأ أثناء رفع البيانات:", error);
  } finally {
    process.exit(0);
  }
}

run();
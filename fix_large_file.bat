@echo off
echo ====== إزالة الملف الكبير من تاريخ Git ======

:: تأكد أنك داخل مجلد المشروع
cd /d %~dp0

:: حذف الملف من التاريخ باستخدام git-filter-repo
git filter-repo --path "assets/table/edu track guideline.pdf" --invert-paths

:: حذف remote القديم لو موجود
git remote remove origin

:: إضافة remote من جديد (غير الرابط حسب ما تحتاج)
git remote add origin https://github.com/MohsenAhmed2632002/EduTrack2.git

:: رفع المشروع مع إجبار إعادة كتابة التاريخ
git push --force origin main

echo.
echo ✅ تمت إزالة الملف الكبير ورفع المشروع إلى GitHub بنجاح!
pause

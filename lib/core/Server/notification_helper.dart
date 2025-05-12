// static Future<void> showTomorrowNotifications(BuildContext context) async {
//   final pending = await _notificationsPlugin.pendingNotificationRequests();
//   final tomorrowDay = getTomorrowDay();

//   final tomorrowNotifications = pending.where((n) {
//     if (n.payload == null) return false;
//     try {
//       final payload = jsonDecode(n.payload!);
//       return payload['day'] == tomorrowDay;
//     } catch (e) {
//       print('خطأ في فك التشفير: ${e.toString()}');
//       return false;
//     }
//   }).toList();

//   final lectures = tomorrowNotifications.where((n) {
//     final payload = jsonDecode(n.payload!);
//     return payload['type'] == 'محاضرة';
//   }).toList();

//   final sections = tomorrowNotifications.where((n) {
//     final payload = jsonDecode(n.payload!);
//     return payload['type'] == 'سكشن';
//   }).toList();

//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
//     ),
//     builder: (_) => Container(
//       padding: const EdgeInsets.all(20),
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
//       ),
//       child: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Center(
//               child: Text(
//                 'إشعارات غدًا ($tomorrowDay)',
//                 style: const TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.blue,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),

//             // المحاضرات
//             if (lectures.isNotEmpty) ...[
//               const Text('📘 المحاضرات:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//               const SizedBox(height: 10),
//               ...lectures.map((n) {
//                 final payload = jsonDecode(n.payload!);
//                 return ListTile(
//                   leading: const Icon(Icons.school, color: Colors.green),
//                   title: Text(payload['subject'] ?? 'بدون عنوان'),
//                   subtitle: Text('الوقت: ${payload['time']} \nالمكان: ${payload['location']} \nالدكتور: ${payload['doctor']}'),
//                 );
//               }),
//               const Divider(),
//             ],

//             // السكاشن
//             if (sections.isNotEmpty) ...[
//               const Text('📗 السكاشن:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//               const SizedBox(height: 10),
//               ...sections.map((n) {
//                 final payload = jsonDecode(n.payload!);
//                 return ListTile(
//                   leading: const Icon(Icons.group, color: Colors.orange),
//                   title: Text(payload['subject'] ?? 'بدون عنوان'),
//                   subtitle: Text('الوقت: ${payload['time']} \nالمكان: ${payload['location']} \nالدكتور: ${payload['doctor']}'),
//                 );
//               }),
//             ],

//             if (lectures.isEmpty && sections.isEmpty)
//               const Center(
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(vertical: 20),
//                   child: Text('لا توجد إشعارات مجدولة'),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     ),
//   );
// }





// builder: (_) => Container(
//   padding: const EdgeInsets.all(20),
//   decoration: const BoxDecoration(
//     color: Colors.white,
//     borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
//   ),
//   child: SingleChildScrollView(
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Center(
//           child: Text(
//             'إشعارات غدًا ($tomorrowDay)',
//             style: const TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: Colors.blue,
//             ),
//           ),
//         ),
//         const SizedBox(height: 20),

//         // قسم المحاضرات
//         if (lectures.isNotEmpty) ...[
//           const Text('📘 المحاضرات:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 10),
//           ...lectures.map((n) {
//             final payload = jsonDecode(n.payload!);
//             return ListTile(
//               leading: const Icon(Icons.school, color: Colors.green),
//               title: Text(payload['subject'] ?? 'بدون عنوان'),
//               subtitle: Text('الوقت: ${payload['time']} \nالمكان: ${payload['location']} \nالدكتور: ${payload['doctor']}'),
//             );
//           }),
//           const Divider(),
//         ],

//         // قسم السكاشن
//         if (sections.isNotEmpty) ...[
//           const Text('📗 السكاشن:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 10),
//           ...sections.map((n) {
//             final payload = jsonDecode(n.payload!);
//             return ListTile(
//               leading: const Icon(Icons.group, color: Colors.orange),
//               title: Text(payload['subject'] ?? 'بدون عنوان'),
//               subtitle: Text('الوقت: ${payload['time']} \nالمكان: ${payload['location']} \nالدكتور: ${payload['doctor']}'),
//             );
//           }),
//         ],

//         if (lectures.isEmpty && sections.isEmpty)
//           const Center(
//             child: Padding(
//               padding: EdgeInsets.symmetric(vertical: 20),
//               child: Text('لا توجد إشعارات مجدولة'),
//             ),
//           ),
//       ],
//     ),
//   ),
// ),




// قال ChatGPT:
// لأنك تستخدم جهاز ويندوز، فلا يمكنك بناء نسخة iOS (release ipa) مباشرة منه، لأن نظام iOS يتطلب macOS بسبب:

// أدوات Apple مثل xcodebuild لا تعمل إلا على macOS.

// لا يمكن الوصول إلى محاكي iOS ولا إنشاء ملفات .ipa بدون Xcode.

// ✅ ما يمكنك فعله لإصدار نسخة iOS:
// 1. استخدام جهاز Mac حقيقي أو افتراضي (macOS)
// هذه الطريقة الرسمية والأكثر استقرارًا.

// قم بتثبيت:

// Xcode

// Flutter

// ثم شغل الأمر:

// bash
// نسخ
// تحرير
// flutter build ipa --release
// 2. البديل (Cloud Build): استخدام خدمات بناء iOS في السحابة
// مثل:
// الخدمة	ملاحظات
// Codemagic	مجاني حتى حد معين، سهل الدمج مع GitHub
// FlutterFlow	واجهة رسومية، لكنها محدودة في التخصيص
// Appollo	منصة عربية جديدة تسهل نشر التطبيقات
// Bitrise	احترافي أكثر للمشاريع الكبيرة

// تقوم بربط مشروعك من GitHub أو GitLab أو رفع الكود، وتضبط إعدادات التوقيع (Signing) ويتم بناء ملف .ipa الجاهز للنشر أو التثبيت.

// 3. استئجار Mac على الإنترنت (macOS Cloud)
// مثل MacStadium أو MacInCloud

// توفر جهاز Mac تعمل عليه عن بعد وتبني منه iOS apps.

// 🛠 إذا أردت نشر التطبيق على App Store:
// ستحتاج إلى:

// حساب Apple Developer (99$/سنة)

// إعداد التوقيع (Provisioning Profile, Certificates)

// Xcode أو خدمة سحابية تدعم ذلك

// هل تريد أن أساعدك خطوة بخطوة في استخدام Codemagic أو MacInCloud مثلًا؟







// PS C:\Users\sphinx_Mohsen\StudioProjects\edutrack> flutter build apk --release    
// لدي لاب ويندوز و اريد ان اصدر
// release    للايفون ماذا افعل؟
// حسناً، المستخدم لديه جهاز لاب توب يعمل بنظام ويندوز ويريد إصدار تطبيق Flutter لنظام iOS (Release). المشكلة هنا أنه لا يمكن بناء تطبيقات iOS على ويندوز مباشرةً لأن أدوات تطوير iOS مثل Xcode متوفرة فقط على أجهزة macOS. لذا، يحتاج المستخدم إلى طريقة للتعامل مع هذا القيد.

// أولاً، يجب أن أتأكد من أن المستخدم يدرك أن بناء تطبيق iOS يتطلب بيئة macOS. ربما هو يعرف ذلك لكنه يبحث عن حلول بديلة. الحلول المتاحة تشمل استخدام خدمات CI/CD مثل Codemagic أو GitHub Actions، أو استخدام جهاز Mac فعلي سواء كان خاصاً به أو عن طريق الاستئجار مثل MacStadium أو استخدام خدمة Mac في السحابة.

// ثم، أحتاج إلى توضيح الخطوات لكل خيار. على سبيل المثال، إذا اختار استخدام جهاز Mac فعلي، سأشرح كيفية إعداد البيئة على Mac وتكوين Xcode وإعداد الشهادات والتوقيعات. إذا اختار خدمة CI/CD، سأشرح كيفية ربط المشروع مع الخدمة وتكوين ملفات الضرورية مثل workflow files.

// أيضاً، يجب أن أذكر أدوات مثل Flutter للبناء عن بعد أو استخدام أدوات مثل VMware أو Hackintosh، لكن مع تحذيره من أن هذه الحلول قد تكون معقدة أو تنتهك شروط Apple.

// ربما المستخدم قد حاول تشغيل أمر flutter build apk على ويندوز، لكنه يريد الآن بناءً لـ iOS، لذا يجب أن أوضح الفرق بين بناء Android وiOS في Flutter.

// أخيراً، التأكيد على أهمية التوقيعات والشهادات في iOS والتي تختلف عن Android، وضرورة إعدادها بشكل صحيح حتى يعمل التطبيق على الأجهزة الفعلية.

// بناء تطبيقات iOS يتطلب نظام تشغيل macOS بسبب متطلبات أدوات تطوير Apple (Xcode). إليك الحلول الممكنة إذا كنت تستخدم جهاز ويندوز:

// 1. استخدام جهاز Mac فعلي (أفضل حل)
// الخيار الأفضل للبناء النهائي (Release) وتوقيع التطبيق.

// الخطوات:

// جهز مشروع Flutter على جهاز Mac (نفس الكود).

// افتح المشروع في Xcode.

// إعداد التوقيع التلقائي (Signing & Capabilities).

// تنفيذ الأمر:

// bash
// flutter build ipa --release
// الحصول على ملف .ipa جاهز للنشر على App Store.

// 2. استخدام خدمات CI/CD السحابية (بدون ماك)
// مثال: Codemagic, GitHub Actions, Bitrise

// كيف تعمل؟ رفع الكود إلى GitHub، والخدمة تبني التطبيق على سيرفرات macOS سحابية.

// خطوات استخدام Codemagic:

// إنشاء حساب على Codemagic.

// ربط مستودع GitHub/Bitbucket.

// تكوين إعدادات التوقيع (Code Signing).

// تشغيل البناء وإدارة الإصدارات.

// 3. استئجار ماك سحابي (Mac in Cloud)
// مثال: MacStadium أو XcodeClub

// الميزة: الوصول إلى جهاز ماك عن بعد عبر الإنترنت.

// التكلفة: تبدأ من ~20 دولار/شهر.

// 4. حلول بديلة (غير موصى بها)
// VMware/Hackintosh:
// تركيب macOS على ويندوز عبر Virtual Machine (مخالف لشروط Apple وقد يؤدي لمشاكل فنية).

// Flutter للويب:
// إذا كان التطبيق ويب، يمكن استخدام flutter build web.

// ملاحظات هامة:
// توقيع التطبيق (Code Signing):
// ضروري لنشر التطبيق على App Store ويتطلب حساب Apple Developer (99 دولار/سنويًا).

// اختبار على أجهزة iOS:
// حتى مع البناء الناجح، ستحتاج ماك لتثبيت التطبيق على أجهزة Apple فعلية.

// إذا كان التطبيق للاستخدام الشخصي:
// يمكنك استخدام Ad Hoc Distribution لتثبيته على أجهزة محددة.

// خطوة عملية موصى بها:
// استخدم جهاز ماك (صديق/مقهى إنترنت) للبناء الأولي.

// استخدم Codemagic للبناء التلقائي عند التحديثات.

// استثمر في ماك ميني إذا كنت ستنشر تطبيقات iOS بشكل متكرر (~600 دولار).
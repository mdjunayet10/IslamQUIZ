import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppLanguage { english, bangla }

class LanguageService {
  static const String appName = 'IslamQUIZ';
  static const String _key = 'app_language';
  static final ValueNotifier<AppLanguage> current =
      ValueNotifier<AppLanguage>(AppLanguage.english);

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_key);
    current.value = saved == 'bn' ? AppLanguage.bangla : AppLanguage.english;
  }

  static bool get isBangla => current.value == AppLanguage.bangla;

  static Future<void> setLanguage(AppLanguage language) async {
    current.value = language;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, language == AppLanguage.bangla ? 'bn' : 'en');
  }

  static Future<void> toggle() async {
    await setLanguage(isBangla ? AppLanguage.english : AppLanguage.bangla);
  }
}

class AppLanguageScope extends InheritedNotifier<ValueNotifier<AppLanguage>> {
  const AppLanguageScope({
    super.key,
    required super.child,
  }) : super(notifier: LanguageService.current);

  static AppLanguage of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<AppLanguageScope>();
    return scope?.notifier?.value ?? LanguageService.current.value;
  }
}

extension AppLanguageContext on BuildContext {
  bool get isBangla => AppLanguageScope.of(this) == AppLanguage.bangla;

  String t(String english, [String? bangla]) {
    if (english == LanguageService.appName) return LanguageService.appName;
    if (!isBangla) return english;
    return bangla ?? BanglaCopy.text[english] ?? english;
  }

  String referenceText(String text) {
    if (!isBangla) return text;
    final direct = BanglaCopy.text[text];
    if (direct != null) return direct;
    return text.split('\n').map(_referenceLine).join('\n');
  }

  String _referenceLine(String line) {
    final direct = BanglaCopy.text[line];
    if (direct != null) return direct;

    if (line.startsWith('Qur’an ')) {
      return _quotedParts(line.replaceFirst('Qur’an', 'কুরআন'));
    }
    if (line.startsWith('Hadith source:')) {
      return 'হাদীসের সূত্র: ${_lookupText(line.replaceFirst('Hadith source:', '').trim())}';
    }
    if (line.startsWith('Narrator/topic:')) {
      return 'বর্ণনাকারী / বিষয়: ${_quotedParts(t(line.replaceFirst('Narrator/topic:', '').trim()))}';
    }
    if (line.startsWith('Scholar statement:')) {
      return 'আলেমের বক্তব্য: ${_quotedParts(t(line.replaceFirst('Scholar statement:', '').trim()))}';
    }
    if (line.startsWith('Source:')) {
      return 'সূত্র: ${_quotedParts(t(line.replaceFirst('Source:', '').trim()))}';
    }
    if (line.startsWith('Quoted translation:')) {
      return 'উদ্ধৃত অনুবাদ: ${_quotedParts(line.replaceFirst('Quoted translation:', '').trim())}';
    }
    if (line.startsWith(
        'Quoted English rendering used in ${LanguageService.appName}:')) {
      return 'উদ্ধৃত অনুবাদ: ${_quotedParts(line.substring(line.indexOf(':') + 1).trim())}';
    }
    if (line.startsWith('Quoted text:')) {
      return 'উদ্ধৃত বক্তব্য: ${_quotedParts(line.replaceFirst('Quoted text:', '').trim())}';
    }
    if (line.startsWith('Arabic wording:')) {
      return 'আরবি শব্দ: ${line.replaceFirst('Arabic wording:', '').trim()}';
    }

    return _quotedParts(line);
  }

  String _lookupText(String text) {
    return _referenceTerms(_quotedParts(text))
        .replaceAll('— Sunnah.com lookup:', '— Sunnah.com লুকআপ:')
        .replaceAll('— lookup:', '— লুকআপ:');
  }

  String _quotedParts(String text) {
    final direct = BanglaCopy.text[text];
    if (direct != null) return direct;

    final matches = RegExp('“[^”]+”').allMatches(text).toList().reversed;
    var translated = text;
    for (final match in matches) {
      final quote = match.group(0)!;
      final bangla = BanglaCopy.text[quote];
      if (bangla != null) {
        translated = translated.replaceRange(match.start, match.end, bangla);
      }
    }
    return _referenceTerms(translated);
  }

  String _referenceTerms(String text) {
    return text
        .replaceAll('Qur’an', 'কুরআন')
        .replaceAll('Hilali and Khan', 'হিলালী ও খান')
        .replaceAll('Saheeh International', 'সহীহ ইন্টারন্যাশনাল')
        .replaceAll('The Clear Quran', 'দ্য ক্লিয়ার কুরআন')
        .replaceAll('Sahih al-Bukhari', 'সহীহ আল-বুখারী')
        .replaceAll('Sahih Muslim', 'সহীহ মুসলিম')
        .replaceAll('Sunan Abi Dawud', 'সুনান আবি দাউদ')
        .replaceAll('Jami‘ at-Tirmidhi', 'জামে আত-তিরমিযী')
        .replaceAll('Abu Dawud', 'আবু দাউদ')
        .replaceAll('Bukhari', 'বুখারী')
        .replaceAll('Muslim', 'মুসলিম')
        .replaceAll('Tirmidhi', 'তিরমিযী');
  }
}

class BanglaCopy {
  static final Map<String, String> text = Map.unmodifiable({
    // App shell and navigation

    'IslamQUIZ teaches foundational aqeedah through short MCQs, simple explanations, and references. The goal is to help users recognize Tawheed, Sunnah, and common belief errors.':
        'IslamQUIZ ছোট MCQ, সহজ ব্যাখ্যা এবং রেফারেন্সের মাধ্যমে মৌলিক আকীদাহ শেখায়। লক্ষ্য হলো ব্যবহারকারীকে তাওহীদ, সুন্নাহ এবং সাধারণ বিশ্বাসগত ভুল চিনতে সাহায্য করা।',
    'Core approach': 'মূল পদ্ধতি',
    'The app is based on the Qur’an, authentic Sunnah, and the understanding of the Salaf. Worship is for Allah alone. Allah’s Names and Attributes are affirmed without changing the meaning, denying, asking how, or comparing Allah to creation.':
        'অ্যাপটি কুরআন, সহীহ সুন্নাহ এবং সালাফদের বোঝার উপর ভিত্তি করে। ইবাদত শুধু আল্লাহর জন্য। আল্লাহর নাম ও গুণাবলি অর্থ বদলানো, অস্বীকার, কীভাবে জিজ্ঞেস করা বা সৃষ্টির সাথে তুলনা করা ছাড়া সাব্যস্ত করা হয়।',
    'Simple language': 'সহজ ভাষা',
    'The questions avoid difficult words where possible. When a topic is serious, the app uses careful wording and short explanations.':
        'প্রশ্নগুলোতে যতটা সম্ভব কঠিন শব্দ এড়ানো হয়েছে। গুরুতর বিষয়ে অ্যাপ সতর্ক ভাষা ও ছোট ব্যাখ্যা ব্যবহার করে।',
    'Careful wording': 'সতর্ক ভাষা',
    'The app explains belief errors firmly but avoids reckless takfir or attacking individuals. It focuses on evidence, clarity, and correction.':
        'অ্যাপটি বিশ্বাসগত ভুল দৃঢ়ভাবে ব্যাখ্যা করে, কিন্তু অবিবেচনাপূর্ণ তাকফীর বা ব্যক্তিগত আক্রমণ এড়ায়। লক্ষ্য প্রমাণ, স্পষ্টতা ও সংশোধন।',
    'Related mistake labels': 'ভুল-সম্পর্কিত লেবেল',
    'When a result shows a mistake or group label, that label is not the correct belief. It only names the error connected to the wrong answers.':
        'ফলাফলে ভুল বা দলের লেবেল দেখা গেলে তা সঠিক বিশ্বাস নয়। এটি শুধু ভুল উত্তরের সাথে যুক্ত ভুলের নাম দেখায়।',
    'Review before publishing': 'প্রকাশের আগে যাচাই',
    'All religious content should be reviewed by qualified people before public release. References should be checked carefully for wording, grading, and context.':
        'প্রকাশের আগে সব ধর্মীয় কনটেন্ট যোগ্য লোকদের দিয়ে যাচাই করা উচিত। রেফারেন্সের শব্দ, হাদীসের মান এবং প্রসঙ্গ ভালোভাবে পরীক্ষা করতে হবে।',
    'Local progress in v1': 'প্রথম ভার্সনে লোকাল প্রগ্রেস',
    'This first version saves progress only on the device. Level, XP, completed quizzes, completed questions, best score, and mistakes are stored locally.':
        'প্রথম ভার্সনে প্রগ্রেস শুধু ডিভাইসে সংরক্ষিত হয়। লেভেল, XP, সম্পন্ন কুইজ, সম্পন্ন প্রশ্ন, সেরা স্কোর এবং ভুলগুলো লোকালভাবে সংরক্ষিত থাকে।',
    'IslamQUIZ': 'IslamQUIZ',
    'Correct aqeedah MCQs with evidence': 'প্রমাণসহ সঠিক আকীদাহ MCQ',
    'About IslamQUIZ': 'IslamQUIZ সম্পর্কে',
    'Methodology and content rules': 'পদ্ধতি ও কনটেন্ট নীতি',
    'Categories': 'বিষয়সমূহ',
    'Choose one topic and begin': 'একটি বিষয় বেছে শুরু করুন',
    'Core Beliefs of Aqeedah': 'আকীদাহর মূল বিশ্বাস',
    'Study the foundations before the quiz': 'কুইজের আগে ভিত্তিগুলো পড়ুন',
    'Review Mistakes': 'ভুল উত্তর রিভিউ',
    'Relearn questions you missed': 'যে প্রশ্নগুলো ভুল হয়েছে সেগুলো আবার শিখুন',
    'Quiz Result': 'কুইজের ফলাফল',
    'Progress saved locally': 'প্রগ্রেস এই ডিভাইসে সংরক্ষিত',
    'Saving progress...': 'প্রগ্রেস সংরক্ষণ হচ্ছে...',
    'Full Quiz': 'পূর্ণ কুইজ',
    'Essential Foundations': 'গুরুত্বপূর্ণ ভিত্তি',
    'Mistake Review': 'ভুল উত্তর রিভিউ',
    'Quiz': 'কুইজ',
    'No questions found.': 'কোনো প্রশ্ন পাওয়া যায়নি।',
    'Question': 'প্রশ্ন',
    'of': 'এর মধ্যে',
    'Question %d of %d': 'প্রশ্ন',
    'Choose the answer that best matches Qur’an, authentic Sunnah, and the understanding of the Salaf.':
        'যে উত্তরটি কুরআন, সহীহ সুন্নাহ এবং সালাফদের বোঝার সাথে সবচেয়ে বেশি মিলে সেটি বেছে নিন।',
    'Core foundation': 'মূল ভিত্তি',
    'Progress': 'প্রগ্রেস',
    'Correct': 'সঠিক',
    'Wrong': 'ভুল',
    'XP ready': 'প্রস্তুত XP',
    'Next Question': 'পরের প্রশ্ন',
    'See Result': 'ফলাফল দেখুন',
    'Restart Quiz': 'আবার শুরু করুন',
    'Back to Home': 'হোমে ফিরুন',
    'Start Essential Foundations': 'গুরুত্বপূর্ণ ভিত্তি শুরু করুন',
    'Start Full Quiz': 'পূর্ণ কুইজ শুরু করুন',
    'Choose Category': 'বিষয় বেছে নিন',
    'About Aqeedah Methodology': 'আকীদাহর পদ্ধতি সম্পর্কে',
    'Start Mistake Review': 'ভুল রিভিউ শুরু করুন',
    'No saved mistakes yet.': 'এখনো কোনো সংরক্ষিত ভুল নেই।',
    'When you answer incorrectly, the question will appear here for revision.':
        'ভুল উত্তর দিলে প্রশ্নটি এখানে রিভিশনের জন্য দেখা যাবে।',
    'Correct answer': 'সঠিক উত্তর',
    'Correction and evidence': 'সংশোধন ও প্রমাণ',
    'Read the proof and simple explanation before moving on.':
        'আগে প্রমাণ ও সহজ ব্যাখ্যা পড়ে নিন।',
    'Evidence': 'প্রমাণ',
    'Exact evidence': 'নির্দিষ্ট প্রমাণ',
    'Correct Answer': 'সঠিক উত্তর',
    'Simple explanation': 'সহজ ব্যাখ্যা',
    'Common mistake': 'সাধারণ ভুল',
    'Wrong belief / related groups': 'ভুল বিশ্বাস / সম্পর্কিত দল',
    'This is NOT the correct answer. It lists the wrong belief or related group connected to the wrong choices.':
        'এটি সঠিক উত্তর নয়। এখানে ভুল উত্তরের সাথে যুক্ত ভুল বিশ্বাস বা দলের নাম দেখানো হয়েছে।',
    'Qur’an translation': 'কুরআনের অনুবাদ',
    'Hadith source': 'হাদীসের সূত্র',
    'Scholar statement': 'আলেমের বক্তব্য',
    'Evidence source': 'প্রমাণের সূত্র',
    'Verse / reference': 'আয়াত / রেফারেন্স',
    'Collection / number': 'গ্রন্থ / নম্বর',
    'Sunnah.com lookup': 'Sunnah.com লুকআপ',
    'Narrator / topic': 'বর্ণনাকারী / বিষয়',
    'Quoted text / excerpt': 'উদ্ধৃত টেক্সট / অংশ',
    'Translation note': 'অনুবাদ নোট',
    'Named Qur’an translation and hadith wording are shown as quoted text. Explanations are kept separate.':
        'নির্দিষ্ট কুরআন অনুবাদ ও হাদীসের শব্দ উদ্ধৃতি হিসেবে দেখানো হয়েছে। ব্যাখ্যা আলাদা রাখা হয়েছে।',
    'Hadith cards separate collection, number, lookup, narrator/topic, Arabic text, and quoted translation where available.':
        'হাদীস কার্ডে গ্রন্থ, নম্বর, লুকআপ, বর্ণনাকারী/বিষয়, আরবি টেক্সট এবং পাওয়া গেলে উদ্ধৃত অনুবাদ আলাদা দেখানো হয়।',
    'English quote kept for exact reference; Bangla explanation is shown separately.':
        'নির্দিষ্ট রেফারেন্সের জন্য ইংরেজি উদ্ধৃতি রাখা হয়েছে; বাংলা ব্যাখ্যা আলাদাভাবে দেখানো হয়।',
    'Reference text is translated in Bangla mode; source names and numbers stay visible.':
        'বাংলা মোডে রেফারেন্সের অর্থ বাংলায় দেখানো হয়; মূল সূত্রের নাম ও নম্বর দৃশ্যমান থাকে।',

    // Reference quote renderings
    'Mu‘awiyah ibn al-Hakam رضي الله عنه; the Prophet ﷺ asked the slave girl about Allah.':
        'মুআবিয়াহ ইবনুল হাকাম رضي الله عنه; নবী ﷺ দাসীকে আল্লাহ সম্পর্কে জিজ্ঞেস করেছিলেন।',
    'Reported from Imam Malik رحمه الله': 'ইমাম মালিক رحمه الله থেকে বর্ণিত',
    'Hadith about the believers seeing Allah on the Day of Resurrection.':
        'কিয়ামতের দিন মুমিনদের আল্লাহকে দেখার বিষয়ে হাদীস।',
    'Believers seeing Allah on the Day of Resurrection.':
        'কিয়ামতের দিন মুমিনদের আল্লাহকে দেখা।',
    'Hadith about seeing Allah and preserving the prayers.':
        'আল্লাহকে দেখা এবং সালাত সংরক্ষণের বিষয়ে হাদীস।',
    'The Prophet ﷺ explained the status of du‘a.':
        'নবী ﷺ দুআর মর্যাদা ব্যাখ্যা করেছেন।',
    'Warning against sacrifice for anyone besides Allah.':
        'আল্লাহ ছাড়া অন্য কারও জন্য কুরবানি করার বিরুদ্ধে সতর্কতা।',
    'The branches of faith.': 'ঈমানের শাখাসমূহ।',
    'The obligation of the five daily prayers.':
        'পাঁচ ওয়াক্ত সালাতের ফরজ হওয়া।',
    'Severe warning about abandoning salah.':
        'সালাত পরিত্যাগ সম্পর্কে কঠোর সতর্কতা।',
    'Hadith about the Bridge over Hell.':
        'জাহান্নামের উপর সেতু সম্পর্কে হাদীস।',
    'Virtue of the Prophet’s generation and those after them.':
        'নবী ﷺ-এর যুগ এবং তার পরের যুগগুলোর মর্যাদা।',
    'Virtue of the earliest generations.': 'প্রথম যুগের মানুষদের মর্যাদা।',
    'Warning against abusing the Companions.':
        'সাহাবীদের গালি দেওয়া থেকে সতর্কতা।',
    'Warning against reviling the Companions.':
        'সাহাবীদের নিন্দা করা থেকে সতর্কতা।',
    'Virtue order of Abu Bakr, ‘Umar, and ‘Uthman رضي الله عنهم.':
        'আবু বকর, উমর এবং উসমান رضي الله عنهم-এর মর্যাদার ক্রম।',
    'Virtue of Abu Bakr رضي الله عنه.': 'আবু বকর رضي الله عنه-এর মর্যাদা।',
    'Sincerity and intention.': 'ইখলাস ও নিয়ত।',
    'Rejection of invented religious actions.':
        'নতুন বানানো ধর্মীয় কাজ প্রত্যাখ্যান।',
    'Warning against religious innovation.': 'ধর্মে বিদআত সম্পর্কে সতর্কতা।',
    'The Prophet’s guidance is the best guidance.':
        'নবী ﷺ-এর হিদায়াতই সর্বোত্তম হিদায়াত।',
    'Obedience to rulers and the condition of clear disbelief.':
        'শাসকদের আনুগত্য এবং স্পষ্ট কুফর দেখার শর্ত।',
    'Warning against rebellion that causes fitnah.':
        'ফিতনা সৃষ্টি করে এমন বিদ্রোহ সম্পর্কে সতর্কতা।',
    'Hadith of Jibril about iman.':
        'ঈমান সম্পর্কে জিবরীল عليه السلام-এর হাদীস।',
    '“The Most Gracious (Allâh) rose over (Istawâ) the (Mighty) Throne (in a manner that suits His Majesty).”':
        '“পরম দয়াময় আল্লাহ আরশের উপর উঠেছেন (ইস্তিওয়া করেছেন), তাঁর মহিমার উপযোগীভাবে।”',
    '“Do you feel secure that He, Who is over the heaven (Allâh), will not cause the earth to sink with you, and then it should quake?”':
        '“তোমরা কি নিরাপদ যে, যিনি আসমানের ঊর্ধ্বে, আল্লাহ, তিনি তোমাদেরসহ জমিনকে ধসিয়ে দেবেন না, আর তখন তা কাঁপতে থাকবে?”',
    '“He said to her: Where is Allah? She said: Above the heavens. He said: Who am I? She said: You are the Messenger of Allah. He said: Free her, for she is a believer.”':
        '“তিনি তাকে বললেন: আল্লাহ কোথায়? সে বলল: আসমানের উপরে। তিনি বললেন: আমি কে? সে বলল: আপনি আল্লাহর রাসূল। তিনি বললেন: তাকে মুক্ত করে দাও, কারণ সে মুমিন।”',
    '“There is nothing like Him, for He ˹alone˺ is the All-Hearing, All-Seeing.”':
        '“তাঁর মতো কিছুই নেই; আর তিনিই সর্বশ্রোতা, সর্বদ্রষ্টা।”',
    '“And to Allah belong the best names, so invoke Him by them.”':
        '“আর সুন্দরতম নামসমূহ আল্লাহরই; অতএব সেসব নামে তাঁকে ডাকো।”',
    '“Then He established Himself above the Throne.”':
        '“তারপর তিনি আরশের উপর সমুন্নত হলেন।”',
    '“The rising is known, the how is unknown, belief in it is obligatory, and asking about it is an innovation.”':
        '“ইস্তিওয়া জানা বিষয়, তার কেমন তা অজানা, এতে বিশ্বাস করা ওয়াজিব, আর এ বিষয়ে প্রশ্ন করা বিদআত।”',
    '“But those in whose hearts is deviation [from truth] will follow that of it which is unspecific, seeking discord and seeking an interpretation [suitable to them].”':
        '“যাদের অন্তরে বক্রতা আছে, তারা ফিতনা খোঁজা এবং নিজেদের মতো ব্যাখ্যা খোঁজার জন্য এর অস্পষ্ট অংশের অনুসরণ করে।”',
    '“[Some] faces, that Day, will be radiant, Looking at their Lord.”':
        '“সেদিন কিছু মুখ উজ্জ্বল হবে, তারা তাদের রবের দিকে তাকিয়ে থাকবে।”',
    '“You will see your Lord as you see this moon, and you will have no trouble in seeing Him.”':
        '“তোমরা তোমাদের রবকে দেখবে যেমন তোমরা এই চাঁদকে দেখছ; তাঁকে দেখতে তোমাদের কোনো কষ্ট হবে না।”',
    '“You will see your Lord as you are seeing this moon, and you will not be harmed by seeing Him.”':
        '“তোমরা তোমাদের রবকে দেখবে যেমন তোমরা এই চাঁদকে দেখছ; তাঁকে দেখার কারণে তোমাদের কোনো ক্ষতি হবে না।”',
    '“until he hears the words of Allah.”':
        '“যতক্ষণ না সে আল্লাহর কালাম শুনে।”',
    '“And Allah spoke to Moses with [direct] speech.”':
        '“আর আল্লাহ মূসার সাথে সরাসরি কথা বলেছেন।”',
    '“And when Moses arrived at Our appointed time and his Lord spoke to him.”':
        '“আর যখন মূসা আমাদের নির্ধারিত সময়ে এলো এবং তার রব তার সাথে কথা বললেন।”',
    '“And I did not create the jinn and mankind except to worship Me.”':
        '“আমি জিন ও মানুষকে সৃষ্টি করেছি শুধু আমার ইবাদতের জন্য।”',
    '“And [He revealed] that the masjids are for Allah, so do not invoke with Allah anyone.”':
        '“আর মসজিদসমূহ আল্লাহর জন্য; অতএব আল্লাহর সাথে কাউকে ডেকো না।”',
    '“And your Lord says, ‘Call upon Me; I will respond to you.’”':
        '“আর তোমাদের রব বলেন, ‘তোমরা আমাকে ডাকো; আমি তোমাদের ডাকে সাড়া দেব।’”',
    '“Supplication is worship.”': '“দুআই ইবাদত।”',
    '“Indeed, Allah does not forgive association with Him, but He forgives what is less than that for whom He wills.”':
        '“নিশ্চয়ই আল্লাহ তাঁর সাথে শিরক করা ক্ষমা করেন না; এর নিচের গুনাহ যাকে ইচ্ছা ক্ষমা করেন।”',
    '“Indeed, association [with him] is great injustice.”':
        '“নিশ্চয়ই শিরক মহা জুলুম।”',
    '“It is You we worship and You we ask for help.”':
        '“আমরা শুধু তোমারই ইবাদত করি এবং শুধু তোমারই সাহায্য চাই।”',
    '“Indeed, my prayer, my rites of sacrifice, my living and my dying are for Allah, Lord of the worlds. No partner has He.”':
        '“নিশ্চয়ই আমার সালাত, আমার কুরবানি, আমার জীবন ও আমার মৃত্যু সৃষ্টিজগতের রব আল্লাহর জন্য। তাঁর কোনো শরীক নেই।”',
    '“Allah cursed him who sacrificed for anyone besides Allah.”':
        '“যে আল্লাহ ছাড়া অন্য কারও জন্য কুরবানি করে, আল্লাহ তাকে অভিশাপ করেছেন।”',
    '“Allah is the Creator of all things, and He is, over all things, Disposer of affairs.”':
        '“আল্লাহ সবকিছুর সৃষ্টিকর্তা এবং তিনি সবকিছুর উপর তত্ত্বাবধায়ক।”',
    '“Say, ‘Who provides for you from the heaven and the earth? Or who controls hearing and sight?’”':
        '“বলুন, ‘আসমান ও জমিন থেকে তোমাদের রিজিক কে দেন? অথবা শ্রবণ ও দৃষ্টির নিয়ন্ত্রণ কার হাতে?’”',
    '“Indeed, all things We created with predestination.”':
        '“নিশ্চয়ই আমরা সবকিছু তাকদীরসহ সৃষ্টি করেছি।”',
    '“No disaster strikes upon the earth or among yourselves except that it is in a register before We bring it into being.”':
        '“জমিনে বা তোমাদের নিজেদের মধ্যে কোনো বিপদ আসে না, তা ঘটানোর আগে তা একটি কিতাবে লেখা থাকে।”',
    '“And you do not will except that Allah wills. Indeed, Allah is ever Knowing and Wise.”':
        '“আর তোমরা ইচ্ছা করতে পারো না, যতক্ষণ না আল্লাহ ইচ্ছা করেন। নিশ্চয়ই আল্লাহ সর্বজ্ঞ, প্রজ্ঞাময়।”',
    '“And you do not will except that Allah wills - Lord of the worlds.”':
        '“আর তোমরা ইচ্ছা করতে পারো না, যতক্ষণ না সৃষ্টিজগতের রব আল্লাহ ইচ্ছা করেন।”',
    '“and when His verses are recited to them, it increases them in faith.”':
        '“আর যখন তাদের কাছে তাঁর আয়াতসমূহ তিলাওয়াত করা হয়, তা তাদের ঈমান বাড়িয়ে দেয়।”',
    '“Faith has over seventy branches or over sixty branches, the most excellent of which is the declaration that there is no god but Allah, and the humblest of which is the removal of what is injurious from the path.”':
        '“ঈমানের সত্তরের বেশি অথবা ষাটের বেশি শাখা আছে; এর সর্বোত্তম হলো এ ঘোষণা যে আল্লাহ ছাড়া কোনো ইলাহ নেই, আর সবচেয়ে নিম্নটি হলো রাস্তা থেকে কষ্টদায়ক বস্তু সরানো।”',
    '“that they would increase in faith along with their [present] faith.”':
        '“যাতে তারা তাদের ঈমানের সাথে আরও ঈমান বাড়িয়ে নেয়।”',
    '“and those who have believed will increase in faith.”':
        '“আর যারা ঈমান এনেছে, তাদের ঈমান বাড়বে।”',
    '“Indeed, prayer has been decreed upon the believers a decree of specified times.”':
        '“নিশ্চয়ই সালাত মুমিনদের উপর নির্ধারিত সময়ে ফরজ করা হয়েছে।”',
    '“Allah enjoined fifty prayers on my followers. When I returned with this order of Allah, I passed by Moses who asked me, ‘What has Allah enjoined on your followers?’ I replied, ‘He has enjoined fifty prayers on them.’”':
        '“আল্লাহ আমার উম্মতের উপর পঞ্চাশ ওয়াক্ত সালাত ফরজ করলেন। আমি আল্লাহর এই আদেশ নিয়ে ফিরছিলাম, তখন মূসার পাশ দিয়ে গেলাম; তিনি আমাকে জিজ্ঞেস করলেন, ‘আল্লাহ আপনার উম্মতের উপর কী ফরজ করেছেন?’ আমি বললাম, ‘তিনি তাদের উপর পঞ্চাশ ওয়াক্ত সালাত ফরজ করেছেন।’”',
    '“Between a man and polytheism and unbelief is the abandonment of salat.”':
        '“একজন মানুষের এবং শিরক ও কুফরের মাঝে রয়েছে সালাত পরিত্যাগ।”',
    '“The covenant that is between us and them is the Salat; so whoever abandons it, he has committed disbelief.”':
        '“আমাদের ও তাদের মধ্যকার চুক্তি হলো সালাত; যে এটি পরিত্যাগ করে, সে কুফর করেছে।”',
    '“And if two factions among the believers should fight, then make settlement between the two.”':
        '“আর মুমিনদের দুই দল যদি পরস্পর লড়াই করে, তবে তাদের মধ্যে মীমাংসা করে দাও।”',
    '“The believers are but brothers.”': '“মুমিনরা তো পরস্পর ভাই।”',
    '“Say, ‘Is it Allah and His verses and His Messenger that you were mocking?’ Make no excuse; you have disbelieved after your belief.”':
        '“বলুন, ‘তোমরা কি আল্লাহ, তাঁর আয়াতসমূহ এবং তাঁর রাসূলকে নিয়ে উপহাস করছিলে?’ কোনো অজুহাত দিও না; তোমরা ঈমানের পর কুফর করেছ।”',
    '“Then indeed, after that you are to die. Then indeed you, on the Day of Resurrection, will be resurrected.”':
        '“তারপর নিশ্চয়ই এর পর তোমরা মৃত্যুবরণ করবে। তারপর নিশ্চয়ই কিয়ামতের দিন তোমরা পুনরুত্থিত হবে।”',
    '“Say, ‘Yes, by my Lord, you will surely be resurrected; then you will surely be informed of what you did.’”':
        '“বলুন, ‘হ্যাঁ, আমার রবের শপথ, তোমরা অবশ্যই পুনরুত্থিত হবে; তারপর তোমরা যা করেছ তা তোমাদের জানানো হবে।’”',
    '“And We place the scales of justice for the Day of Resurrection, so no soul will be treated unjustly at all.”':
        '“আর কিয়ামতের দিনের জন্য আমরা ন্যায়বিচারের পাল্লা স্থাপন করব; ফলে কোনো প্রাণের প্রতি সামান্যও জুলুম করা হবে না।”',
    '“Then the bridge would be set over the Hell.”':
        '“তারপর জাহান্নামের উপর সেতু স্থাপন করা হবে।”',
    '“The best of my followers are those living in my generation and then those who will follow the latter.”':
        '“আমার অনুসারীদের মধ্যে সর্বোত্তম হলো আমার যুগের মানুষ, তারপর যারা তাদের পরে আসবে।”',
    '“The best of my Umma would be those of the generation nearest to mine. Then those nearest to them, then those nearest to them.”':
        '“আমার উম্মতের মধ্যে সর্বোত্তম হবে আমার নিকটতম যুগের মানুষ; তারপর তাদের নিকটতম, তারপর তাদের নিকটতম।”',
    '“And the first forerunners [in the faith] among the Muhajireen and the Ansar and those who followed them with good conduct - Allah is pleased with them.”':
        '“মুহাজির ও আনসারদের মধ্যে প্রথম অগ্রগামীরা এবং যারা সুন্দরভাবে তাদের অনুসরণ করেছে, আল্লাহ তাদের প্রতি সন্তুষ্ট।”',
    '“And whoever opposes the Messenger after guidance has become clear to him and follows other than the way of the believers - We will give him what he has taken.”':
        '“যার কাছে হিদায়াত স্পষ্ট হওয়ার পরও সে রাসূলের বিরোধিতা করে এবং মুমিনদের পথ ছাড়া অন্য পথ অনুসরণ করে, আমরা তাকে সে দিকেই ফিরিয়ে দেব যা সে গ্রহণ করেছে।”',
    '“Do not abuse my companions.”': '“আমার সাহাবীদের গালি দিও না।”',
    '“Do not revile my Companions.”': '“আমার সাহাবীদের নিন্দা করো না।”',
    '“During the lifetime of the Prophet (ﷺ) we used to consider Abu Bakr as peerless and then ‘Umar and then ‘Uthman.”':
        '“নবী ﷺ-এর জীবদ্দশায় আমরা আবু বকরকে অতুলনীয় মনে করতাম, তারপর উমরকে, তারপর উসমানকে।”',
    '“The person for whom I have the greatest love and respect amongst the people is ‘Aisha and among the men, her father.”':
        '“মানুষদের মধ্যে যার প্রতি আমার সবচেয়ে বেশি ভালোবাসা ও সম্মান, তিনি আয়িশা; আর পুরুষদের মধ্যে তাঁর পিতা।”',
    '“And if you disagree over anything, refer it to Allah and the Messenger.”':
        '“তোমরা কোনো বিষয়ে মতভেদ করলে তা আল্লাহ ও রাসূলের দিকে ফিরিয়ে দাও।”',
    '“and not associate in the worship of his Lord anyone.”':
        '“এবং তার রবের ইবাদতে কাউকে শরীক না করে।”',
    '“The reward of deeds depends upon the intentions.”':
        '“আমলসমূহের প্রতিদান নিয়তের উপর নির্ভর করে।”',
    '“He who did any act for which there is no sanction from our behalf, that is to be rejected.”':
        '“যে ব্যক্তি এমন কোনো কাজ করল যার বিষয়ে আমাদের পক্ষ থেকে অনুমোদন নেই, তা প্রত্যাখ্যাত।”',
    '“The best discourse is the Book of Allah, and the best guidance is the guidance given by Muhammad. And the most evil affairs are their innovations; and every innovation is error.”':
        '“সর্বোত্তম কথা হলো আল্লাহর কিতাব, সর্বোত্তম হিদায়াত হলো মুহাম্মাদ ﷺ-এর হিদায়াত। সবচেয়ে নিকৃষ্ট বিষয় হলো নতুন উদ্ভাবিত বিষয়সমূহ; আর প্রত্যেক বিদআত পথভ্রষ্টতা।”',
    '“The best guidance is the guidance given by Muhammad.”':
        '“সর্বোত্তম হিদায়াত হলো মুহাম্মাদ ﷺ-এর হিদায়াত।”',
    '“There has certainly been for you in the Messenger of Allah an excellent pattern.”':
        '“নিশ্চয়ই তোমাদের জন্য আল্লাহর রাসূলের মধ্যে উত্তম আদর্শ রয়েছে।”',
    '“Say, [O Muhammad], ‘If you should love Allah, then follow me, [so] Allah will love you.’”':
        '“বলুন, ‘তোমরা যদি আল্লাহকে ভালোবাসো, তবে আমাকে অনুসরণ করো; তাহলে আল্লাহ তোমাদের ভালোবাসবেন।’”',
    '“If you invoke them, they do not hear your supplication; and if they heard, they would not respond to you.”':
        '“তোমরা যদি তাদের ডাকো, তারা তোমাদের ডাক শুনবে না; আর শুনলেও তারা তোমাদের সাড়া দিতে পারবে না।”',
    '“This day I have perfected for you your religion and completed My favor upon you and have approved for you Islam as religion.”':
        '“আজ আমি তোমাদের জন্য তোমাদের দ্বীন পূর্ণাঙ্গ করলাম, তোমাদের উপর আমার নিয়ামত সম্পূর্ণ করলাম এবং তোমাদের জন্য ইসলামকে দ্বীন হিসেবে পছন্দ করলাম।”',
    '“O you who have believed, obey Allah and obey the Messenger and those in authority among you.”':
        '“হে ঈমানদারগণ, আল্লাহর আনুগত্য করো, রাসূলের আনুগত্য করো এবং তোমাদের মধ্যে যারা কর্তৃত্বশীল তাদেরও।”',
    '“unless you see clear disbelief, for which you have proof from Allah.”':
        '“যদি না তোমরা স্পষ্ট কুফর দেখতে পাও, যার বিষয়ে তোমাদের কাছে আল্লাহর পক্ষ থেকে প্রমাণ আছে।”',
    '“Listen to and obey the Amir, even if your back is beaten and your wealth is taken.”':
        '“আমীরের কথা শোনো এবং আনুগত্য করো, যদিও তোমার পিঠে আঘাত করা হয় এবং তোমার সম্পদ নিয়ে নেওয়া হয়।”',
    '“And they were not commanded except to worship Allah, [being] sincere to Him in religion.”':
        '“তাদেরকে শুধু এ নির্দেশই দেওয়া হয়েছিল যে তারা আল্লাহর ইবাদত করবে, তাঁর জন্য দ্বীনকে খালেস করে।”',
    '“Worship Allah and associate nothing with Him.”':
        '“আল্লাহর ইবাদত করো এবং তাঁর সাথে কাউকে শরীক করো না।”',
    '“It is that you believe in Allah and His angels and His Books and His Messengers and in the Last Day and in qadar (fate), both in its good and in its evil aspects.”':
        '“তা হলো তুমি আল্লাহ, তাঁর ফেরেশতাগণ, তাঁর কিতাবসমূহ, তাঁর রাসূলগণ, শেষ দিন এবং তাকদীরের ভালো-মন্দে বিশ্বাস করবে।”',

    // Stats and common UI
    'Level': 'লেভেল',
    'Total XP': 'মোট XP',
    'Completed Quizzes': 'সম্পন্ন কুইজ',
    'Best Score': 'সেরা স্কোর',
    'Questions Completed': 'সম্পন্ন প্রশ্ন',
    'Mistakes': 'ভুল',
    'questions': 'প্রশ্ন',
    'Beginner': 'শুরুর স্তর',
    'Intermediate': 'মধ্যম',
    'Advanced': 'উন্নত',
    'Essential': 'গুরুত্বপূর্ণ',

    // Categories
    'Core Beliefs': 'মূল বিশ্বাস',
    'Names & Attributes': 'আল্লাহর নাম ও গুণাবলি',
    'Qur’an and Allah’s Speech': 'কুরআন ও আল্লাহর কালাম',
    'Tawheed of Worship': 'ইবাদতের তাওহীদ',
    'Tawheed of Lordship': 'রুবুবিয়্যাহর তাওহীদ',
    'Iman, Salah & Major Sins': 'ঈমান, সালাত ও বড় গুনাহ',
    'Qadar': 'তাকদীর',
    'Salaf & Sects': 'সালাফ ও ফিরকা',
    'Sunnah vs Bid‘ah': 'সুন্নাহ বনাম বিদআত',
    'Hereafter': 'আখিরাত',

    // Home text
    'Qur’an • Authentic Sunnah • Understanding of the Salaf':
        'কুরআন • সহীহ সুন্নাহ • সালাফদের বোঝাপড়া',
    'Learn correct aqeedah step by step.': 'ধাপে ধাপে সঠিক আকীদাহ শিখুন।',
    'Start with the most important foundations first: where Allah is, Allah’s Names and Attributes, the Qur’an, Salah, Tawheed, shirk, the Salaf, and the danger of bid‘ah.':
        'আগে সবচেয়ে গুরুত্বপূর্ণ ভিত্তি দিয়ে শুরু করুন: আল্লাহ কোথায়, আল্লাহর নাম ও গুণাবলি, কুরআন, সালাত, তাওহীদ, শিরক, সালাফ এবং বিদআতের ভয়াবহতা।',
    'Where is Allah?': 'আল্লাহ কোথায়?',
    'Allah’s Attributes': 'আল্লাহর গুণাবলি',
    'Qur’an is Allah’s Speech': 'কুরআন আল্লাহর কালাম',
    'Salah and Iman': 'সালাত ও ঈমান',
    'Tawheed of Worship': 'ইবাদতের তাওহীদ',

    // Core beliefs screen headings/texts
    'Purpose': 'উদ্দেশ্য',
    'Core approach': 'মূল পদ্ধতি',
    'Simple language': 'সহজ ভাষা',
    'Careful wording': 'সতর্ক ভাষা',
    'Related mistake labels': 'ভুল-সম্পর্কিত লেবেল',
    'Review before publishing': 'প্রকাশের আগে যাচাই',
    'Local progress in v1': 'প্রথম ভার্সনে লোকাল প্রগ্রেস',

    // Core belief titles and summaries
    'Allah alone is the Creator and Controller':
        'আল্লাহ একাই সৃষ্টিকর্তা ও নিয়ন্ত্রক',
    'Allah created everything, owns everything, provides for all creation, and nothing happens except by His will and decree.':
        'আল্লাহ সবকিছু সৃষ্টি করেছেন, সবকিছুর মালিক, সব সৃষ্টিকে রিজিক দেন, এবং তাঁর ইচ্ছা ও তাকদীর ছাড়া কিছুই ঘটে না।',
    'Allah alone deserves worship': 'ইবাদতের হকদার একমাত্র আল্লাহ',
    'Prayer, du‘a, sacrifice, hope, fear, reliance, love, and all acts of worship must be for Allah alone.':
        'সালাত, দুআ, কুরবানি, আশা, ভয়, ভরসা, ভালোবাসা এবং সব ইবাদত শুধু আল্লাহর জন্য হতে হবে।',
    'Shirk is the greatest sin': 'শিরক সবচেয়ে বড় গুনাহ',
    'Directing worship to other than Allah is shirk. A Muslim must learn Tawheed and stay away from shirk and its paths.':
        'আল্লাহ ছাড়া অন্যের জন্য ইবাদত করা শিরক। একজন মুসলিমকে তাওহীদ শিখতে হবে এবং শিরক ও তার পথ থেকে দূরে থাকতে হবে।',
    'Allah’s Names and Attributes are perfect':
        'আল্লাহর নাম ও গুণাবলি পরিপূর্ণ',
    'We affirm what Allah affirmed for Himself and what the Messenger ﷺ affirmed, without changing the meaning, denying, asking how, or comparing Allah to creation.':
        'আল্লাহ নিজের জন্য যা সাব্যস্ত করেছেন এবং রাসূল ﷺ যা সাব্যস্ত করেছেন তা আমরা মানি—অর্থ বদলাই না, অস্বীকার করি না, কীভাবে জিজ্ঞেস করি না, এবং সৃষ্টির সাথে তুলনা করি না।',
    'Allah is above His creation': 'আল্লাহ তাঁর সৃষ্টির ঊর্ধ্বে',
    'Allah is above His creation, over the Throne, in a way that suits His Majesty. He is with His creation by His knowledge, hearing, seeing, and power.':
        'আল্লাহ তাঁর সৃষ্টির ঊর্ধ্বে, আরশের উপর, তাঁর মহিমার উপযোগীভাবে। তিনি তাঁর জ্ঞান, শ্রবণ, দেখা ও ক্ষমতার মাধ্যমে সৃষ্টির সাথে আছেন।',
    'The Qur’an is Allah’s Speech': 'কুরআন আল্লাহর কালাম',
    'The Qur’an is the uncreated Speech of Allah. Allah truly speaks, and His Speech is not like the speech of creation.':
        'কুরআন আল্লাহর অমাখলুক কালাম। আল্লাহ সত্যিই কথা বলেন, এবং তাঁর কথা সৃষ্টির কথার মতো নয়।',
    'Follow the Prophet ﷺ and the Salaf': 'রাসূল ﷺ ও সালাফদের পথ অনুসরণ করুন',
    'Correct understanding is based on the Qur’an, authentic Sunnah, and the understanding of the Companions and the early righteous generations.':
        'সঠিক বুঝ কুরআন, সহীহ সুন্নাহ, সাহাবী এবং প্রথম যুগের নেক মানুষদের বোঝার উপর ভিত্তি করে।',
    'Iman includes belief, speech, and action':
        'ঈমান বিশ্বাস, কথা ও আমলকে অন্তর্ভুক্ত করে',
    'Iman is belief in the heart, speech of the tongue, and actions of the limbs. It increases with obedience and decreases with sin.':
        'ঈমান হলো অন্তরের বিশ্বাস, জিহ্বার কথা এবং অঙ্গ-প্রত্যঙ্গের আমল। আনুগত্যে বাড়ে এবং গুনাহে কমে।',
    'Believe in the six pillars of iman': 'ঈমানের ছয়টি স্তম্ভে বিশ্বাস করুন',
    'A Muslim believes in Allah, His angels, His books, His messengers, the Last Day, and qadar, both its good and its bad.':
        'একজন মুসলিম আল্লাহ, তাঁর ফেরেশতা, তাঁর কিতাবসমূহ, তাঁর রাসূলগণ, শেষ দিন, এবং তাকদীরের ভালো-মন্দে বিশ্বাস করে।',
    'The Hereafter is real': 'আখিরাত সত্য',
    'The Resurrection, judgment, Scale, Bridge, Paradise, Hellfire, and the believers seeing Allah are real.':
        'পুনরুত্থান, হিসাব, মীযান, সীরাত, জান্নাত, জাহান্নাম এবং মুমিনদের আল্লাহকে দেখা সত্য।',
    'Love and honor the Companions': 'সাহাবীদের ভালোবাসুন ও সম্মান করুন',
    'Ahlus-Sunnah love all the Companions. The best of this Ummah after the Prophet ﷺ are Abu Bakr, Umar, Uthman, then Ali رضي الله عنهم.':
        'আহলুস-সুন্নাহ সব সাহাবীকে ভালোবাসে। রাসূল ﷺ-এর পর এই উম্মতের শ্রেষ্ঠ হলেন আবু বকর, উমর, উসমান, তারপর আলী رضي الله عنهم।',
    'Avoid bid‘ah in religion': 'ধর্মে বিদআত থেকে বাঁচুন',
    'Islam is complete. Worship must be sincere for Allah and according to the Sunnah. Good intention does not make invented worship correct.':
        'ইসলাম পূর্ণাঙ্গ। ইবাদত আল্লাহর জন্য খালেস এবং সুন্নাহ অনুযায়ী হতে হবে। ভালো নিয়ত নতুন বানানো ইবাদতকে সঠিক বানায় না।',
    'Avoid reckless takfir': 'অবিবেচনাপূর্ণ তাকফীর থেকে বাঁচুন',
    'Major sins are dangerous, but specific people are not declared outside Islam without clear proof, conditions, and removal of excuses by qualified people.':
        'বড় গুনাহ ভয়াবহ, কিন্তু নির্দিষ্ট কাউকে স্পষ্ট প্রমাণ, শর্ত ও বাধা দূর করা ছাড়া ইসলামের বাইরে বলা যায় না—এ কাজ যোগ্য লোকদের।',
    'Obey Muslim rulers in what is lawful':
        'বৈধ কাজে মুসলিম শাসকদের আনুগত্য করুন',
    'Ahlus-Sunnah obey in what is lawful, do not obey sin, advise with wisdom, and avoid rebellion that causes greater harm and fitnah.':
        'আহলুস-সুন্নাহ বৈধ কাজে আনুগত্য করে, গুনাহে আনুগত্য করে না, হিকমাহর সাথে নসীহত করে, এবং বড় ক্ষতি ও ফিতনা আনে এমন বিদ্রোহ থেকে দূরে থাকে।',

    // Question text and answer choices (Bangla mode; evidence quotes remain in source translation)
    'Allah is above His creation, over the Throne, in a way that suits His Majesty':
        'আল্লাহ তাঁর সৃষ্টির ঊর্ধ্বে, আরশের উপর, তাঁর মহিমার উপযোগীভাবে',
    'Allah is everywhere with His Essence': 'আল্লাহ তাঁর সত্তাসহ সর্বত্র আছেন',
    'Allah is inside creation or mixed with creation':
        'আল্লাহ সৃষ্টির ভিতরে বা সৃষ্টির সাথে মিশে আছেন',
    'The verses about Allah being above should be denied':
        'আল্লাহ ঊর্ধ্বে থাকার আয়াতগুলো অস্বীকার করা উচিত',
    'Ahlus-Sunnah affirm that Allah is above His creation and over the Throne. We believe this as Allah said, without asking how and without comparing Allah to creation.':
        'আহলুস-সুন্নাহ বিশ্বাস করে যে আল্লাহ সৃষ্টির ঊর্ধ্বে এবং আরশের উপর। আল্লাহ যেভাবে বলেছেন আমরা সেভাবেই বিশ্বাস করি—কীভাবে তা জিজ্ঞেস করি না এবং সৃষ্টির সাথে তুলনা করি না।',
    'A common mistake is saying Allah is everywhere with His Essence. Allah is with His creation by His knowledge, hearing, seeing, and power.':
        'একটি সাধারণ ভুল হলো বলা যে আল্লাহ তাঁর সত্তাসহ সর্বত্র আছেন। আল্লাহ তাঁর জ্ঞান, শ্রবণ, দেখা ও ক্ষমতার মাধ্যমে সৃষ্টির সাথে আছেন।',
    'Wrong belief/group names: Jahmiyyah, Mu‘tazilah, Ash‘ari/Maturidi ta’wil tendency, Hulul/Ittihad-style ideas. Wrong belief: denying Allah’s highness, saying Allah is everywhere with His Essence, or explaining away the texts without proof.':
        'ভুল বিশ্বাস/দলের নাম: জাহমিয়্যাহ, মুতাজিলা, আশআরি/মাতুরিদি তাবীলের প্রবণতা, হুলুল/ইত্তিহাদ ধরনের ধারণা। ভুল বিশ্বাস: আল্লাহর ঊর্ধ্বতা অস্বীকার করা, আল্লাহ তাঁর সত্তাসহ সর্বত্র আছেন বলা, অথবা প্রমাণ ছাড়া নসগুলোর অর্থ ঘুরিয়ে দেওয়া।',

    'What is the correct belief about Allah’s Names and Attributes?':
        'আল্লাহর নাম ও গুণাবলি সম্পর্কে সঠিক বিশ্বাস কী?',
    'Affirm what Allah and His Messenger ﷺ affirmed, without changing the meaning, denying it, asking how, or comparing Allah to creation':
        'আল্লাহ ও তাঁর রাসূল ﷺ যা সাব্যস্ত করেছেন তা মানা—অর্থ বদলানো, অস্বীকার করা, কীভাবে জিজ্ঞেস করা, বা সৃষ্টির সাথে তুলনা করা ছাড়া',
    'Deny the Attributes to avoid any resemblance':
        'সাদৃশ্য এড়াতে গুণাবলি অস্বীকার করা',
    'Explain away every Attribute by default':
        'প্রতিটি গুণাবলির অর্থ নিজের মতো করে ঘুরিয়ে দেওয়া',
    'Imagine Allah’s Attributes like human attributes':
        'আল্লাহর গুণাবলিকে মানুষের গুণের মতো কল্পনা করা',
    'This verse teaches both truths together: Allah is not like creation, and Allah truly has perfect Attributes such as hearing and seeing.':
        'এই আয়াত দুইটি বিষয় একসাথে শেখায়: আল্লাহ সৃষ্টির মতো নন, এবং আল্লাহর শ্রবণ ও দেখার মতো পূর্ণ গুণাবলি সত্যিই আছে।',
    'Some people deny Attributes, while others imagine them like creation. Both are wrong.':
        'কেউ গুণাবলি অস্বীকার করে, আবার কেউ সৃষ্টির মতো কল্পনা করে। দুটিই ভুল।',
    'Wrong belief/group names: Jahmiyyah, Mu‘tazilah, Ash‘ari/Maturidi ta’wil tendency, Mushabbihah. Wrong belief: denying Attributes, changing meanings without proof, or comparing Allah to creation.':
        'ভুল বিশ্বাস/দলের নাম: জাহমিয়্যাহ, মুতাজিলা, আশআরি/মাতুরিদি তাবীলের প্রবণতা, মুশাব্বিহাহ। ভুল বিশ্বাস: গুণাবলি অস্বীকার করা, প্রমাণ ছাড়া অর্থ বদলানো, অথবা আল্লাহকে সৃষ্টির সাথে তুলনা করা।',

    'What should we say about Allah rising over the Throne?':
        'আল্লাহ আরশের উপর উঠেছেন—এ বিষয়ে কী বলা উচিত?',
    'Allah rose over the Throne in a way that suits His Majesty':
        'আল্লাহ তাঁর মহিমার উপযোগীভাবে আরশের উপর উঠেছেন',
    'Allah is like a created body sitting on a chair':
        'আল্লাহ চেয়ারে বসা কোনো সৃষ্ট দেহের মতো',
    'The verse should be rejected': 'আয়াতটি অস্বীকার করা উচিত',
    'The Salaf accepted the wording of revelation. They did not deny it and they did not imagine how it is.':
        'সালাফরা ওহীর ভাষা গ্রহণ করেছেন। তাঁরা তা অস্বীকার করেননি এবং কীভাবে তা কল্পনা করেননি।',
    'One mistake is denying the Attribute. Another mistake is imagining a created form.':
        'একটি ভুল হলো গুণটি অস্বীকার করা। আরেকটি ভুল হলো সৃষ্টির মতো আকার কল্পনা করা।',

    'When we do not know the exact “how” of an Attribute of Allah, what should we do?':
        'আল্লাহর কোনো গুণের “কীভাবে” আমরা না জানলে কী করব?',
    'Believe the text and leave the exact how to Allah':
        'নসকে বিশ্বাস করব এবং “কীভাবে” বিষয়টি আল্লাহর কাছে ছেড়ে দেব',
    'Invent a picture in the mind': 'মনে একটি ছবি বানিয়ে নেব',
    'Deny the Attribute completely': 'গুণটি সম্পূর্ণ অস্বীকার করব',
    'Say the Prophet ﷺ did not explain belief clearly':
        'বলব রাসূল ﷺ আকীদাহ স্পষ্ট করে বুঝাননি',
    'Allah told us what to believe, but He did not tell us the exact reality of His Attributes. So we stop where revelation stops.':
        'আল্লাহ আমাদের কী বিশ্বাস করতে হবে তা জানিয়েছেন, কিন্তু তাঁর গুণাবলির প্রকৃত রূপ কেমন তা জানাননি। তাই ওহী যেখানে থেমেছে আমরাও সেখানে থামি।',
    'A common mistake is trying to imagine how Allah’s Attributes are.':
        'সাধারণ ভুল হলো আল্লাহর গুণাবলি কেমন তা কল্পনা করার চেষ্টা করা।',

    'Will the believers see Allah in the Hereafter?':
        'মুমিনরা কি আখিরাতে আল্লাহকে দেখবে?',
    'Yes, the believers will see Allah in a way that suits His Majesty':
        'হ্যাঁ, মুমিনরা আল্লাহকে দেখবে—তাঁর মহিমার উপযোগীভাবে',
    'No, seeing Allah is impossible in every way':
        'না, কোনোভাবেই আল্লাহকে দেখা সম্ভব নয়',
    'Only angels can see Allah': 'শুধু ফেরেশতারা আল্লাহকে দেখতে পারে',
    'It only means seeing a created sign':
        'এর অর্থ শুধু কোনো সৃষ্ট নিদর্শন দেখা',
    'Ahlus-Sunnah believe that seeing Allah in the Hereafter is real. This does not mean Allah resembles creation.':
        'আহলুস-সুন্নাহ বিশ্বাস করে যে আখিরাতে আল্লাহকে দেখা সত্য। এর অর্থ এই নয় যে আল্লাহ সৃষ্টির মতো।',

    'What is the correct belief about the Qur’an?':
        'কুরআন সম্পর্কে সঠিক বিশ্বাস কী?',
    'The Qur’an is the uncreated Speech of Allah':
        'কুরআন আল্লাহর অমাখলুক কালাম',
    'The Qur’an is created like ordinary human speech':
        'কুরআন সাধারণ মানুষের কথার মতো সৃষ্টি',
    'The meaning is from Allah but the wording is from people':
        'অর্থ আল্লাহর, কিন্তু শব্দ মানুষের',
    'The Qur’an is not truly Allah’s Speech':
        'কুরআন সত্যিকার অর্থে আল্লাহর কালাম নয়',
    'Allah truly speaks, and the Qur’an is His Speech. It was revealed by Allah and is not created.':
        'আল্লাহ সত্যিই কথা বলেন, এবং কুরআন তাঁর কালাম। এটি আল্লাহর পক্ষ থেকে নাযিল, সৃষ্টি নয়।',

    'Why did Allah create jinn and mankind?':
        'আল্লাহ জিন ও মানুষকে কেন সৃষ্টি করেছেন?',
    'To worship Allah alone': 'শুধু আল্লাহর ইবাদত করার জন্য',
    'To worship righteous people through graves':
        'কবরের মাধ্যমে নেককার মানুষদের ইবাদত করার জন্য',
    'To only know Allah exists without worshipping Him':
        'ইবাদত ছাড়া শুধু আল্লাহ আছেন জানা',
    'To follow any religion sincerely': 'যেকোনো ধর্ম আন্তরিকভাবে অনুসরণ করা',
    'The main purpose of life is worshipping Allah alone. Worship includes prayer, du‘a, sacrifice, hope, fear, love, reliance, and obedience.':
        'জীবনের মূল উদ্দেশ্য হলো একমাত্র আল্লাহর ইবাদত করা। ইবাদতের মধ্যে সালাত, দুআ, কুরবানি, আশা, ভয়, ভালোবাসা, ভরসা ও আনুগত্য অন্তর্ভুক্ত।',

    'Who should we call upon in du‘a?': 'দুআতে আমরা কাকে ডাকব?',
    'Allah alone': 'শুধু আল্লাহকে',
    'Dead saints for unseen needs': 'অদৃশ্য প্রয়োজনের জন্য মৃত পীর/ওলীদের',
    'Angels independently': 'ফেরেশতাদের স্বাধীনভাবে',
    'Jinn when humans cannot help': 'মানুষ সাহায্য করতে না পারলে জিনদের',
    'Du‘a is worship, and worship belongs to Allah alone. A living person may be asked for normal help they are able to give.':
        'দুআ ইবাদত, আর ইবাদত শুধু আল্লাহর জন্য। জীবিত মানুষকে তার সক্ষম সাধারণ কাজে সাহায্য চাইতে বলা যায়।',

    'What is the greatest sin?': 'সবচেয়ে বড় গুনাহ কী?',
    'Shirk: worshipping others along with Allah':
        'শিরক: আল্লাহর সাথে অন্যের ইবাদত করা',
    'Minor mistakes in daily habits': 'দৈনন্দিন অভ্যাসের ছোট ভুল',
    'Forgetting a voluntary prayer': 'নফল সালাত ভুলে যাওয়া',
    'Being poor': 'গরিব হওয়া',
    'Shirk is the greatest sin because it gives worship to other than Allah.':
        'শিরক সবচেয়ে বড় গুনাহ, কারণ এতে ইবাদত আল্লাহ ছাড়া অন্যের জন্য করা হয়।',

    'Who is the Creator, Owner, and Controller of everything?':
        'সবকিছুর সৃষ্টিকর্তা, মালিক ও নিয়ন্ত্রক কে?',
    'The angels independently': 'ফেরেশতারা স্বাধীনভাবে',
    'Righteous people after death': 'নেককার মানুষ মৃত্যুর পর',
    'Nature without Allah’s decree': 'আল্লাহর তাকদীর ছাড়া প্রকৃতি',
    'Allah alone created everything and controls provision, life, death, and command.':
        'আল্লাহ একাই সব সৃষ্টি করেছেন এবং রিজিক, জীবন, মৃত্যু ও আদেশ নিয়ন্ত্রণ করেন।',

    'Does anything happen outside Allah’s will and decree?':
        'আল্লাহর ইচ্ছা ও তাকদীরের বাইরে কিছু ঘটে কি?',
    'No, nothing happens except by Allah’s will and decree':
        'না, আল্লাহর ইচ্ছা ও তাকদীর ছাড়া কিছু ঘটে না',
    'Yes, some events defeat Allah’s will':
        'হ্যাঁ, কিছু ঘটনা আল্লাহর ইচ্ছাকে পরাজিত করে',
    'Only good things are decreed by Allah':
        'শুধু ভালো জিনিস আল্লাহর তাকদীরে আছে',
    'Humans create their actions independently of Allah':
        'মানুষ আল্লাহ থেকে স্বাধীনভাবে নিজের কাজ সৃষ্টি করে',

    'What is iman according to Ahlus-Sunnah?': 'আহলুস-সুন্নাহর মতে ঈমান কী?',
    'Belief in the heart, speech of the tongue, and actions of the limbs':
        'অন্তরের বিশ্বাস, জিহ্বার কথা এবং অঙ্গ-প্রত্যঙ্গের আমল',
    'Only knowledge in the heart': 'শুধু অন্তরের জ্ঞান',
    'Only saying the shahadah without heart belief or action':
        'অন্তরের বিশ্বাস বা আমল ছাড়া শুধু শাহাদাহ বলা',
    'Only good manners with no belief requirement':
        'বিশ্বাসের প্রয়োজন ছাড়া শুধু ভালো ব্যবহার',
    'Iman includes the heart, the tongue, and actions. It increases with obedience and decreases with sin.':
        'ঈমান অন্তর, জিহ্বা ও আমলকে অন্তর্ভুক্ত করে। আনুগত্যে বাড়ে এবং গুনাহে কমে।',

    'Does iman increase and decrease?': 'ঈমান কি বাড়ে ও কমে?',
    'Yes, it increases with obedience and decreases with sin':
        'হ্যাঁ, আনুগত্যে বাড়ে এবং গুনাহে কমে',
    'No, everyone’s iman is exactly equal': 'না, সবার ঈমান ঠিক একই সমান',
    'It only decreases but never increases': 'শুধু কমে, কখনো বাড়ে না',
    'Actions have no connection to iman': 'আমলের সাথে ঈমানের কোনো সম্পর্ক নেই',

    'What if someone rejects that the five daily prayers are obligatory?':
        'কেউ যদি পাঁচ ওয়াক্ত সালাত ফরজ হওয়া অস্বীকার করে?',
    'Rejecting the obligation of Salah after clear proof takes a person outside Islam':
        'স্পষ্ট প্রমাণের পর সালাত ফরজ হওয়া অস্বীকার করা মানুষকে ইসলামের বাইরে নিয়ে যায়',
    'It is only a small mistake': 'এটি শুধু ছোট ভুল',
    'It has no effect on Islam': 'ইসলামের উপর কোনো প্রভাব নেই',
    'It is better than praying without focus':
        'মনোযোগ ছাড়া সালাত পড়ার চেয়ে ভালো',

    'How serious is completely abandoning the five daily prayers?':
        'পাঁচ ওয়াক্ত সালাত পুরোপুরি ছেড়ে দেওয়া কত গুরুতর?',
    'It is extremely dangerous; many scholars held that completely abandoning Salah is major kufr':
        'এটি অত্যন্ত ভয়াবহ; অনেক আলেম সম্পূর্ণভাবে সালাত ছেড়ে দেওয়াকে বড় কুফর বলেছেন',
    'It is only a small sin': 'এটি শুধু ছোট গুনাহ',
    'It is allowed if the heart is good': 'অন্তর ভালো হলে এটি জায়েজ',
    'It proves a person has perfect iman': 'এটি প্রমাণ করে তার ঈমান পূর্ণ',

    'What is the balanced way with Muslims who commit major sins?':
        'বড় গুনাহকারী মুসলিমদের বিষয়ে ভারসাম্যপূর্ণ পথ কী?',
    'Major sins are dangerous, but we do not declare a Muslim outside Islam without clear proof and conditions':
        'বড় গুনাহ ভয়াবহ, কিন্তু স্পষ্ট প্রমাণ ও শর্ত ছাড়া কোনো মুসলিমকে ইসলামের বাইরে বলা যায় না',
    'Every major sinner is automatically outside Islam':
        'প্রত্যেক বড় গুনাহকারী নিজে থেকেই ইসলামের বাইরে',
    'Major sins do not harm iman at all': 'বড় গুনাহ ঈমানের কোনো ক্ষতি করে না',
    'No Muslim can ever be punished for sins':
        'কোনো মুসলিম কখনো গুনাহের শাস্তি পাবে না',

    'Which action can take a person outside Islam?':
        'কোন কাজ মানুষকে ইসলামের বাইরে নিতে পারে?',
    'Worshipping another besides Allah, such as making du‘a to the dead for unseen rescue':
        'আল্লাহ ছাড়া অন্যের ইবাদত করা, যেমন অদৃশ্য সাহায্যের জন্য মৃতদের কাছে দুআ করা',
    'Making a normal mistake while trying to obey Allah':
        'আল্লাহর আনুগত্যের চেষ্টা করতে গিয়ে সাধারণ ভুল করা',
    'Forgetting a Sunnah act': 'একটি সুন্নাহ আমল ভুলে যাওয়া',

    'What about mocking Allah, His verses, or His Messenger ﷺ?':
        'আল্লাহ, তাঁর আয়াত, বা তাঁর রাসূল ﷺ নিয়ে ঠাট্টা করলে কী হবে?',
    'Mocking Allah, His verses, or His Messenger ﷺ is disbelief':
        'আল্লাহ, তাঁর আয়াত, বা তাঁর রাসূল ﷺ নিয়ে ঠাট্টা করা কুফর',
    'It is only comedy and never affects Islam':
        'এটি শুধু মজা, ইসলামের উপর কোনো প্রভাব নেই',
    'It is allowed if people laugh': 'মানুষ হাসলে এটি জায়েজ',
    'It is only wrong if done in Arabic': 'শুধু আরবিতে করলে ভুল',

    'What if someone denies the Resurrection after death?':
        'কেউ যদি মৃত্যুর পর পুনরুত্থান অস্বীকার করে?',
    'Denying the Resurrection after clear proof is disbelief':
        'স্পষ্ট প্রমাণের পর পুনরুত্থান অস্বীকার করা কুফর',
    'It is a valid Muslim opinion': 'এটি একটি বৈধ মুসলিম মত',
    'It only affects manners, not belief':
        'এটি শুধু আচরণে প্রভাব ফেলে, বিশ্বাসে নয়',
    'No one will be raised after death': 'মৃত্যুর পর কেউ উঠবে না',

    'Why is the understanding of the Salaf important?':
        'সালাফদের বোঝাপড়া কেন গুরুত্বপূর্ণ?',
    'They were closest to the Prophet ﷺ and understood revelation best':
        'তাঁরা রাসূল ﷺ-এর সবচেয়ে কাছাকাছি ছিলেন এবং ওহী সবচেয়ে ভালো বুঝেছেন',
    'They can replace the Qur’an': 'তাঁরা কুরআনের জায়গা নিতে পারেন',
    'Their way is not needed': 'তাঁদের পথের প্রয়োজন নেই',
    'New ideas are always better': 'নতুন ধারণা সবসময় ভালো',

    'What did the Prophet ﷺ warn about invented religious practices?':
        'রাসূল ﷺ নতুন বানানো ধর্মীয় কাজ সম্পর্কে কী সতর্ক করেছেন?',
    'Invented religious practices are misguidance':
        'নতুন বানানো ধর্মীয় কাজ পথভ্রষ্টতা',
    'Every new worship practice is automatically good':
        'প্রতিটি নতুন ইবাদত নিজে থেকেই ভালো',
    'Bid‘ah is better than Sunnah if people like it':
        'মানুষ পছন্দ করলে বিদআত সুন্নাহর চেয়ে ভালো',
    'No worship needs evidence': 'কোনো ইবাদতের প্রমাণ লাগে না',

    'How should Muslims show love for the Prophet ﷺ?':
        'মুসলিমরা রাসূল ﷺ-এর প্রতি ভালোবাসা কীভাবে দেখাবে?',
    'By following his Sunnah and obeying him':
        'তাঁর সুন্নাহ অনুসরণ ও তাঁর আনুগত্যের মাধ্যমে',
    'By inventing yearly religious celebrations he did not teach':
        'তিনি শেখাননি এমন বার্ষিক ধর্মীয় উৎসব বানিয়ে',
    'By singing at graves and ignoring his commands':
        'কবরে গান গেয়ে ও তাঁর নির্দেশ অমান্য করে',
    'By loving him with words but leaving his Sunnah':
        'মুখে ভালোবাসা দেখিয়ে কিন্তু সুন্নাহ ছেড়ে দিয়ে',
  });
}

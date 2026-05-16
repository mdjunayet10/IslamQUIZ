# IslamQUIZ

**IslamQUIZ** is a premium Islamic quiz app for learning the foundations of correct aqeedah through multiple-choice questions, simple explanations, and evidence from the Qur’an and authentic Sunnah.

The app is designed for Web and mobile using Flutter. It begins with the most important aqeedah foundations, such as where Allah is, Allah’s Names and Attributes, the Qur’an as Allah’s Speech, Tawheed, shirk, Salah, the way of the Salaf, sects and mistakes, and the danger of bid‘ah.

---

## Author

**Md Junayet**

---

## Project Purpose

IslamQUIZ helps users learn correct aqeedah in a clear and structured way. After each answer, the app shows:

- the correct answer
- exact quoted evidence with verse or hadith number
- a simple explanation
- a common mistake to avoid
- a clear warning label for the incorrect belief or group connected to the wrong answers

The app is educational. It explains belief errors firmly but avoids reckless takfir or attacking individuals.

---

## Core Beliefs of Correct Aqeedah

IslamQUIZ is based on the aqeedah of Ahlus-Sunnah wal-Jama‘ah upon the understanding of the Salaf.

Core beliefs include:

1. Allah alone is the Creator, Owner, Provider, and Controller of everything.
2. Allah alone deserves all worship, including prayer, du‘a, sacrifice, hope, fear, reliance, and love.
3. Shirk is the greatest sin, and worship must never be directed to other than Allah.
4. Allah has the most beautiful Names and perfect Attributes.
5. Allah’s Names and Attributes are affirmed as they came in the Qur’an and authentic Sunnah, without changing the meaning, denying them, asking how, or comparing Allah to creation.
6. Allah is above His creation, over the Throne, in a way that suits His Majesty.
7. The Qur’an is the uncreated Speech of Allah.
8. Muhammad ﷺ is the final Messenger, and true guidance is in following his Sunnah.
9. Correct understanding is based on the Qur’an, authentic Sunnah, and the understanding of the Companions and early righteous generations.
10. Iman is belief in the heart, speech of the tongue, and actions of the limbs. It increases with obedience and decreases with sin.
11. Muslims believe in Allah, His angels, His books, His messengers, the Last Day, and qadar, both its good and its bad.
12. The Resurrection, judgment, Scale, Bridge, Paradise, Hellfire, and the believers seeing Allah in the Hereafter are real.
13. Ahlus-Sunnah love and honor all Companions. The best of this Ummah after the Prophet ﷺ are Abu Bakr, Umar, Uthman, then Ali رضي الله عنهم.
14. Worship must be sincere for Allah and according to the Sunnah. Invented worship is rejected.
15. Major sins are dangerous, but specific people are not declared outside Islam without clear proof, conditions, and removal of excuses by qualified people.
16. Muslims obey Muslim rulers in what is lawful, do not obey sin, and avoid rebellion that causes greater harm and fitnah.

---

### Evidence Wording Rule

The quiz evidence boxes should not paraphrase Qur’an verses or hadith texts. They should show:

- the reference number
- exact quoted wording from the selected English translation or hadith translation
- any explanation separately under “Simple explanation”

Current Qur’an English wording uses named modern English translation excerpts instead of older archaic English. Hadith evidence uses named hadith collections and quoted text excerpts. Before public release, verify every quote against the Arabic source and a reliable printed or scholarly checked edition. Do not treat automatic or app-level wording as a final religious verification.


### Hadith Source Style

Hadith evidence is displayed in a simple source-card format:

- **Hadith source:** collection name and hadith number
- **Sunnah.com lookup:** a short lookup reference where the numbering matches Sunnah.com-style references
- **Narrator/topic:** a short note to help the learner understand what the hadith is about
- **Quoted translation:** quoted wording only, not the app author's paraphrase
- **Arabic wording when needed:** short Arabic phrases may be included for sensitive aqeedah texts so reviewers can check the exact wording

Qur’an and hadith wording should be reviewed before public release. Explanations must stay outside the evidence box so users can separate quoted evidence from teaching notes. For sensitive translations, choose one clear named rendering and keep the Arabic phrase visible for review.

---

### Language Support

IslamQUIZ includes a small language button in the top corner.

- In English mode, the button shows **বাংলা**.
- In Bangla mode, the button shows **English**.
- Tapping it switches the app language and saves the choice on the device.
- Core UI, quiz labels, categories, many question texts, explanations, and warning labels are translated for Bangla mode.
- Qur’an and hadith evidence quotes are kept as selected named translations/Arabic excerpts so they are not accidentally paraphrased by the app. Bangla explanations are kept outside the evidence quote area.


## Features

- Premium dark green, navy, and gold UI
- Top-corner language switch: English ⇄ Bangla
- Web/PWA logo and in-app logo
- Flutter Web and Android-ready codebase
- 38 starter questions
- Essential Foundations quiz mode
- Full Quiz mode
- Category-based quizzes
- Mistake Review mode
- Core Beliefs teaching section
- Shuffled answer choices every quiz
- References are shown in clearer cards with collection, number, lookup label, narrator/topic, Arabic text where needed, and quoted translation where available
- Local progress saving with `shared_preferences`
- Saves:
  - Level
  - Total XP
  - Completed quizzes
  - Completed questions
  - Best score
  - Mistakes for review

---

## Main Categories

- Core Beliefs
- Names & Attributes
- Qur’an and Allah’s Speech
- Tawheed of Worship
- Tawheed of Lordship
- Iman, Salah & Major Sins
- Qadar
- Salaf & Sects
- Sunnah vs Bid‘ah
- Hereafter

---

## Tech Stack

- Flutter
- Dart
- shared_preferences
- Material 3

---

## Run on Web

```bash
cd IslamQUIZ
flutter pub get
flutter run -d chrome
```

Build the web release:

```bash
flutter build web --release
```

The web build will be inside:

```bash
build/web
```

---

## Run on Android

Create Android platform files if needed:

```bash
flutter create . --platforms=android,web
flutter pub get
```

Run on a connected Android device or emulator:

```bash
flutter devices
flutter run -d <device_id>
```

Build APK:

```bash
flutter build apk --release
```

APK output:

```bash
build/app/outputs/flutter-apk/app-release.apk
```

---

## App Logo / Launcher Icons

The project includes an IslamQUIZ logo at:

```bash
assets/logo/islamquiz_logo.png
```

Web icons are already included in:

```bash
web/favicon.png
web/icons/
```

For Android/iOS launcher icons after platform files are created, run:

```bash
dart run flutter_launcher_icons
```

---

## Religious Content Review Notice

This project deals with serious Islamic topics. Before publishing publicly, all questions, explanations, translations, hadith references, and wording should be reviewed by qualified people of knowledge or trusted students of knowledge.

The app should remain firm upon correct aqeedah while avoiding careless takfir, personal attacks, or unclear sectarian wording.

---

## License

This project is released under the **MIT License**.

Anyone may use, copy, modify, merge, publish, distribute, sublicense, and sell copies of this project, as long as the copyright and license notice are included.

See the [`LICENSE`](LICENSE) file for details.

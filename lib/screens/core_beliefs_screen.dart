import 'package:flutter/material.dart';

import '../services/language_service.dart';
import '../theme/app_theme.dart';
import '../widgets/app_logo.dart';
import '../widgets/premium_card.dart';
import '../widgets/premium_scaffold.dart';

class CoreBeliefsScreen extends StatelessWidget {
  const CoreBeliefsScreen({super.key});

  static const List<_CoreBelief> _beliefs = [
    _CoreBelief(
      title: 'Allah alone is the Creator and Controller',
      text:
          'Allah created everything, owns everything, provides for all creation, and nothing happens except by His will and decree.',
      reference:
          'Qur’an 39:62 (Saheeh International): “Allah is the Creator of all things, and He is, over all things, Disposer of affairs.”',
    ),
    _CoreBelief(
      title: 'Allah alone deserves worship',
      text:
          'Prayer, du‘a, sacrifice, hope, fear, reliance, love, and all acts of worship must be for Allah alone.',
      reference:
          'Qur’an 4:36 (Saheeh International): “Worship Allah and associate nothing with Him.”',
    ),
    _CoreBelief(
      title: 'Shirk is the greatest sin',
      text:
          'Directing worship to other than Allah is shirk. A Muslim must learn Tawheed and stay away from shirk and its paths.',
      reference:
          'Qur’an 4:48 (Saheeh International): “Indeed, Allah does not forgive association with Him, but He forgives what is less than that for whom He wills.”',
    ),
    _CoreBelief(
      title: 'Allah’s Names and Attributes are perfect',
      text:
          'We affirm what Allah affirmed for Himself and what the Messenger ﷺ affirmed, without changing the meaning, denying, asking how, or comparing Allah to creation.',
      reference:
          'Qur’an 42:11 (The Clear Quran): “There is nothing like Him, for He ˹alone˺ is the All-Hearing, All-Seeing.”',
    ),
    _CoreBelief(
      title: 'Allah is above His creation',
      text:
          'Allah is above His creation, over the Throne, in a way that suits His Majesty. He is with His creation by His knowledge, hearing, seeing, and power.',
      reference:
          'Qur’an 20:5 (Hilali and Khan): “The Most Gracious (Allâh) rose over (Istawâ) the (Mighty) Throne (in a manner that suits His Majesty).”',
    ),
    _CoreBelief(
      title: 'The Qur’an is Allah’s Speech',
      text:
          'The Qur’an is the uncreated Speech of Allah. Allah truly speaks, and His Speech is not like the speech of creation.',
      reference:
          'Qur’an 9:6 (Saheeh International): “until he hears the words of Allah.”',
    ),
    _CoreBelief(
      title: 'Follow the Prophet ﷺ and the Salaf',
      text:
          'Correct understanding is based on the Qur’an, authentic Sunnah, and the understanding of the Companions and the early righteous generations.',
      reference:
          'Hadith source: Sahih al-Bukhari 3651 — Sunnah.com lookup: Bukhari 3651\nNarrator/topic: Virtue of the earliest generations.\nQuoted translation: “The best of my followers are those living in my generation and then those who will follow the latter.”\nHadith source: Sahih Muslim 2533 — Sunnah.com lookup: Muslim 2533\nNarrator/topic: Virtue of the earliest generations.\nQuoted translation: “The best of my Umma would be those of the generation nearest to mine. Then those nearest to them, then those nearest to them.”',
    ),
    _CoreBelief(
      title: 'Iman includes belief, speech, and action',
      text:
          'Iman is belief in the heart, speech of the tongue, and actions of the limbs. It increases with obedience and decreases with sin.',
      reference:
          'Qur’an 8:2 (Saheeh International): “and when His verses are recited to them, it increases them in faith.”',
    ),
    _CoreBelief(
      title: 'Believe in the six pillars of iman',
      text:
          'A Muslim believes in Allah, His angels, His books, His messengers, the Last Day, and qadar, both its good and its bad.',
      reference:
          'Hadith source: Sahih Muslim 8a — Sunnah.com lookup: Muslim 8a\nNarrator/topic: Hadith of Jibril about iman.\nQuoted translation: “It is that you believe in Allah and His angels and His Books and His Messengers and in the Last Day and in qadar (fate), both in its good and in its evil aspects.”',
    ),
    _CoreBelief(
      title: 'The Hereafter is real',
      text:
          'The Resurrection, judgment, Scale, Bridge, Paradise, Hellfire, and the believers seeing Allah are real.',
      reference:
          'Qur’an 75:22-23 (Saheeh International): “[Some] faces, that Day, will be radiant, Looking at their Lord.”\nHadith source: Sahih al-Bukhari 7434 — Sunnah.com lookup: Bukhari 7434\nNarrator/topic: Believers seeing Allah on the Day of Resurrection.\nQuoted translation: “You will see your Lord as you see this moon, and you will have no trouble in seeing Him.”',
    ),
    _CoreBelief(
      title: 'Love and honor the Companions',
      text:
          'Ahlus-Sunnah love all the Companions. The best of this Ummah after the Prophet ﷺ are Abu Bakr, Umar, Uthman, then Ali رضي الله عنهم.',
      reference:
          'Qur’an 9:100 (Saheeh International): “And the first forerunners [in the faith] among the Muhajireen and the Ansar and those who followed them with good conduct - Allah is pleased with them.”\nHadith source: Sahih al-Bukhari 3673 — Sunnah.com lookup: Bukhari 3673\nNarrator/topic: Warning against abusing the Companions.\nQuoted translation: “Do not abuse my companions.”\nHadith source: Sahih Muslim 2540 — Sunnah.com lookup: Muslim 2540\nNarrator/topic: Warning against reviling the Companions.\nQuoted translation: “Do not revile my Companions.”',
    ),
    _CoreBelief(
      title: 'Avoid bid‘ah in religion',
      text:
          'Islam is complete. Worship must be sincere for Allah and according to the Sunnah. Good intention does not make invented worship correct.',
      reference:
          'Qur’an 5:3 (Saheeh International): “This day I have perfected for you your religion and completed My favor upon you and have approved for you Islam as religion.”\nHadith source: Sahih Muslim 867 — Sunnah.com lookup: Muslim 867\nNarrator/topic: The Prophet’s guidance is the best guidance.\nQuoted translation: “The best guidance is the guidance given by Muhammad.”\nHadith source: Sahih Muslim 1718 — Sunnah.com lookup: Muslim 1718\nNarrator/topic: Rejection of invented religious actions.\nQuoted translation: “He who did any act for which there is no sanction from our behalf, that is to be rejected.”',
    ),
    _CoreBelief(
      title: 'Avoid reckless takfir',
      text:
          'Major sins are dangerous, but specific people are not declared outside Islam without clear proof, conditions, and removal of excuses by qualified people.',
      reference:
          'Qur’an 4:48 (Saheeh International): “Indeed, Allah does not forgive association with Him, but He forgives what is less than that for whom He wills.”\nQur’an 49:10 (Saheeh International): “The believers are but brothers.”',
    ),
    _CoreBelief(
      title: 'Obey Muslim rulers in what is lawful',
      text:
          'Ahlus-Sunnah obey in what is lawful, do not obey sin, advise with wisdom, and avoid rebellion that causes greater harm and fitnah.',
      reference:
          'Qur’an 4:59 (Saheeh International): “O you who have believed, obey Allah and obey the Messenger and those in authority among you.”\nHadith source: Sahih al-Bukhari 7056 — Sunnah.com lookup: Bukhari 7056\nNarrator/topic: Obedience to rulers and the condition of clear disbelief.\nQuoted translation: “unless you see clear disbelief, for which you have proof from Allah.”',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return PremiumScaffold(
      title: context.t('Core Beliefs'),
      subtitle: context.isBangla
          ? 'সঠিক আকীদাহর সহজ সারাংশ'
          : 'A simple summary of correct aqeedah',
      child: ListView(
        children: [
          PremiumCard(
            padding: const EdgeInsets.all(22),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppLogo(size: 64),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          context.isBangla
                              ? 'সঠিক আকীদাহর মূল বিশ্বাস'
                              : 'Core Beliefs of Correct Aqeedah',
                          style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Text(
                        context.isBangla
                            ? 'এটি শেখার জন্য সংক্ষিপ্ত সারাংশ। প্রমাণের ঘরে আয়াত বা হাদীসের উদ্ধৃতি দেখানো হয়, ব্যাখ্যা আলাদা থাকে।'
                            : 'This section is a learning summary. Evidence boxes quote verse or hadith wording instead of paraphrasing it.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ...List.generate(_beliefs.length, (index) {
            final belief = _beliefs[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: PremiumCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppTheme.gold.withOpacity(0.14),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: AppTheme.gold.withOpacity(0.25)),
                          ),
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                                color: AppTheme.softGold,
                                fontWeight: FontWeight.w900),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                            child: Text(context.t(belief.title),
                                style:
                                    Theme.of(context).textTheme.titleMedium)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(context.t(belief.text),
                        style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.gold.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(16),
                        border:
                            Border.all(color: AppTheme.gold.withOpacity(0.18)),
                      ),
                      child: SelectableText(
                        context.referenceText(belief.reference),
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: AppTheme.softGold),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _CoreBelief {
  final String title;
  final String text;
  final String reference;

  const _CoreBelief({
    required this.title,
    required this.text,
    required this.reference,
  });
}

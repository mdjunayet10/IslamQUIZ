import '../models/aqeedah_question.dart';

const List<String> aqeedahCategories = [
  "Core Beliefs",
  "Names & Attributes",
  "Qur’an and Allah’s Speech",
  "Tawheed of Worship",
  "Tawheed of Lordship",
  "Iman, Salah & Major Sins",
  "Qadar",
  "Salaf & Sects",
  "Sunnah vs Bid‘ah",
  "Hereafter",
];

const List<AqeedahQuestion> aqeedahQuestions = [
  AqeedahQuestion(
    id: "attributes_where_001",
    category: "Names & Attributes",
    difficulty: "Essential",
    question: "Where is Allah?",
    options: [
      "Allah is above His creation, over the Throne, in a way that suits His Majesty",
      "Allah is everywhere with His Essence",
      "Allah is inside creation or mixed with creation",
      "The verses about Allah being above should be denied",
    ],
    correctIndex: 0,
    correctAnswer:
        "Allah is above His creation, over the Throne, in a way that suits His Majesty",
    reference:
        "Qur’an 20:5 (Hilali and Khan): “The Most Gracious (Allâh) rose over (Istawâ) the (Mighty) Throne (in a manner that suits His Majesty).”\nQur’an 67:16 (Hilali and Khan): “Do you feel secure that He, Who is over the heaven (Allâh), will not cause the earth to sink with you, and then it should quake?”\nHadith source: Sahih Muslim 537a — Sunnah.com lookup: Muslim 537a\nNarrator/topic: Mu‘awiyah ibn al-Hakam رضي الله عنه; the Prophet ﷺ asked the slave girl about Allah.\nArabic wording: «أَيْنَ اللهُ؟» قَالَتْ: «فِي السَّمَاءِ»\nQuoted English rendering used in IslamQUIZ: “He said to her: Where is Allah? She said: Above the heavens. He said: Who am I? She said: You are the Messenger of Allah. He said: Free her, for she is a believer.”",
    explanation:
        "Ahlus-Sunnah affirm that Allah is above His creation and over the Throne. We believe this as Allah said, without asking how and without comparing Allah to creation.",
    commonMistake:
        "A common mistake is saying Allah is everywhere with His Essence. Allah is with His creation by His knowledge, hearing, seeing, and power.",
    relatedBeliefGroup:
        "Wrong belief/group names: Jahmiyyah, Mu‘tazilah, Ash‘ari/Maturidi ta’wil tendency, Hulul/Ittihad-style ideas. Wrong belief: denying Allah’s highness, saying Allah is everywhere with His Essence, or explaining away the texts without proof.",
  ),
  AqeedahQuestion(
    id: "attributes_001",
    category: "Names & Attributes",
    difficulty: "Essential",
    question: "What is the correct belief about Allah’s Names and Attributes?",
    options: [
      "Affirm what Allah and His Messenger ﷺ affirmed, without changing the meaning, denying it, asking how, or comparing Allah to creation",
      "Deny the Attributes to avoid any resemblance",
      "Explain away every Attribute by default",
      "Imagine Allah’s Attributes like human attributes",
    ],
    correctIndex: 0,
    correctAnswer:
        "Affirm what Allah and His Messenger ﷺ affirmed, without changing the meaning, denying it, asking how, or comparing Allah to creation",
    reference:
        "Qur’an 42:11 (The Clear Quran): “There is nothing like Him, for He ˹alone˺ is the All-Hearing, All-Seeing.”\nQur’an 7:180 (Saheeh International): “And to Allah belong the best names, so invoke Him by them.”",
    explanation:
        "This verse teaches both truths together: Allah is not like creation, and Allah truly has perfect Attributes such as hearing and seeing.",
    commonMistake:
        "Some people deny Attributes, while others imagine them like creation. Both are wrong.",
    relatedBeliefGroup:
        "Wrong belief/group names: Jahmiyyah, Mu‘tazilah, Ash‘ari/Maturidi ta’wil tendency, Mushabbihah. Wrong belief: denying Attributes, changing meanings without proof, or comparing Allah to creation.",
  ),
  AqeedahQuestion(
    id: "attributes_002",
    category: "Names & Attributes",
    difficulty: "Essential",
    question: "What should we say about Allah rising over the Throne?",
    options: [
      "Allah rose over the Throne in a way that suits His Majesty",
      "Allah is like a created body sitting on a chair",
      "Allah is everywhere with His Essence",
      "The verse should be rejected",
    ],
    correctIndex: 0,
    correctAnswer: "Allah rose over the Throne in a way that suits His Majesty",
    reference:
        "Qur’an 20:5 (Hilali and Khan): “The Most Gracious (Allâh) rose over (Istawâ) the (Mighty) Throne (in a manner that suits His Majesty).”\nQur’an 7:54 (Saheeh International): “Then He established Himself above the Throne.”\nScholar statement: Reported from Imam Malik رحمه الله\nQuoted text: “The rising is known, the how is unknown, belief in it is obligatory, and asking about it is an innovation.”",
    explanation:
        "The Salaf accepted the wording of revelation. They did not deny it and they did not imagine how it is.",
    commonMistake:
        "One mistake is denying the Attribute. Another mistake is imagining a created form.",
    relatedBeliefGroup:
        "Wrong belief/group names: Jahmiyyah, Mu‘tazilah, Ash‘ari/Maturidi ta’wil tendency, Mushabbihah. Wrong belief: denying Allah rising over the Throne, changing its meaning without proof, or imagining it like creation.",
  ),
  AqeedahQuestion(
    id: "attributes_003",
    category: "Names & Attributes",
    difficulty: "Essential",
    question:
        "When we do not know the exact “how” of an Attribute of Allah, what should we do?",
    options: [
      "Believe the text and leave the exact how to Allah",
      "Invent a picture in the mind",
      "Deny the Attribute completely",
      "Say the Prophet ﷺ did not explain belief clearly",
    ],
    correctIndex: 0,
    correctAnswer: "Believe the text and leave the exact how to Allah",
    reference:
        "Qur’an 42:11 (The Clear Quran): “There is nothing like Him, for He ˹alone˺ is the All-Hearing, All-Seeing.”\nQur’an 3:7 (Saheeh International): “But those in whose hearts is deviation [from truth] will follow that of it which is unspecific, seeking discord and seeking an interpretation [suitable to them].”",
    explanation:
        "Allah told us what to believe, but He did not tell us the exact reality of His Attributes. So we stop where revelation stops.",
    commonMistake:
        "A common mistake is trying to imagine how Allah’s Attributes are.",
    relatedBeliefGroup:
        "Wrong belief/group names: Jahmiyyah, Mu‘tazilah, Mushabbihah. Wrong belief: guessing the exact how of Allah’s Attributes, or denying them because of human imagination.",
  ),
  AqeedahQuestion(
    id: "hereafter_seeing_allah_001",
    category: "Names & Attributes",
    difficulty: "Essential",
    question: "Will the believers see Allah in the Hereafter?",
    options: [
      "Yes, the believers will see Allah in a way that suits His Majesty",
      "No, seeing Allah is impossible in every way",
      "Only angels can see Allah",
      "It only means seeing a created sign",
    ],
    correctIndex: 0,
    correctAnswer:
        "Yes, the believers will see Allah in a way that suits His Majesty",
    reference:
        "Qur’an 75:22-23 (Saheeh International): “[Some] faces, that Day, will be radiant, Looking at their Lord.”\nHadith source: Sahih al-Bukhari 7434 — Sunnah.com lookup: Bukhari 7434\nNarrator/topic: Hadith about the believers seeing Allah on the Day of Resurrection.\nQuoted translation: “You will see your Lord as you see this moon, and you will have no trouble in seeing Him.”\nHadith source: Sahih Muslim 633 — Sunnah.com lookup: Muslim 633\nNarrator/topic: Hadith about seeing Allah and preserving the prayers.\nQuoted translation: “You will see your Lord as you are seeing this moon, and you will not be harmed by seeing Him.”",
    explanation:
        "Ahlus-Sunnah believe that seeing Allah in the Hereafter is real. This does not mean Allah resembles creation.",
    commonMistake:
        "Some deny this because they put human reasoning above clear texts.",
    relatedBeliefGroup:
        "Wrong belief/group names: Jahmiyyah, Mu‘tazilah. Wrong belief: denying that believers will see Allah in the Hereafter.",
  ),
  AqeedahQuestion(
    id: "quran_speech_001",
    category: "Qur’an and Allah’s Speech",
    difficulty: "Essential",
    question: "What is the correct belief about the Qur’an?",
    options: [
      "The Qur’an is the uncreated Speech of Allah",
      "The Qur’an is created like ordinary human speech",
      "The meaning is from Allah but the wording is from people",
      "The Qur’an is not truly Allah’s Speech",
    ],
    correctIndex: 0,
    correctAnswer: "The Qur’an is the uncreated Speech of Allah",
    reference:
        "Qur’an 9:6 (Saheeh International): “until he hears the words of Allah.”\nQur’an 4:164 (Saheeh International): “And Allah spoke to Moses with [direct] speech.”",
    explanation:
        "Allah truly speaks, and the Qur’an is His Speech. It was revealed by Allah and is not created.",
    commonMistake:
        "A common mistake is saying Allah does not truly speak, or that the Qur’an is created.",
    relatedBeliefGroup:
        "Wrong belief/group names: Jahmiyyah and Mu‘tazilah. Wrong belief: saying the Qur’an is created or denying that Allah truly speaks.",
  ),
  AqeedahQuestion(
    id: "quran_musa_001",
    category: "Qur’an and Allah’s Speech",
    difficulty: "Beginner",
    question: "What does the Qur’an say about Musa عليه السلام?",
    options: [
      "Allah spoke to Musa directly",
      "Musa only imagined speech",
      "Only an angel spoke and Allah did not speak",
      "Allah cannot speak in any real sense",
    ],
    correctIndex: 0,
    correctAnswer: "Allah spoke to Musa directly",
    reference:
        "Qur’an 4:164 (Saheeh International): “And Allah spoke to Moses with [direct] speech.”\nQur’an 7:143 (Saheeh International): “And when Moses arrived at Our appointed time and his Lord spoke to him.”",
    explanation:
        "Ahlus-Sunnah affirm what the Qur’an says: Allah spoke to Musa. We do not compare Allah’s Speech to created speech.",
    commonMistake:
        "Some people deny real divine speech because of philosophy, not because of revelation.",
    relatedBeliefGroup:
        "Wrong belief/group names: Jahmiyyah and Mu‘tazilah. Wrong belief: denying that Allah truly spoke to Musa عليه السلام.",
  ),
  AqeedahQuestion(
    id: "uluhiyyah_001",
    category: "Tawheed of Worship",
    difficulty: "Essential",
    question: "Why did Allah create jinn and mankind?",
    options: [
      "To worship Allah alone",
      "To worship righteous people through graves",
      "To only know Allah exists without worshipping Him",
      "To follow any religion sincerely",
    ],
    correctIndex: 0,
    correctAnswer: "To worship Allah alone",
    reference:
        "Qur’an 51:56 (Saheeh International): “And I did not create the jinn and mankind except to worship Me.”",
    explanation:
        "The main purpose of life is worshipping Allah alone. Worship includes prayer, du‘a, sacrifice, hope, fear, love, reliance, and obedience.",
    commonMistake:
        "Some people think believing Allah is the Creator is enough, even if worship is directed to others.",
    relatedBeliefGroup:
        "Wrong belief/group names: Shirk practices, grave worship, extreme saint-veneration. Wrong belief: directing worship to other than Allah.",
  ),
  AqeedahQuestion(
    id: "dua_001",
    category: "Tawheed of Worship",
    difficulty: "Essential",
    question: "Who should we call upon in du‘a?",
    options: [
      "Allah alone",
      "Dead saints for unseen needs",
      "Angels independently",
      "Jinn when humans cannot help",
    ],
    correctIndex: 0,
    correctAnswer: "Allah alone",
    reference:
        "Qur’an 72:18 (Saheeh International): “And [He revealed] that the masjids are for Allah, so do not invoke with Allah anyone.”\nQur’an 40:60 (Saheeh International): “And your Lord says, ‘Call upon Me; I will respond to you.’”\nHadith source: Sunan Abi Dawud 1479 — Sunnah.com lookup: Abu Dawud 1479\nNarrator/topic: The Prophet ﷺ explained the status of du‘a.\nQuoted translation: “Supplication is worship.”",
    explanation:
        "Du‘a is worship, and worship belongs to Allah alone. A living person may be asked for normal help they are able to give.",
    commonMistake:
        "Calling upon the dead or absent for rescue in matters only Allah controls is a major violation of Tawheed.",
    relatedBeliefGroup:
        "Wrong belief/group names: Grave worship, extreme saint-veneration, calling upon the dead. Wrong belief: making du‘a to anyone besides Allah for what only Allah controls.",
  ),
  AqeedahQuestion(
    id: "shirk_001",
    category: "Tawheed of Worship",
    difficulty: "Essential",
    question: "What is the greatest sin?",
    options: [
      "Shirk: worshipping others along with Allah",
      "Minor mistakes in daily habits",
      "Forgetting a voluntary prayer",
      "Being poor",
    ],
    correctIndex: 0,
    correctAnswer: "Shirk: worshipping others along with Allah",
    reference:
        "Qur’an 4:48 (Saheeh International): “Indeed, Allah does not forgive association with Him, but He forgives what is less than that for whom He wills.”\nQur’an 31:13 (Saheeh International): “Indeed, association [with him] is great injustice.”",
    explanation:
        "Shirk is the greatest sin because it gives worship to other than Allah.",
    commonMistake:
        "Some people treat major shirk as only culture or respect, even when acts of worship are directed to others.",
    relatedBeliefGroup:
        "Wrong belief/group names: Shirk practices, grave worship, extreme saint-veneration. Wrong belief: relying on created beings in matters only Allah controls.",
  ),
  AqeedahQuestion(
    id: "worship_help_001",
    category: "Tawheed of Worship",
    difficulty: "Beginner",
    question:
        "What does “You alone we worship and You alone we ask for help” teach?",
    options: [
      "Worship and ultimate help are sought from Allah alone",
      "Worship can be shared with righteous people",
      "Du‘a to others is only disliked",
      "Only prayer is worship, not du‘a",
    ],
    correctIndex: 0,
    correctAnswer: "Worship and ultimate help are sought from Allah alone",
    reference:
        "Qur’an 1:5 (Saheeh International): “It is You we worship and You we ask for help.”",
    explanation:
        "This verse is a foundation of Tawheed. Worship and the help only Allah controls belong to Allah alone.",
    commonMistake:
        "A common mistake is separating du‘a, sacrifice, hope, and fear from worship.",
    relatedBeliefGroup:
        "Wrong belief/group names: Incorrect Tawheed understanding. Wrong belief: limiting worship to prayer only and forgetting du‘a, sacrifice, fear, hope, reliance, and obedience.",
  ),
  AqeedahQuestion(
    id: "sacrifice_001",
    category: "Tawheed of Worship",
    difficulty: "Intermediate",
    question:
        "What is the ruling of sacrificing as worship for other than Allah?",
    options: [
      "It is shirk because sacrifice as worship belongs to Allah",
      "It is allowed if the person was righteous",
      "It is only culture and never worship",
      "It is allowed near graves for blessings",
    ],
    correctIndex: 0,
    correctAnswer: "It is shirk because sacrifice as worship belongs to Allah",
    reference:
        "Qur’an 6:162-163 (Saheeh International): “Indeed, my prayer, my rites of sacrifice, my living and my dying are for Allah, Lord of the worlds. No partner has He.”\nHadith source: Sahih Muslim 1978 — Sunnah.com lookup: Muslim 1978\nNarrator/topic: Warning against sacrifice for anyone besides Allah.\nQuoted translation: “Allah cursed him who sacrificed for anyone besides Allah.”",
    explanation:
        "Sacrifice done as worship, devotion, or seeking nearness must be for Allah alone.",
    commonMistake:
        "Some people treat sacrificial devotion to graves or spirits as harmless culture.",
    relatedBeliefGroup:
        "Wrong belief/group names: Shirk practices and grave-related worship. Wrong belief: sacrificing or making worship for anyone besides Allah.",
  ),
  AqeedahQuestion(
    id: "rububiyyah_001",
    category: "Tawheed of Lordship",
    difficulty: "Beginner",
    question: "Who is the Creator, Owner, and Controller of everything?",
    options: [
      "Allah alone",
      "The angels independently",
      "Righteous people after death",
      "Nature without Allah’s decree",
    ],
    correctIndex: 0,
    correctAnswer: "Allah alone",
    reference:
        "Qur’an 39:62 (Saheeh International): “Allah is the Creator of all things, and He is, over all things, Disposer of affairs.”\nQur’an 10:31 (Saheeh International): “Say, ‘Who provides for you from the heaven and the earth? Or who controls hearing and sight?’”",
    explanation:
        "Allah alone created everything and controls provision, life, death, and command.",
    commonMistake:
        "Some affirm Allah as Creator but still believe created beings independently control benefit and harm.",
    relatedBeliefGroup:
        "Wrong belief/group names: Superstition, fortune-telling, belief in independent hidden powers. Wrong belief: thinking created beings control the unseen independently from Allah.",
  ),
  AqeedahQuestion(
    id: "qadar_001",
    category: "Qadar",
    difficulty: "Beginner",
    question: "Does anything happen outside Allah’s will and decree?",
    options: [
      "No, nothing happens except by Allah’s will and decree",
      "Yes, some events defeat Allah’s will",
      "Only good things are decreed by Allah",
      "Humans create their actions independently of Allah",
    ],
    correctIndex: 0,
    correctAnswer: "No, nothing happens except by Allah’s will and decree",
    reference:
        "Qur’an 54:49 (Saheeh International): “Indeed, all things We created with predestination.”\nQur’an 57:22 (Saheeh International): “No disaster strikes upon the earth or among yourselves except that it is in a register before We bring it into being.”",
    explanation:
        "Ahlus-Sunnah believe Allah knew, wrote, willed, and created all things with perfect wisdom and justice.",
    commonMistake:
        "Some deny qadar, while others use qadar as an excuse to abandon responsibility.",
    relatedBeliefGroup:
        "Wrong belief/group names: Qadariyyah and Jabriyyah. Wrong belief: denying qadar, or using qadar to cancel human responsibility.",
  ),
  AqeedahQuestion(
    id: "qadar_choice_001",
    category: "Qadar",
    difficulty: "Intermediate",
    question: "How should a Muslim understand human choice?",
    options: [
      "Humans have a real will, but it is under Allah’s will",
      "Humans force Allah’s will",
      "Humans have no will in any sense",
      "Allah does not know choices until after they happen",
    ],
    correctIndex: 0,
    correctAnswer: "Humans have a real will, but it is under Allah’s will",
    reference:
        "Qur’an 76:30 (Saheeh International): “And you do not will except that Allah wills. Indeed, Allah is ever Knowing and Wise.”\nQur’an 81:29 (Saheeh International): “And you do not will except that Allah wills - Lord of the worlds.”",
    explanation:
        "The Qur’an affirms that people choose, while making their will under Allah’s will.",
    commonMistake:
        "One mistake makes humans independent from Allah. Another mistake removes human responsibility completely.",
    relatedBeliefGroup:
        "Wrong belief/group names: Qadariyyah and Jabriyyah. Wrong belief: denying Allah’s will and decree, or denying human choice and responsibility.",
  ),
  AqeedahQuestion(
    id: "iman_001",
    category: "Iman, Salah & Major Sins",
    difficulty: "Essential",
    question: "What is iman according to Ahlus-Sunnah?",
    options: [
      "Belief in the heart, speech of the tongue, and actions of the limbs",
      "Only knowledge in the heart",
      "Only saying the shahadah without heart belief or action",
      "Only good manners with no belief requirement",
    ],
    correctIndex: 0,
    correctAnswer:
        "Belief in the heart, speech of the tongue, and actions of the limbs",
    reference:
        "Qur’an 8:2 (Saheeh International): “and when His verses are recited to them, it increases them in faith.”\nHadith source: Sahih Muslim 35 — Sunnah.com lookup: Muslim 35\nNarrator/topic: The branches of faith.\nQuoted translation: “Faith has over seventy branches or over sixty branches, the most excellent of which is the declaration that there is no god but Allah, and the humblest of which is the removal of what is injurious from the path.”",
    explanation:
        "Iman includes the heart, the tongue, and actions. It increases with obedience and decreases with sin.",
    commonMistake: "Some separate actions from iman completely.",
    relatedBeliefGroup:
        "Wrong belief/group names: Murji’ah. Wrong belief: separating actions from iman or saying sins do not affect iman.",
  ),
  AqeedahQuestion(
    id: "iman_002",
    category: "Iman, Salah & Major Sins",
    difficulty: "Beginner",
    question: "Does iman increase and decrease?",
    options: [
      "Yes, it increases with obedience and decreases with sin",
      "No, everyone’s iman is exactly equal",
      "It only decreases but never increases",
      "Actions have no connection to iman",
    ],
    correctIndex: 0,
    correctAnswer: "Yes, it increases with obedience and decreases with sin",
    reference:
        "Qur’an 48:4 (Saheeh International): “that they would increase in faith along with their [present] faith.”\nQur’an 74:31 (Saheeh International): “and those who have believed will increase in faith.”",
    explanation:
        "The Qur’an clearly mentions increase in faith. Sins are dangerous and obedience strengthens iman.",
    commonMistake:
        "A common mistake is treating iman as one fixed block that is not affected by deeds.",
    relatedBeliefGroup:
        "Wrong belief/group names: Murji’ah. Wrong belief: separating actions from iman or saying sins do not affect iman.",
  ),
  AqeedahQuestion(
    id: "salah_obligation_001",
    category: "Iman, Salah & Major Sins",
    difficulty: "Essential",
    question:
        "What if someone rejects that the five daily prayers are obligatory?",
    options: [
      "Rejecting the obligation of Salah after clear proof takes a person outside Islam",
      "It is only a small mistake",
      "It has no effect on Islam",
      "It is better than praying without focus",
    ],
    correctIndex: 0,
    correctAnswer:
        "Rejecting the obligation of Salah after clear proof takes a person outside Islam",
    reference:
        "Qur’an 4:103 (Saheeh International): “Indeed, prayer has been decreed upon the believers a decree of specified times.”\nHadith source: Sahih al-Bukhari 349 — Sunnah.com lookup: Bukhari 349\nNarrator/topic: The obligation of the five daily prayers.\nQuoted translation: “Allah enjoined fifty prayers on my followers. When I returned with this order of Allah, I passed by Moses who asked me, ‘What has Allah enjoined on your followers?’ I replied, ‘He has enjoined fifty prayers on them.’”",
    explanation:
        "Denying a clear obligation of Islam after proof is not the same as being lazy. It is rejection of what Allah made obligatory.",
    commonMistake:
        "Some confuse laziness in prayer with denying that prayer is obligatory. Both are dangerous, but they are not the same issue.",
    relatedBeliefGroup:
        "Wrong belief/group names: Denial of known obligations after proof. Wrong belief: denying that Salah is obligatory after the proof is clear.",
  ),
  AqeedahQuestion(
    id: "salah_abandon_001",
    category: "Iman, Salah & Major Sins",
    difficulty: "Essential",
    question: "How serious is completely abandoning the five daily prayers?",
    options: [
      "It is extremely dangerous; many scholars held that completely abandoning Salah is major kufr",
      "It is only a small sin",
      "It is allowed if the heart is good",
      "It proves a person has perfect iman",
    ],
    correctIndex: 0,
    correctAnswer:
        "It is extremely dangerous; many scholars held that completely abandoning Salah is major kufr",
    reference:
        "Hadith source: Sahih Muslim 82 — Sunnah.com lookup: Muslim 82\nNarrator/topic: Severe warning about abandoning salah.\nQuoted translation: “Between a man and polytheism and unbelief is the abandonment of salat.”\nHadith source: Jami‘ at-Tirmidhi 2621 — Sunnah.com lookup: Tirmidhi 2621\nNarrator/topic: Severe warning about abandoning salah.\nQuoted translation: “The covenant that is between us and them is the Salat; so whoever abandons it, he has committed disbelief.”",
    explanation:
        "Salah is a pillar of Islam. Completely abandoning it is one of the most dangerous matters. Rulings on specific people require knowledge, proof, conditions, and removal of excuses.",
    commonMistake:
        "A common mistake is treating missed prayers as light or saying the heart is enough without prayer.",
    relatedBeliefGroup:
        "Wrong belief/group names: Murji’ah-type carelessness and neglect of Salah. Wrong belief: treating abandonment of Salah as a small matter.",
  ),
  AqeedahQuestion(
    id: "takfir_balance_001",
    category: "Iman, Salah & Major Sins",
    difficulty: "Intermediate",
    question: "What is the balanced way with Muslims who commit major sins?",
    options: [
      "Major sins are dangerous, but we do not declare a Muslim outside Islam without clear proof and conditions",
      "Every major sinner is automatically outside Islam",
      "Major sins do not harm iman at all",
      "No Muslim can ever be punished for sins",
    ],
    correctIndex: 0,
    correctAnswer:
        "Major sins are dangerous, but we do not declare a Muslim outside Islam without clear proof and conditions",
    reference:
        "Qur’an 4:48 (Saheeh International): “Indeed, Allah does not forgive association with Him, but He forgives what is less than that for whom He wills.”\nQur’an 49:9 (Saheeh International): “And if two factions among the believers should fight, then make settlement between the two.”\nQur’an 49:10 (Saheeh International): “The believers are but brothers.”",
    explanation:
        "Ahlus-Sunnah are balanced. Sins are real and dangerous, but takfir is not made recklessly.",
    commonMistake:
        "Some exaggerate and make takfir for every major sin. Others act as if sins do not matter.",
    relatedBeliefGroup:
        "Wrong belief/group names: Khawarij and Murji’ah. Wrong belief: declaring Muslims outside Islam for every major sin, or treating major sins as harmless.",
  ),
  AqeedahQuestion(
    id: "nullifier_shirk_001",
    category: "Iman, Salah & Major Sins",
    difficulty: "Essential",
    question: "Which action can take a person outside Islam?",
    options: [
      "Worshipping another besides Allah, such as making du‘a to the dead for unseen rescue",
      "Making a normal mistake while trying to obey Allah",
      "Forgetting a Sunnah act",
      "Being from a poor family",
    ],
    correctIndex: 0,
    correctAnswer:
        "Worshipping another besides Allah, such as making du‘a to the dead for unseen rescue",
    reference:
        "Qur’an 4:48 (Saheeh International): “Indeed, Allah does not forgive association with Him, but He forgives what is less than that for whom He wills.”\nQur’an 72:18 (Saheeh International): “And [He revealed] that the masjids are for Allah, so do not invoke with Allah anyone.”",
    explanation:
        "Major shirk in worship contradicts the meaning of Islam. Judging specific people must be left to qualified scholars with proof and conditions.",
    commonMistake:
        "Some treat acts of worship to the dead as only respect or culture.",
    relatedBeliefGroup:
        "Wrong belief/group names: Major shirk. Wrong belief: directing any act of worship to other than Allah.",
  ),
  AqeedahQuestion(
    id: "nullifier_mocking_001",
    category: "Iman, Salah & Major Sins",
    difficulty: "Intermediate",
    question: "What about mocking Allah, His verses, or His Messenger ﷺ?",
    options: [
      "It is a matter that can take a person outside Islam",
      "It is only a joke and never serious",
      "It is allowed if people laugh",
      "It is better than asking questions respectfully",
    ],
    correctIndex: 0,
    correctAnswer: "It is a matter that can take a person outside Islam",
    reference:
        "Qur’an 9:65-66 (Saheeh International): “Say, ‘Is it Allah and His verses and His Messenger that you were mocking?’ Make no excuse; you have disbelieved after your belief.”",
    explanation:
        "The religion must be honored. Mocking Allah, His verses, or the Messenger ﷺ is not like a normal joke.",
    commonMistake: "Some people think joking about sacred matters is harmless.",
    relatedBeliefGroup:
        "Wrong belief/group names: Mocking religion. Wrong belief: mocking Allah, His verses, or His Messenger ﷺ.",
  ),
  AqeedahQuestion(
    id: "nullifier_resurrection_001",
    category: "Hereafter",
    difficulty: "Intermediate",
    question: "What if someone denies the Resurrection after death?",
    options: [
      "Denying the Resurrection is disbelief because it rejects clear Qur’an",
      "It is only a small difference of opinion",
      "It is allowed if someone believes in good character",
      "It is not important in Islam",
    ],
    correctIndex: 0,
    correctAnswer:
        "Denying the Resurrection is disbelief because it rejects clear Qur’an",
    reference:
        "Qur’an 23:15-16 (Saheeh International): “Then indeed, after that you are to die. Then indeed you, on the Day of Resurrection, will be resurrected.”\nQur’an 64:7 (Saheeh International): “Say, ‘Yes, by my Lord, you will surely be resurrected; then you will surely be informed of what you did.’”",
    explanation:
        "Belief in the Hereafter is one of the pillars of iman. The Resurrection is real, not just symbolic.",
    commonMistake:
        "Some modern explanations reduce the Hereafter to symbols or feelings only.",
    relatedBeliefGroup:
        "Wrong belief/group names: Denial of the Hereafter. Wrong belief: rejecting resurrection, judgment, Paradise, or Hellfire.",
  ),
  AqeedahQuestion(
    id: "hereafter_001",
    category: "Hereafter",
    difficulty: "Beginner",
    question: "Which matters of the Hereafter must a Muslim believe in?",
    options: [
      "Resurrection, judgment, the Scale, the Bridge, Paradise, and Hellfire",
      "Only Paradise, not judgment",
      "Reincarnation after death",
      "The Hereafter is only symbolic",
    ],
    correctIndex: 0,
    correctAnswer:
        "Resurrection, judgment, the Scale, the Bridge, Paradise, and Hellfire",
    reference:
        "Qur’an 21:47 (Saheeh International): “And We place the scales of justice for the Day of Resurrection, so no soul will be treated unjustly at all.”\nQur’an 23:15-16 (Saheeh International): “Then indeed, after that you are to die. Then indeed you, on the Day of Resurrection, will be resurrected.”\nHadith source: Sahih Muslim 183 — Sunnah.com lookup: Muslim 183\nNarrator/topic: Hadith about the Bridge over Hell.\nQuoted translation: “Then the bridge would be set over the Hell.”",
    explanation:
        "The Hereafter is real. Allah will resurrect creation and judge everyone with perfect justice.",
    commonMistake:
        "Some deny parts of the Hereafter or treat them as symbols only.",
    relatedBeliefGroup:
        "Wrong belief/group names: Denial of the Hereafter, symbolic-only explanations. Wrong belief: denying resurrection, reckoning, the Scale, Paradise, or Hellfire.",
  ),
  AqeedahQuestion(
    id: "salaf_001",
    category: "Salaf & Sects",
    difficulty: "Essential",
    question: "Why is the understanding of the Salaf important?",
    options: [
      "They were the earliest and best generations who learned Islam closest to the Prophet ﷺ",
      "Later opinions are always better than early Islam",
      "The Companions are not needed to understand Islam",
      "Every sect understands revelation equally",
    ],
    correctIndex: 0,
    correctAnswer:
        "They were the earliest and best generations who learned Islam closest to the Prophet ﷺ",
    reference:
        "Hadith source: Sahih al-Bukhari 3651 — Sunnah.com lookup: Bukhari 3651\nNarrator/topic: Virtue of the Prophet’s generation and those after them.\nQuoted translation: “The best of my followers are those living in my generation and then those who will follow the latter.”\nHadith source: Sahih Muslim 2533 — Sunnah.com lookup: Muslim 2533\nNarrator/topic: Virtue of the earliest generations.\nQuoted translation: “The best of my Umma would be those of the generation nearest to mine. Then those nearest to them, then those nearest to them.”\nQur’an 9:100 (Saheeh International): “And the first forerunners [in the faith] among the Muhajireen and the Ansar and those who followed them with good conduct - Allah is pleased with them.”",
    explanation:
        "The Companions learned directly from the Prophet ﷺ. The early generations preserved the meanings of the Qur’an and Sunnah.",
    commonMistake:
        "A common mistake is ignoring the Companions and reading Islam only through later arguments.",
    relatedBeliefGroup:
        "Wrong belief/group names: Sectarian methods that leave the way of the Companions. Wrong belief: claiming later ideas are safer than the understanding of the Salaf.",
  ),
  AqeedahQuestion(
    id: "salaf_002",
    category: "Salaf & Sects",
    difficulty: "Beginner",
    question: "Whose path should Muslims follow in understanding religion?",
    options: [
      "The Prophet ﷺ, his Companions, and those who followed them in goodness",
      "Any popular speaker without evidence",
      "Dreams and feelings over revelation",
      "A group name even when it opposes evidence",
    ],
    correctIndex: 0,
    correctAnswer:
        "The Prophet ﷺ, his Companions, and those who followed them in goodness",
    reference:
        "Qur’an 9:100 (Saheeh International): “And the first forerunners [in the faith] among the Muhajireen and the Ansar and those who followed them with good conduct - Allah is pleased with them.”\nQur’an 4:115 (Saheeh International): “And whoever opposes the Messenger after guidance has become clear to him and follows other than the way of the believers - We will give him what he has taken.”",
    explanation:
        "Islam is understood through revelation and the way it was understood by the first Muslims.",
    commonMistake:
        "Following personalities, trends, or group loyalty even when evidence is clear.",
    relatedBeliefGroup:
        "Wrong belief/group names: Blind partisanship and sectarian loyalty. Wrong belief: putting a group, teacher, or party above clear evidence.",
  ),
  AqeedahQuestion(
    id: "companions_001",
    category: "Salaf & Sects",
    difficulty: "Beginner",
    question:
        "What is the correct attitude toward the Companions رضي الله عنهم?",
    options: [
      "Love and honor all of them and avoid insulting them",
      "Insult most of them except a few",
      "Believe they all left Islam after the Prophet ﷺ",
      "Make hatred of the Companions part of religion",
    ],
    correctIndex: 0,
    correctAnswer: "Love and honor all of them and avoid insulting them",
    reference:
        "Qur’an 9:100 (Saheeh International): “And the first forerunners [in the faith] among the Muhajireen and the Ansar and those who followed them with good conduct - Allah is pleased with them.”\nHadith source: Sahih al-Bukhari 3673 — Sunnah.com lookup: Bukhari 3673\nNarrator/topic: Warning against abusing the Companions.\nQuoted translation: “Do not abuse my companions.”\nHadith source: Sahih Muslim 2540 — Sunnah.com lookup: Muslim 2540\nNarrator/topic: Warning against reviling the Companions.\nQuoted translation: “Do not revile my Companions.”",
    explanation:
        "Ahlus-Sunnah love the Companions because Allah praised them and they carried the religion to the Ummah.",
    commonMistake:
        "Reviling the Companions attacks the people who carried the Qur’an and Sunnah to us.",
    relatedBeliefGroup:
        "Wrong belief/group names: Rafidah/Shi‘ah extremism and anti-Companion sectarian beliefs. Wrong belief: attacking the Companions or claiming they betrayed Islam.",
  ),
  AqeedahQuestion(
    id: "companions_order_001",
    category: "Salaf & Sects",
    difficulty: "Beginner",
    question: "Who are the best of this Ummah after the Prophet ﷺ?",
    options: [
      "Abu Bakr, then Umar, then Uthman, then Ali رضي الله عنهم",
      "Only Ali رضي الله عنه and no one else",
      "Unknown later people",
      "Those who curse the Companions",
    ],
    correctIndex: 0,
    correctAnswer: "Abu Bakr, then Umar, then Uthman, then Ali رضي الله عنهم",
    reference:
        "Hadith source: Sahih al-Bukhari 3655 — Sunnah.com lookup: Bukhari 3655\nNarrator/topic: Virtue order of Abu Bakr, ‘Umar, and ‘Uthman رضي الله عنهم.\nQuoted translation: “During the lifetime of the Prophet (ﷺ) we used to consider Abu Bakr as peerless and then ‘Umar and then ‘Uthman.”\nHadith source: Sahih al-Bukhari 3671 — Sunnah.com lookup: Bukhari 3671\nNarrator/topic: Virtue of Abu Bakr رضي الله عنه.\nQuoted translation: “The person for whom I have the greatest love and respect amongst the people is ‘Aisha and among the men, her father.”",
    explanation:
        "Ahlus-Sunnah love all the Companions and affirm the special virtue of the rightly guided caliphs.",
    commonMistake:
        "Sectarian hatred may lead to denying virtues or insulting Companions.",
    relatedBeliefGroup:
        "Wrong belief/group names: Rafidah/Shi‘ah extremism and sectarian exaggeration. Wrong belief: hating or reviling the Companions.",
  ),
  AqeedahQuestion(
    id: "sects_001",
    category: "Salaf & Sects",
    difficulty: "Intermediate",
    question: "What is the safe way when Muslim groups differ in belief?",
    options: [
      "Return to the Qur’an, authentic Sunnah, and the understanding of the Salaf",
      "Choose the largest group even without evidence",
      "Choose the group with the most emotional speeches",
      "Ignore belief because only manners matter",
    ],
    correctIndex: 0,
    correctAnswer:
        "Return to the Qur’an, authentic Sunnah, and the understanding of the Salaf",
    reference:
        "Qur’an 4:59 (Saheeh International): “And if you disagree over anything, refer it to Allah and the Messenger.”\nQur’an 9:100 (Saheeh International): “And the first forerunners [in the faith] among the Muhajireen and the Ansar and those who followed them with good conduct - Allah is pleased with them.”",
    explanation:
        "Names and numbers do not prove truth. The truth is measured by revelation as understood by the early Muslims.",
    commonMistake:
        "A common mistake is choosing a sect or group by culture, family, emotion, or numbers instead of evidence.",
    relatedBeliefGroup:
        "Wrong belief/group names: Sectarian loyalty and blind following. Wrong belief: making group identity more important than Qur’an and Sunnah.",
  ),
  AqeedahQuestion(
    id: "sects_attributes_001",
    category: "Salaf & Sects",
    difficulty: "Intermediate",
    question:
        "Which answer matches the way of the Salaf about Allah’s Attributes?",
    options: [
      "Affirm the texts as they came, without changing the meaning, denying, asking how, or comparing",
      "Deny the Attributes because philosophy cannot accept them",
      "Compare the Attributes to human attributes",
      "Treat Qur’an and Sunnah as unclear until later philosophy fixes them",
    ],
    correctIndex: 0,
    correctAnswer:
        "Affirm the texts as they came, without changing the meaning, denying, asking how, or comparing",
    reference:
        "Qur’an 42:11 (The Clear Quran): “There is nothing like Him, for He ˹alone˺ is the All-Hearing, All-Seeing.”\nQur’an 7:180 (Saheeh International): “And to Allah belong the best names, so invoke Him by them.”",
    explanation:
        "The Salaf submitted to revelation. They affirmed Allah’s perfect Attributes and denied that Allah resembles creation.",
    commonMistake:
        "Some groups deny or over-explain Attributes because of later philosophy. Others compare Allah to creation.",
    relatedBeliefGroup:
        "Wrong belief/group names: Ash‘ari and Maturidi kalam-based ta’wil tendency, Mu‘tazilah, Jahmiyyah, Mushabbihah. Wrong belief: changing Allah’s Attributes without proof, denying them, or comparing Allah to creation.",
  ),
  AqeedahQuestion(
    id: "sunnah_001",
    category: "Sunnah vs Bid‘ah",
    difficulty: "Essential",
    question: "What are the two basic conditions for worship to be accepted?",
    options: [
      "Sincerity for Allah and following the Messenger ﷺ",
      "Large crowds and strong feelings",
      "Good intention only, even if the act is invented",
      "Family tradition and popularity",
    ],
    correctIndex: 0,
    correctAnswer: "Sincerity for Allah and following the Messenger ﷺ",
    reference:
        "Qur’an 18:110 (Saheeh International): “and not associate in the worship of his Lord anyone.”\nHadith source: Sahih al-Bukhari 1 — Sunnah.com lookup: Bukhari 1\nNarrator/topic: Sincerity and intention.\nQuoted translation: “The reward of deeds depends upon the intentions.”\nHadith source: Sahih Muslim 1718 — Sunnah.com lookup: Muslim 1718\nNarrator/topic: Rejection of invented religious actions.\nQuoted translation: “He who did any act for which there is no sanction from our behalf, that is to be rejected.”",
    explanation:
        "Worship must be for Allah alone and according to the Sunnah. Good intention does not make invented worship correct.",
    commonMistake:
        "Saying “my intention is good” while ignoring whether the Prophet ﷺ taught the act as worship.",
    relatedBeliefGroup:
        "Wrong belief/group names: Bid‘ah in worship, worship based only on feelings. Wrong belief: inventing acts of worship without evidence.",
  ),
  AqeedahQuestion(
    id: "bidah_001",
    category: "Sunnah vs Bid‘ah",
    difficulty: "Essential",
    question: "What did the Prophet ﷺ warn about invented religious practices?",
    options: [
      "Every newly invented religious matter is misguidance",
      "All new religious practices are automatically good",
      "Innovation is needed because Islam is incomplete",
      "Bid‘ah only means technology",
    ],
    correctIndex: 0,
    correctAnswer: "Every newly invented religious matter is misguidance",
    reference:
        "Hadith source: Sahih Muslim 867 — Sunnah.com lookup: Muslim 867\nNarrator/topic: Warning against religious innovation.\nQuoted translation: “The best discourse is the Book of Allah, and the best guidance is the guidance given by Muhammad. And the most evil affairs are their innovations; and every innovation is error.”\nHadith source: Sahih Muslim 1718 — Sunnah.com lookup: Muslim 1718\nNarrator/topic: Rejection of invented religious actions.\nQuoted translation: “He who did any act for which there is no sanction from our behalf, that is to be rejected.”",
    explanation:
        "The warning is about inventing beliefs or acts of worship, not about normal worldly tools like microphones, cars, or apps.",
    commonMistake:
        "Some confuse useful worldly tools with invented worship. Others treat invented worship as harmless.",
    relatedBeliefGroup:
        "Wrong belief/group names: Bid‘ah in belief or worship. Wrong belief: adding invented religious practices and calling them Sunnah.",
  ),
  AqeedahQuestion(
    id: "bidah_002",
    category: "Sunnah vs Bid‘ah",
    difficulty: "Beginner",
    question: "What is the best guidance?",
    options: [
      "The guidance of Muhammad ﷺ",
      "The newest religious trend",
      "Dreams over revelation",
      "The majority view even without evidence",
    ],
    correctIndex: 0,
    correctAnswer: "The guidance of Muhammad ﷺ",
    reference:
        "Hadith source: Sahih Muslim 867 — Sunnah.com lookup: Muslim 867\nNarrator/topic: The Prophet’s guidance is the best guidance.\nQuoted translation: “The best guidance is the guidance given by Muhammad.”\nQur’an 33:21 (Saheeh International): “There has certainly been for you in the Messenger of Allah an excellent pattern.”",
    explanation:
        "Islam is complete. Guidance is measured by Qur’an, authentic Sunnah, and the understanding of the early Muslims.",
    commonMistake:
        "Putting dreams, customs, personalities, or trends above revelation.",
    relatedBeliefGroup:
        "Wrong belief/group names: Blind following and bid‘ah. Wrong belief: putting dreams, customs, personalities, or trends above revelation.",
  ),
  AqeedahQuestion(
    id: "bidah_mawlid_001",
    category: "Sunnah vs Bid‘ah",
    difficulty: "Intermediate",
    question: "How should Muslims show love for the Prophet ﷺ?",
    options: [
      "By following his Sunnah and obeying him",
      "By inventing yearly religious celebrations he did not teach",
      "By singing at graves and ignoring his commands",
      "By loving him with words but leaving his Sunnah",
    ],
    correctIndex: 0,
    correctAnswer: "By following his Sunnah and obeying him",
    reference:
        "Qur’an 3:31 (Saheeh International): “Say, [O Muhammad], ‘If you should love Allah, then follow me, [so] Allah will love you.’”\nHadith source: Sahih Muslim 1718 — Sunnah.com lookup: Muslim 1718\nNarrator/topic: Rejection of invented religious actions.\nQuoted translation: “He who did any act for which there is no sanction from our behalf, that is to be rejected.”",
    explanation:
        "True love for the Prophet ﷺ is shown by belief, obedience, following his Sunnah, sending salawat, and defending his way.",
    commonMistake:
        "Thinking love is proven by invented celebrations or rituals that the Prophet ﷺ and Companions did not practice.",
    relatedBeliefGroup:
        "Wrong belief/group names: Common bid‘ah in invented celebrations. Wrong belief: making a yearly religious celebration that the Prophet ﷺ and Companions did not teach.",
  ),
  AqeedahQuestion(
    id: "bidah_grave_001",
    category: "Sunnah vs Bid‘ah",
    difficulty: "Intermediate",
    question: "Which grave practice is dangerous and wrong?",
    options: [
      "Calling upon the dead for help or blessings",
      "Visiting graves to remember death and make du‘a for the dead",
      "Saying salam to the dead in the legislated way",
      "Avoiding worship at graves",
    ],
    correctIndex: 0,
    correctAnswer: "Calling upon the dead for help or blessings",
    reference:
        "Qur’an 35:14 (Saheeh International): “If you invoke them, they do not hear your supplication; and if they heard, they would not respond to you.”\nQur’an 72:18 (Saheeh International): “And [He revealed] that the masjids are for Allah, so do not invoke with Allah anyone.”",
    explanation:
        "Visiting graves in the Sunnah way is allowed and beneficial. But calling upon the dead is not allowed and can be shirk.",
    commonMistake:
        "Mixing the Sunnah visit to graves with du‘a to the dead or seeking blessings from graves.",
    relatedBeliefGroup:
        "Wrong belief/group names: Grave worship, invented grave rituals, extreme saint-veneration. Wrong belief: calling upon the dead or seeking blessings from graves.",
  ),
  AqeedahQuestion(
    id: "bidah_group_dhikr_001",
    category: "Sunnah vs Bid‘ah",
    difficulty: "Intermediate",
    question: "What is the correct rule for fixed worship routines?",
    options: [
      "A fixed act of worship needs proof from Qur’an or authentic Sunnah",
      "Any routine becomes Sunnah if many people like it",
      "Dreams can create new acts of worship",
      "A leader can invent fixed worship times and counts without evidence",
    ],
    correctIndex: 0,
    correctAnswer:
        "A fixed act of worship needs proof from Qur’an or authentic Sunnah",
    reference:
        "Hadith source: Sahih Muslim 1718 — Sunnah.com lookup: Muslim 1718\nNarrator/topic: Rejection of invented religious actions.\nQuoted translation: “He who did any act for which there is no sanction from our behalf, that is to be rejected.”\nQur’an 5:3 (Saheeh International): “This day I have perfected for you your religion and completed My favor upon you and have approved for you Islam as religion.”",
    explanation:
        "Remembering Allah is good, but making a special fixed ritual, number, time, or style as religion needs evidence.",
    commonMistake:
        "Treating invented fixed group rituals as Sunnah without proof.",
    relatedBeliefGroup:
        "Wrong belief/group names: Common bid‘ah in fixed worship routines. Wrong belief: inventing fixed numbers, times, or group styles of worship without evidence.",
  ),
  AqeedahQuestion(
    id: "rulers_001",
    category: "Salaf & Sects",
    difficulty: "Advanced",
    question: "What is the Sunni position about Muslim rulers?",
    options: [
      "Obey in what is lawful, do not obey sin, and avoid rebellion that causes greater harm",
      "Obey rulers even if they command sin or disbelief",
      "Rebel for every sin or injustice",
      "Make public chaos the first answer to every problem",
    ],
    correctIndex: 0,
    correctAnswer:
        "Obey in what is lawful, do not obey sin, and avoid rebellion that causes greater harm",
    reference:
        "Qur’an 4:59 (Saheeh International): “O you who have believed, obey Allah and obey the Messenger and those in authority among you.”\nHadith source: Sahih al-Bukhari 7056 — Sunnah.com lookup: Bukhari 7056\nNarrator/topic: Obedience to rulers and the condition of clear disbelief.\nQuoted translation: “unless you see clear disbelief, for which you have proof from Allah.”\nHadith source: Sahih Muslim 1709 — Sunnah.com lookup: Muslim 1709\nNarrator/topic: Warning against rebellion that causes fitnah.\nQuoted translation: “Listen to and obey the Amir, even if your back is beaten and your wealth is taken.”",
    explanation:
        "Ahlus-Sunnah command obedience in lawful matters, forbid obedience to sin, advise with wisdom, and avoid chaos and bloodshed.",
    commonMistake:
        "Using sins or oppression as an automatic excuse for rebellion, which often brings greater harm.",
    relatedBeliefGroup:
        "Wrong belief/group names: Khawarij-type rebellion and chaos. Wrong belief: using sins or oppression as an automatic excuse for rebellion and public chaos.",
  ),
  AqeedahQuestion(
    id: "intention_001",
    category: "Core Beliefs",
    difficulty: "Beginner",
    question: "What should every act of worship be done for?",
    options: [
      "For Allah alone",
      "For praise from people",
      "For a saint to notice it",
      "For culture only",
    ],
    correctIndex: 0,
    correctAnswer: "For Allah alone",
    reference:
        "Qur’an 98:5 (Saheeh International): “And they were not commanded except to worship Allah, [being] sincere to Him in religion.”\nHadith source: Sahih al-Bukhari 1 — Sunnah.com lookup: Bukhari 1\nNarrator/topic: Sincerity and intention.\nQuoted translation: “The reward of deeds depends upon the intentions.”",
    explanation:
        "Sincerity means the worship is for Allah, not for showing off or pleasing created beings.",
    commonMistake: "Doing worship mainly so people praise you.",
    relatedBeliefGroup:
        "Wrong belief/group names: Showing off and weak sincerity. Wrong belief: doing worship mainly so people praise you.",
  ),
];

const List<String> featuredAqeedahQuestionOrder = [
  "attributes_where_001",
  "attributes_001",
  "attributes_002",
  "attributes_003",
  "hereafter_seeing_allah_001",
  "quran_speech_001",
  "quran_musa_001",
  "uluhiyyah_001",
  "dua_001",
  "shirk_001",
  "salah_obligation_001",
  "salah_abandon_001",
  "nullifier_shirk_001",
  "nullifier_mocking_001",
  "salaf_001",
  "salaf_002",
  "sunnah_001",
  "bidah_001",
  "sects_attributes_001",
  "rububiyyah_001",
  "qadar_001",
  "iman_001",
];

List<AqeedahQuestion> prioritizeAqeedahQuestions(
  Iterable<AqeedahQuestion> questions,
) {
  final ordered = questions.toList();
  final originalPositions = <String, int>{
    for (var i = 0; i < ordered.length; i++) ordered[i].id: i,
  };

  ordered.sort((a, b) {
    final aFeatured = featuredAqeedahQuestionOrder.indexOf(a.id);
    final bFeatured = featuredAqeedahQuestionOrder.indexOf(b.id);
    final aPriority = aFeatured == -1 ? 1000 : aFeatured;
    final bPriority = bFeatured == -1 ? 1000 : bFeatured;

    if (aPriority != bPriority) return aPriority.compareTo(bPriority);
    return (originalPositions[a.id] ?? 0)
        .compareTo(originalPositions[b.id] ?? 0);
  });

  return ordered;
}

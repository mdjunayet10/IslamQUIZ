from __future__ import annotations

import re
from dataclasses import dataclass
from enum import Enum
from typing import Iterable
from typing import Optional
from typing import Tuple


class QuestionType(Enum):
    """Classification of question types."""
    FATWA = "FATWA"           # Ruling, halal/haram questions
    AQIDAH = "AQIDAH"         # Belief, creed questions
    GENERAL = "GENERAL"       # General knowledge questions


STOPWORDS = {
    "the",
    "is",
    "a",
    "an",
    "and",
    "of",
    "to",
    "in",
    "for",
    "on",
    "with",
    "what",
    "where",
    "who",
    "does",
    "about",
    "from",
    "that",
    "this",
    "are",
    "be",
    "it",
    "definition",
}

# Topic-to-keywords mapping for improved relevance filtering
TOPIC_KEYWORDS = {
    "salah": {"salah", "prayer", "prayer", "shalah", "salat", "صلاة", "prayerlessness"},
    "iman": {"iman", "faith", "belief", "eeman", "الايمان", "إيمان", "creed"},
    "kufr": {"kufr", "disbelief", "كفر", "كافر", "unbelief", "disbeliever"},
    "halal": {"halal", "halaal", "حلال", "permissible", "lawful"},
    "haram": {"haram", "حرام", "forbidden", "impermissible", "unlawful"},
    "fiqh": {"fiqh", "jurisprudence", "ruling", "حكم", "fatwas", "fatwa"},
    "zakat": {"zakat", "زكاة", "alms", "charity", "sadaqah"},
    "hajj": {"hajj", "pilgrimage", "حج", "umrah"},
    "wudu": {"wudu", "ablution", "وضوء", "purification"},
    "riba": {"riba", "interest", "ربا", "usury"},
    "dua": {"dua", "supplication", "دعاء", "prayer petition"},
    "tawheed": {"tawheed", "tawhid", "توحيد", "monotheism", "unity"},
}

SYNONYMS = {
    "iman": {"iman", "faith", "belief", "eeman", "الايمان", "إيمان"},
    "faith": {"iman", "faith", "belief", "eeman", "الايمان", "إيمان"},
    "belief": {"iman", "faith", "belief", "eeman", "الايمان", "إيمان"},
    "amal": {"amal", "actions", "deeds", "عمل", "أعمال", "اعمال"},
    "actions": {"amal", "actions", "deeds", "عمل", "أعمال", "اعمال"},
    "deeds": {"amal", "actions", "deeds", "عمل", "أعمال", "اعمال"},
    "increase": {"increase", "increase of faith", "yarfa", "yazeed", "يزيد", "زيادة"},
    "زيادة": {"increase", "yazeed", "يزيد", "زيادة"},
}

TOKEN_RE = re.compile(r"[\w\u0600-\u06FF']+", re.UNICODE)


@dataclass
class RetrievalItem:
    source_type: str
    text: str
    reference: str
    keywords: list[str]
    collection: Optional[str] = None
    number: Optional[str] = None
    grading: Optional[str] = None


@dataclass
class ScoredItem:
    score: float
    item: RetrievalItem


def _normalize_token(token: str) -> str:
    return token.strip().lower()


def classify_question_type(question: str) -> QuestionType:
    """
    Classify question into FATWA, AQIDAH, or GENERAL.
    
    FATWA: explicit ruling/halal/haram questions
    AQIDAH: belief/creed questions  
    GENERAL: everything else
    """
    q_lower = question.lower()
    
    # FATWA patterns - broader matching for rulings, halal, haram
    fatwa_patterns = [
        r"halal",
        r"haram",
        r"permissible",
        r"forbidden",
        r"ruling",
        r"fatwa",
        r"permissibility",
        r"remain.*muslim",
        r"is.*allowed",
        r"is.*prohibited",
    ]
    
    for pattern in fatwa_patterns:
        if re.search(pattern, q_lower, re.IGNORECASE):
            return QuestionType.FATWA
    
    # AQIDAH patterns (belief, creed, monotheism)
    aqidah_patterns = [
        r"\biman\b",
        r"\bfaith\b",
        r"\bcreed\b",
        r"\bbelie",
        r"\btaghut\b",
        r"\bshirk\b",
        r"\bkufr\b",
        r"\bdisbelief\b",
        r"\bmonotheism\b",
        r"\bwho is allah\b",
        r"\bwhere is allah\b",
        r"\bpropenties of allah\b",
        r"\battributes of allah\b",
        r"\btawheed\b",
        r"\bAllah\b.*\b(above|throne|istiwa)\b",
    ]
    
    for pattern in aqidah_patterns:
        if re.search(pattern, q_lower, re.IGNORECASE):
            return QuestionType.AQIDAH
    
    return QuestionType.GENERAL


def extract_main_topic(question: str) -> Optional[str]:
    """
    Extract the MAIN topic from a question.
    Returns the topic key (e.g., 'salah', 'iman', 'kufr') or None.
    
    Examples:
        "What is salah?" → 'salah'
        "abandon salah" → 'salah'
        "What is the ruling on riba?" → 'riba'
    """
    q_lower = question.lower()
    
    # Find best matching topic
    best_matches: list[tuple[str, int]] = []
    for topic, keywords in TOPIC_KEYWORDS.items():
        for keyword in keywords:
            if keyword.lower() in q_lower:
                best_matches.append((topic, len(keyword)))
    
    if best_matches:
        # Return topic with longest keyword match (most specific)
        best_matches.sort(key=lambda x: x[1], reverse=True)
        return best_matches[0][0]
    
    return None


def extract_keywords(text: str) -> set[str]:
    tokens = {_normalize_token(t) for t in TOKEN_RE.findall(text)}
    return {t for t in tokens if t and t not in STOPWORDS and len(t) > 1}


def _expanded_question_keywords(question: str) -> set[str]:
    q = question.lower()
    keywords = set(extract_keywords(question))

    expanded = set(keywords)
    for token in keywords:
        expanded.update(SYNONYMS.get(token, set()))
    keywords = expanded

    # Minimal strict expansions for core aqidah queries.
    if "allah" in q:
        keywords.update({"allah", "above", "throne", "سماء", "السماء", "istiwa", "istawa", "arsh"})
    if "iman" in q or "iman" in keywords or "eeman" in q:
        keywords.update({"iman", "faith", "jibril", "islam", "ihsan"})
    if "action" in q or "deed" in q or "amal" in q:
        keywords.update({"actions", "deeds", "amal", "branches", "shubah", "shu'ab"})
    if "increase" in q or "يزيد" in q or "زيادة" in q:
        keywords.update({"increase", "yazeed", "يزيد", "زيادة", "decrease", "yanqus", "ينقص"})

    return keywords


def _intent_constraints(question: str) -> tuple[set[str], bool]:
    q = question.lower()

    # For "Where is Allah?" style questions, require attribute/location-focused terms.
    if "where is allah" in q or "where's allah" in q or "اين الله" in q:
        return ({"above", "throne", "arsh", "istiwa", "istawa", "سماء", "السماء", "fawq"}, True)

    # For iman-definition style questions, require core iman terms.
    if "definition of iman" in q or "what is iman" in q or "define iman" in q or "تعريف الايمان" in q:
        return ({"iman", "faith", "jibril", "islam", "ihsan"}, True)

    if "actions" in q and ("iman" in q or "faith" in q):
        return ({"actions", "deeds", "amal", "branches", "iman", "faith"}, True)

    if ("increase" in q and ("iman" in q or "faith" in q)) or "زيادة الايمان" in q:
        return ({"increase", "yazeed", "يزيد", "زيادة", "decrease", "yanqus", "ينقص", "iman", "faith"}, True)

    return (set(), False)


def _dataset_keywords(item: RetrievalItem) -> set[str]:
    kw = {_normalize_token(k) for k in item.keywords if isinstance(k, str)}
    return {k for k in kw if k}


def _text_keywords(item: RetrievalItem) -> set[str]:
    return extract_keywords(item.text)


def score_item(question_keywords: set[str], item: RetrievalItem) -> float:
    if not question_keywords:
        return 0.0

    dataset_kw = _dataset_keywords(item)
    text_kw = _text_keywords(item)

    direct_kw_hits = len(question_keywords & dataset_kw)
    text_hits = len(question_keywords & text_kw)

    # Prefer explicit dataset keywords over free-text token overlap.
    return direct_kw_hits * 3.0 + text_hits * 1.0


def _source_bonus(item: RetrievalItem) -> float:
    if item.source_type == "quran":
        return 3.0
    if item.source_type == "hadith":
        grade = (item.grading or "").lower()
        if grade == "sahih":
            return 2.0
        if grade == "hasan":
            return 1.0
    if item.source_type == "tafsir":
        return 0.6
    if item.source_type == "aqidah":
        return 0.4
    return 0.0


def retrieve_strict(
    question: str,
    items: Iterable[RetrievalItem],
    top_k: int = 5,
    min_score: float = 1.0,
    min_top_score: float = 3.0,
) -> list[Tuple[RetrievalItem, float]]:
    question_keywords = _expanded_question_keywords(question)
    if not question_keywords:
        return []

    required_focus, has_intent_constraint = _intent_constraints(question)
    
    # Extract main topic for hard filtering
    main_topic = extract_main_topic(question)
    topic_keywords_set: set[str] = set()
    if main_topic and main_topic in TOPIC_KEYWORDS:
        topic_keywords_set = TOPIC_KEYWORDS[main_topic]

    scored: list[ScoredItem] = []
    for item in items:
        if has_intent_constraint:
            item_kw = _dataset_keywords(item) | _text_keywords(item)
            if not (required_focus & item_kw):
                continue
        
        # HARD RULE: If we detected a main topic, only allow sources with topic keywords
        if main_topic and topic_keywords_set:
            item_kw = _dataset_keywords(item) | _text_keywords(item)
            if not (topic_keywords_set & item_kw):
                continue

        base_score = score_item(question_keywords, item)
        if base_score <= 0:
            continue

        score = base_score + _source_bonus(item)
        if score >= min_score:
            scored.append(ScoredItem(score=score, item=item))

    scored.sort(key=lambda x: x.score, reverse=True)
    if not scored:
        return []

    # Hard confidence gate: better no answer than weak evidence.
    if scored[0].score < min_top_score:
        return []

    bounded_k = max(1, min(5, top_k))
    return [(x.item, x.score) for x in scored[:bounded_k]]

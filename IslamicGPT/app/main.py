from __future__ import annotations

import json
import os
import re
from dataclasses import dataclass
from pathlib import Path
from typing import Any, Optional

from fastapi import FastAPI
from fastapi.responses import FileResponse
from fastapi.staticfiles import StaticFiles
from pydantic import BaseModel, Field

from app.retriever import RetrievalItem
from app.retriever import retrieve_strict
from app.retriever import QuestionType
from app.retriever import classify_question_type
from app.retriever import extract_main_topic

ALLAHU_ALAM = "Allahu a'lam"
FATWA_BLOCK = "This question requires a scholarly ruling. Consult a qualified scholar."

ALLOWED_DATASETS = {
    "quran": "quran.json",
    "hadith": "hadith.json",
    "tafsir": "tafsir_ibn_kathir.json",
    "aqidah": "aqidah.json",
}

ALLOWED_HADITH_COLLECTIONS = {
    "sahih al-bukhari",
    "sahih muslim",
    "sunan abu dawud",
    "jami' al-tirmidhi",
    "jami al-tirmidhi",
    "sunan al-nasa'i",
    "sunan an-nasa'i",
    "sunan ibn majah",
}

HADITH_COLLECTION_ALIASES = {
    "bukhari": "Sahih al-Bukhari",
    "sahih bukhari": "Sahih al-Bukhari",
    "sahih al bukhari": "Sahih al-Bukhari",
    "sahih al-bukhari": "Sahih al-Bukhari",
    "muslim": "Sahih Muslim",
    "sahih muslim": "Sahih Muslim",
    "abu dawud": "Sunan Abu Dawud",
    "abu dawood": "Sunan Abu Dawud",
    "sunan abu dawud": "Sunan Abu Dawud",
    "tirmidhi": "Jami' al-Tirmidhi",
    "al tirmidhi": "Jami' al-Tirmidhi",
    "jami al-tirmidhi": "Jami' al-Tirmidhi",
    "jami' al-tirmidhi": "Jami' al-Tirmidhi",
    "nasa'i": "Sunan al-Nasa'i",
    "nasai": "Sunan al-Nasa'i",
    "sunan al-nasa'i": "Sunan al-Nasa'i",
    "sunan an-nasa'i": "Sunan al-Nasa'i",
    "ibn majah": "Sunan Ibn Majah",
    "sunan ibn majah": "Sunan Ibn Majah",
}

ALLOWED_HADITH_GRADES = {"sahih", "hasan"}

PRIORITY = {
    "quran": 500,
    "hadith_sahih": 400,
    "hadith_hasan": 300,
    "tafsir": 200,
    "aqidah": 100,
}

FATWA_PATTERNS = [
    re.compile(r"\bis\s+this\s+halal\b", re.IGNORECASE),
    re.compile(r"\bis\s+this\s+haram\b", re.IGNORECASE),
    re.compile(r"\bcan\s+i\s+do\s+this\b", re.IGNORECASE),
    re.compile(r"\bdoes\s+he\s+remain\s+muslim\b", re.IGNORECASE),
    re.compile(r"\bwhat\s+is\s+the\s+ruling\b", re.IGNORECASE),
    re.compile(r"\bwhat\s+is\s+the\s+law\b", re.IGNORECASE),
    re.compile(r"\bfatwa\b", re.IGNORECASE),
    re.compile(r"\bis\s+it\s+permissible\b", re.IGNORECASE),
    re.compile(r"\bis\s+it\s+forbidden\b", re.IGNORECASE),
]

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
    "does",
    "about",
    "from",
    "that",
}


class AskRequest(BaseModel):
    question: str = Field(min_length=2, max_length=2000)


class Citation(BaseModel):
    source_type: str
    reference: str
    collection: Optional[str] = None
    number: Optional[str] = None
    grading: Optional[str] = None


class AskResponse(BaseModel):
    answer: str
    citations: list[Citation]
    rejected: bool


@dataclass
class Evidence:
    source_type: str
    text: str
    reference: str
    keywords: list[str]
    collection: Optional[str] = None
    number: Optional[str] = None
    grading: Optional[str] = None


class StrictIslamicEngine:
    def __init__(self, base_dir: Path) -> None:
        self.base_dir = base_dir
        self.records: list[Evidence] = []
        self.source_counts: dict[str, int] = {
            "quran": 0,
            "hadith": 0,
            "tafsir": 0,
            "aqidah": 0,
        }
        self._load_all()

    def dataset_presence(self) -> dict[str, bool]:
        return {
            key: self._dataset_path(file_name) is not None
            for key, file_name in ALLOWED_DATASETS.items()
        }

    def _normalize_collection(self, raw_collection: str) -> str:
        cleaned = re.sub(r"\s+", " ", raw_collection.strip().lower())
        return HADITH_COLLECTION_ALIASES.get(cleaned, "")

    def _dataset_path(self, file_name: str) -> Optional[Path]:
        env_data_dir = os.getenv("ISLAMICGPT_DATA_DIR", "").strip()
        if env_data_dir:
            env_path = Path(env_data_dir) / file_name
            if env_path.exists():
                return env_path

        root_path = self.base_dir / file_name
        data_path = self.base_dir / "data" / file_name
        if root_path.exists():
            return root_path
        if data_path.exists():
            return data_path
        return None

    def _load_json(self, file_name: str) -> Any:
        path = self._dataset_path(file_name)
        if path is None:
            return []
        with path.open("r", encoding="utf-8") as f:
            return json.load(f)

    def _as_list(self, payload: Any) -> list[dict[str, Any]]:
        if isinstance(payload, list):
            return [x for x in payload if isinstance(x, dict)]
        if isinstance(payload, dict):
            for key in ("items", "data", "results", "records"):
                val = payload.get(key)
                if isinstance(val, list):
                    return [x for x in val if isinstance(x, dict)]
            return [payload]
        return []

    def _first_non_empty(self, row: dict[str, Any], keys: tuple[str, ...]) -> str:
        for key in keys:
            val = row.get(key)
            if isinstance(val, str) and val.strip():
                return val.strip()
            if isinstance(val, int):
                return str(val)
        return ""

    def _load_all(self) -> None:
        self.records.clear()
        self.source_counts = {
            "quran": 0,
            "hadith": 0,
            "tafsir": 0,
            "aqidah": 0,
        }

        quran_rows = self._as_list(self._load_json(ALLOWED_DATASETS["quran"]))
        for row in quran_rows:
            surah = self._first_non_empty(row, ("surah", "surah_number", "chapter"))
            ayah = self._first_non_empty(row, ("ayah", "verse", "ayah_number"))
            text = self._first_non_empty(row, ("text", "ayah_text", "verse_text", "content"))
            keywords = row.get("keywords") if isinstance(row.get("keywords"), list) else []
            if not surah or not ayah or not text:
                continue
            self.records.append(
                Evidence(
                    source_type="quran",
                    text=text,
                    reference=f"{surah}:{ayah}",
                    keywords=[str(x) for x in keywords if isinstance(x, (str, int))],
                )
            )
            self.source_counts["quran"] += 1

        hadith_rows = self._as_list(self._load_json(ALLOWED_DATASETS["hadith"]))
        for row in hadith_rows:
            raw_collection = self._first_non_empty(
                row, ("collection", "book", "source", "hadith_collection")
            )
            collection = self._normalize_collection(raw_collection)
            number = self._first_non_empty(row, ("number", "hadith_number", "id"))
            grade = self._first_non_empty(row, ("grading", "grade", "status")).lower()
            text = self._first_non_empty(row, ("text", "matn", "content", "hadith"))
            keywords = row.get("keywords") if isinstance(row.get("keywords"), list) else []
            if (
                not collection
                or not number
                or not grade
                or not text
                or grade not in ALLOWED_HADITH_GRADES
            ):
                continue
            self.records.append(
                Evidence(
                    source_type="hadith",
                    text=text,
                    reference=f"{collection} #{number}",
                    keywords=[str(x) for x in keywords if isinstance(x, (str, int))],
                    collection=collection,
                    number=number,
                    grading=grade.title(),
                )
            )
            self.source_counts["hadith"] += 1

        tafsir_rows = self._as_list(self._load_json(ALLOWED_DATASETS["tafsir"]))
        for row in tafsir_rows:
            text = self._first_non_empty(row, ("text", "content", "tafsir"))
            ref = self._first_non_empty(row, ("reference", "ayah_ref", "verse"))
            keywords = row.get("keywords") if isinstance(row.get("keywords"), list) else []
            if not text or not ref:
                continue
            self.records.append(
                Evidence(
                    source_type="tafsir",
                    text=text,
                    reference=ref,
                    keywords=[str(x) for x in keywords if isinstance(x, (str, int))],
                )
            )
            self.source_counts["tafsir"] += 1

        aqidah_rows = self._as_list(self._load_json(ALLOWED_DATASETS["aqidah"]))
        for row in aqidah_rows:
            text = self._first_non_empty(row, ("text", "content", "statement"))
            ref = self._first_non_empty(row, ("reference", "source", "work"))
            keywords = row.get("keywords") if isinstance(row.get("keywords"), list) else []
            if not text or not ref:
                continue
            self.records.append(
                Evidence(
                    source_type="aqidah",
                    text=text,
                    reference=ref,
                    keywords=[str(x) for x in keywords if isinstance(x, (str, int))],
                )
            )
            self.source_counts["aqidah"] += 1

    def _tokenize(self, text: str) -> set[str]:
        tokens = re.findall(r"[a-zA-Z0-9']+", text.lower())
        return {t for t in tokens if t not in STOPWORDS and len(t) > 1}

    def _score(self, q_tokens: set[str], evidence: Evidence) -> float:
        e_tokens = self._tokenize(evidence.text)
        if not e_tokens:
            return 0.0
        overlap = len(q_tokens & e_tokens)
        if overlap == 0:
            return 0.0

        if evidence.source_type == "quran":
            priority = PRIORITY["quran"]
        elif evidence.source_type == "hadith":
            if (evidence.grading or "").lower() == "sahih":
                priority = PRIORITY["hadith_sahih"]
            else:
                priority = PRIORITY["hadith_hasan"]
        elif evidence.source_type == "tafsir":
            priority = PRIORITY["tafsir"]
        else:
            priority = PRIORITY["aqidah"]

        density = overlap / max(len(e_tokens), 1)
        return priority + overlap * 5 + density

    def _is_fatwa_question(self, question: str) -> bool:
        """Check if question is asking for a fatwa/ruling."""
        # Use the classifier from retriever
        question_type = classify_question_type(question)
        return question_type == QuestionType.FATWA or any(
            p.search(question) for p in FATWA_PATTERNS
        )

    def _is_aqidah_question(self, question: str) -> bool:
        """Check if question is about creed/aqidah."""
        question_type = classify_question_type(question)
        return question_type == QuestionType.AQIDAH

    def _is_ibn_taymiyyah_query(self, question: str) -> bool:
        q = question.lower()
        return "ibn taymiyyah" in q or "ibn taymiyya" in q

    def _aqidah_direct_quotes_for_scholar(self, scholar_name: str) -> list[Evidence]:
        scholar_key = scholar_name.lower()
        return [
            ev
            for ev in self.records
            if ev.source_type == "aqidah"
            and (
                scholar_key in ev.reference.lower()
                or scholar_key in ev.text.lower()
            )
        ][:5]

    def _explain_evidence(self, evidence: Evidence, question: str) -> str:
        q = question.lower()
        if "where is allah" in q and evidence.reference == "20:5":
            return (
                "This affirms Allah's rising above the Throne in a manner befitting "
                "His Majesty, without asking how."
            )
        if "iman" in q:
            return "This defines iman through the established pillars of faith."
        if evidence.source_type == "quran":
            return "This verse directly establishes the point being asked about."
        if evidence.source_type == "hadith":
            return "This authentic hadith clarifies the meaning of the issue in question."
        if evidence.source_type == "tafsir":
            return "This explanation follows early tafsir to clarify the verse context."
        return "This aligns with the understanding transmitted from the early scholars."

    def _build_direct_answer(self, question: str, matches: list[Evidence]) -> str:
        """Generate a direct, natural answer without generic filler."""
        q = question.lower()
        
        # Specific question patterns with natural answers
        if "where is allah" in q:
            return "Allah is above the Throne in a manner befitting His Majesty."
        
        if "actions" in q and ("iman" in q or "faith" in q):
            return "Yes, actions are an integral part of iman."
        
        if ("definition" in q or "what is" in q) and "iman" in q:
            return "Iman encompasses declaration of faith, belief in the heart, and actions with the limbs."
        
        if "increase" in q and ("iman" in q or "faith" in q):
            return "Iman increases through obedience and decreases through disobedience."
        
        if any(m.source_type == "quran" for m in matches):
            return "This is established directly in the Qur'an."
        
        if any(m.source_type == "hadith" for m in matches):
            return "This is clarified in authentic hadith."
        
        # Fallback: minimal, direct statement
        return "This understanding is supported by the sources below."

    def _build_explanation_block(self, question: str, matches: list[Evidence]) -> str:
        """Build explanation by source type without generic phrases."""
        lines: list[str] = []
        has_quran = any(m.source_type == "quran" for m in matches)
        has_hadith = any(m.source_type == "hadith" for m in matches)
        has_tafsir = any(m.source_type == "tafsir" for m in matches)
        has_aqidah = any(m.source_type == "aqidah" for m in matches)
        
        q = question.lower()
        
        # Build specific explanations based on source composition
        if has_quran and has_hadith:
            lines.append("The Qur'anic verses and authenticated hadith together confirm this principle.")
        elif has_quran:
            lines.append("The Qur'an directly affirms this understanding.")
        elif has_hadith:
            lines.append("The authenticated prophetic traditions clarify this matter.")
        
        if has_aqidah:
            lines.append("Early scholars of creed affirmed this same understanding.")
        
        # Add specific context for known topics
        if "where is allah" in q and has_quran:
            lines.append("This is affirmed without likening Allah to creation, and without questioning the manner.")
        elif "iman" in q:
            lines.append("Iman is understood as an inward conviction manifested through words and deeds.")
        elif "salah" in q or "prayer" in q:
            lines.append("Prayer is a fundamental pillar that connects the believer to their Lord.")
        
        if not lines:
            lines.append("The sources cited above establish this understanding.")
        
        # Keep explanation concise (max 4 lines)
        return "\n".join(lines[:4])

    def retrieve(self, question: str, limit: int = 5) -> list[Evidence]:
        if not question.strip():
            return []
        retrieval_items = [
            RetrievalItem(
                source_type=ev.source_type,
                text=ev.text,
                reference=ev.reference,
                keywords=ev.keywords,
                collection=ev.collection,
                number=ev.number,
                grading=ev.grading,
            )
            for ev in self.records
            if ev.source_type in {"quran", "hadith", "tafsir", "aqidah"}
        ]

        strict_results = retrieve_strict(
            question=question,
            items=retrieval_items,
            top_k=max(2, min(5, limit)),
            min_score=1.0,
            min_top_score=3.0,
        )

        if not strict_results:
            return []

        evidence_by_key = {
            (ev.source_type, ev.reference): ev
            for ev in self.records
        }
        ordered: list[Evidence] = []
        for item, _score in strict_results:
            key = (item.source_type, item.reference)
            ev = evidence_by_key.get(key)
            if ev is not None:
                ordered.append(ev)
        return ordered

    def validate_output(
        self,
        answer: str,
        citations: list[Citation],
        allow_aqidah_only: bool = False,
    ) -> bool:
        if not citations:
            return False

        # Every answer must include at least one Qur'an or Hadith citation.
        has_primary_evidence = any(
            c.source_type in {"quran", "hadith"} for c in citations
        )
        if not has_primary_evidence and not allow_aqidah_only:
            return False

        lower = answer.lower()
        banned_phrases = ["it seems", "in my opinion"]
        if any(p in lower for p in banned_phrases):
            return False

        for c in citations:
            if c.source_type == "quran":
                if not c.reference or ":" not in c.reference:
                    return False
            elif c.source_type == "hadith":
                if not c.collection or not c.number or not c.grading:
                    return False
                if c.grading.lower() not in ALLOWED_HADITH_GRADES:
                    return False
            elif c.source_type not in {"tafsir", "aqidah"}:
                return False

        return True

    def answer(self, question: str) -> AskResponse:
        # FATWA questions block immediately
        if self._is_fatwa_question(question):
            return AskResponse(answer=FATWA_BLOCK, citations=[], rejected=True)

        # Ibn Taymiyyah scholar specific queries
        if self._is_ibn_taymiyyah_query(question):
            direct_quotes = self._aqidah_direct_quotes_for_scholar("ibn taymiyyah")
            if not direct_quotes:
                return AskResponse(
                    answer="No direct statement found in dataset. Allahu a'lam.",
                    citations=[],
                    rejected=True,
                )

            selected_quotes = direct_quotes[:3]
            citations = [
                Citation(source_type="aqidah", reference=ev.reference)
                for ev in selected_quotes
            ]
            evidence_lines = [
                f"• {ev.text}"
                for ev in selected_quotes
            ]
            answer = "\n\n".join(
                [
                    "Ibn Taymiyyah's statements:",
                    "\n".join(evidence_lines),
                ]
            )

            if not self.validate_output(answer, citations, allow_aqidah_only=True):
                return AskResponse(answer=ALLAHU_ALAM, citations=[], rejected=True)

            return AskResponse(answer=answer, citations=citations, rejected=False)

        # General retrieval
        matches = self.retrieve(question)
        if len(matches) < 2:
            return AskResponse(answer=ALLAHU_ALAM, citations=[], rejected=True)

        direct_answer = self._build_direct_answer(question, matches)
        evidence_lines: list[str] = []
        citations: list[Citation] = []

        for ev in matches:
            snippet = ev.text.strip().replace("\n", " ")
            if len(snippet) > 300:
                snippet = snippet[:300].rstrip() + "..."

            if ev.source_type == "quran":
                evidence_lines.append(
                    f"• Qur'an {ev.reference}: {snippet}"
                )
                citations.append(Citation(source_type="quran", reference=ev.reference))
            elif ev.source_type == "hadith":
                evidence_lines.append(
                    f"• {ev.collection} #{ev.number}: {snippet}"
                )
                citations.append(
                    Citation(
                        source_type="hadith",
                        reference=ev.reference,
                        collection=ev.collection,
                        number=ev.number,
                        grading=ev.grading,
                    )
                )
            elif ev.source_type == "tafsir":
                evidence_lines.append(
                    f"• Tafsir ({ev.reference}): {snippet}"
                )
                citations.append(Citation(source_type="tafsir", reference=ev.reference))
            elif ev.source_type == "aqidah":
                evidence_lines.append(
                    f"• Scholar ({ev.reference}): {snippet}"
                )
                citations.append(Citation(source_type="aqidah", reference=ev.reference))

        # Build natural 3-part answer without generic phrasing
        section_answer = direct_answer
        section_evidence = "\n".join(evidence_lines[:5])
        section_explanation = self._build_explanation_block(question, matches)
        
        answer = "\n\n".join([section_answer, section_evidence, section_explanation])

        if not self.validate_output(answer, citations):
            return AskResponse(answer=ALLAHU_ALAM, citations=[], rejected=True)

        return AskResponse(answer=answer, citations=citations, rejected=False)


def enforce_required_datasets(engine: StrictIslamicEngine) -> None:
    presence = engine.dataset_presence()
    missing = [name for name, exists in presence.items() if not exists]
    if not missing:
        return

    required_files = ", ".join(ALLOWED_DATASETS.values())
    missing_list = ", ".join(missing)
    data_hint = (
        "Place files in project root, ./data, or set ISLAMICGPT_DATA_DIR "
        "to the dataset directory."
    )
    raise RuntimeError(
        "Strict startup validation failed. Missing required datasets: "
        f"{missing_list}. Required files: {required_files}. {data_hint}"
    )


app = FastAPI(title="Strict Islamic AI", version="1.0.0")
engine = StrictIslamicEngine(base_dir=Path(__file__).resolve().parent.parent)
enforce_required_datasets(engine)
WEB_DIR = Path(__file__).resolve().parent.parent / "web"

if WEB_DIR.exists():
    app.mount("/web", StaticFiles(directory=WEB_DIR), name="web")


@app.get("/")
def home() -> FileResponse:
    return FileResponse(WEB_DIR / "index.html")


@app.get("/health")
def health() -> dict[str, Any]:
    return {
        "status": "ok",
        "records_loaded": len(engine.records),
        "datasets": ALLOWED_DATASETS,
        "dataset_presence": engine.dataset_presence(),
        "source_counts": engine.source_counts,
        "retrieval_mode": "strict-keyword",
    }


@app.post("/ask", response_model=AskResponse)
def ask(req: AskRequest) -> AskResponse:
    return engine.answer(req.question)


if __name__ == "__main__":
    import uvicorn

    uvicorn.run(app, host="127.0.0.1", port=8000, reload=False)

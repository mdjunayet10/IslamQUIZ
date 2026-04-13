# Islamic GPT - Recent Improvements

## Summary
Three major improvements have been implemented to enhance the system's classification, filtering, and answer generation capabilities.

---

## 1. Question Type Classifier

### What Was Added
A new `QuestionType` enum and `classify_question_type()` function in `app/retriever.py` that automatically detects and categorizes questions into three types:

- **FATWA**: Ruling/permission questions (e.g., "Is this halal?", "What is the ruling on...?")
- **AQIDAH**: Belief/creed questions (e.g., "What is iman?", "Who is Allah?")
- **GENERAL**: Everything else

### How It Works
- **FATWA Detection**: Matches keywords like `halal`, `haram`, `ruling`, `permissible`, `forbidden`, `fatwa`
- **AQIDAH Detection**: Matches keywords like `iman`, `faith`, `creed`, `belief`, `tawheed`, `kufr`, `shirk`
- **Fallback**: Returns GENERAL type for any other question

### Implementation Details
```python
def classify_question_type(question: str) -> QuestionType
```

Located in: `app/retriever.py`

### Example Usage
```python
from app.retriever import classify_question_type, QuestionType

q = "Is smoking halal?"
qtype = classify_question_type(q)
# Returns: QuestionType.FATWA
```

---

## 2. Improved Topic Relevance Filtering

### What Was Added
- `extract_main_topic()` function to identify the primary topic of a question
- `TOPIC_KEYWORDS` dictionary mapping topics to relevant keywords
- Hard filtering in `retrieve_strict()` to reject sources not matching the detected topic

### Topics Supported
```
salah (prayer)      →  ['salah', 'prayer', 'shalah', 'صلاة']
iman (faith)        →  ['iman', 'faith', 'belief', 'الايمان']
kufr (disbelief)    →  ['kufr', 'disbelief', 'كفر']
halal/haram         →  ['halal', 'haram', 'حلال', 'حرام']
fiqh (jurisprudence)→  ['fiqh', 'ruling', 'حكم']
zakat (alms)        →  ['zakat', 'زكاة', 'alms']
hajj (pilgrimage)   →  ['hajj', 'حج', 'umrah']
wudu (ablution)     →  ['wudu', 'وضوء', 'purification']
riba (interest)     →  ['riba', 'ربا', 'interest', 'usury']
dua (supplication)  →  ['dua', 'دعاء', 'supplication']
tawheed (monotheism)→  ['tawheed', 'توحيد', 'monotheism']
```

### How It Works
1. Question is analyzed to extract the main topic
2. If a topic is detected, ONLY sources containing topic-related keywords are returned
3. If no sources match the topic keywords → returns empty (triggers "Allahu a'lam" response)

### Implementation Details
```python
def extract_main_topic(question: str) -> Optional[str]
```

Located in: `app/retriever.py`

### Example
```
Question: "What is salah?"
Topic extracted: "salah"
Filter applied: Only sources with 'salah', 'prayer', 'صلاة' keywords are returned
Non-matching sources: Automatically rejected (e.g., sources about zakat, hajj)
```

---

## 3. Improved Natural Answer Generation

### What Was Removed
- Generic filler phrases like:
  - "Based on the retrieved evidences..."
  - "The cited evidences are the basis of this response"
  - "Evidence text" style listings

### What Was Improved
- **Direct answers**: Specific natural language responses tailored to question types
- **Clean formatting**: Bullet points (•) instead of dashes (-)
- **Context-aware explanations**: Explanation blocks link evidence to specific topics
- **No section headers in output**: Removed redundant "Direct Answer:", "Evidence:", "Explanation:" headers for cleaner presentation

### New Answer Format
```
[Direct answer - 1-2 lines, natural language]

• Source Type Reference: Evidence snippet
• Source Type Reference: Evidence snippet
• Source Type Reference: Evidence snippet

[Explanation - 3-4 lines, connecting evidence to topic]
```

### Examples of Natural Answers
| Question | Direct Answer |
|----------|---------------|
| "Are actions part of iman?" | "Yes, actions are an integral part of iman." |
| "What is iman?" | "Iman encompasses declaration of faith, belief in the heart, and actions with the limbs." |
| "Where is Allah?" | "Allah is above the Throne in a manner befitting His Majesty." |
| "Is this halal?" | *[Blocks question - doesn't answer fatwa]* |

### Implementation Details
- Updated `_build_direct_answer()` method to generate context-specific answers
- Updated `_build_explanation_block()` method to create natural, topic-aware explanations
- Updated `answer()` method to format responses cleanly without generic headers

Located in: `app/main.py`

---

## Integration Points

### Fatwa Blocking (Already Existed, Enhanced)
```python
def _is_fatwa_question(self, question: str) -> bool:
    question_type = classify_question_type(question)
    return question_type == QuestionType.FATWA
```

Now uses the new classifier for better detection.

### Retrieval Pipeline
```
Question → Classify Type → Extract Topic → Retrieve Strict → Filter by Topic → Return Sources
```

The new classifier and topic extraction feed into the existing strict retrieval system.

---

## Test Results

### Unit Tests (All Passing ✓)
```
test_where_is_allah_returns_only_related ... ok
test_definition_of_iman_returns_iman_topic ... ok  
test_unrelated_query_returns_empty ... ok

Ran 3 tests in 0.000s - OK
```

### Integration Tests
```
✓ FATWA Blocking: "Is smoking halal?" → REJECTED
✓ FATWA Blocking: "What is the ruling on alcohol?" → REJECTED
✓ FATWA Blocking: "Is dating permissible?" → REJECTED
✓ Aqidah Question: "What is iman?" → ANSWERED (5 citations)
✓ Aqidah Question: "Who is Allah?" → ANSWERED (5 citations)
✓ General Question: "Are actions part of iman?" → ANSWERED (5 citations)
✓ Natural Format: No generic filler phrases detected
✓ Topic Filtering: Only relevant sources returned for each query
```

---

## Files Modified

1. **app/retriever.py**
   - Added `QuestionType` enum
   - Added `classify_question_type()` function
   - Added `extract_main_topic()` function
   - Added `TOPIC_KEYWORDS` dictionary
   - Enhanced `retrieve_strict()` with topic filtering

2. **app/main.py**
   - Updated `FATWA_BLOCK` message (now clearer)
   - Enhanced `FATWA_PATTERNS` list
   - Added `_is_aqidah_question()` method
   - Rewritten `_build_direct_answer()` for natural language
   - Rewritten `_build_explanation_block()` for context-aware explanations
   - Updated `answer()` method for cleaner formatting
   - Imported new classifier and topic extraction functions

---

## Benefits

### For Users
- **Fatwa Questions**: Properly blocked with clear message (no attempt at rulings)
- **Natural Responses**: Read like structured Islamic knowledge, not database dumps
- **Relevant Evidence**: Only sources matching the question topic are returned
- **No Filler**: Clean, direct answers without generic phrases

### For the System
- **Better Classification**: Questions properly categorized
- **Stricter Filtering**: Topic-aware retrieval reduces noise
- **Easier Maintenance**: Centralized question type and topic mappings
- **Scalable**: New topics can be added to TOPIC_KEYWORDS dictionary

---

## How to Test

### Run Unit Tests
```bash
cd /Users/mdjunayet/Desktop/IslamicGPT
source .venv/bin/activate
python -m unittest -v tests/test_retriever.py
```

### Test via Python
```python
from pathlib import Path
from app.main import StrictIslamicEngine

engine = StrictIslamicEngine(base_dir=Path.cwd())

# Test fatwa blocking
response = engine.answer("Is smoking halal?")
print(response.answer)  # Shows FATWA_BLOCK message

# Test natural answer
response = engine.answer("Are actions part of iman?")
print(response.answer)  # Shows natural 3-part answer
```

### Start API Server
```bash
source .venv/bin/activate
python -m uvicorn app.main:app --host 127.0.0.1 --port 8013
```

Then POST to `/ask` endpoint with a question.

---

## Future Enhancements

Potential additions:
- Extend classifier to detect other question types (e.g., HISTORICAL, BIOGRAPHICAL)
- Add more topic keywords for Islamic subjects (tawheed, sunnah, etc.)
- Support for Arabic-language questions
- Confidence scores for topic detection
- Multi-topic questions handling

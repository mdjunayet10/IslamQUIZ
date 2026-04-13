# Islamic AI (Dataset-Only)

This project implements a strict Islamic retrieval API with FastAPI.

Retrieval uses a hybrid method:
- lexical matching
- local TF-IDF vector similarity (semantic search)

## Principles enforced in code

- Uses only local JSON datasets:
  - `quran.json`
  - `hadith.json`
  - `tafsir_ibn_kathir.json`
  - `aqidah.json`
- Rejects hadith unless grading is `Sahih` or `Hasan`.
- Rejects unknown source types.
- Refuses fatwa-style questions.
- Requires at least one valid citation for every response.
- If validation fails, returns: `Allahu a'lam`

## Run

1. Install dependencies:

```bash
pip install -r requirements.txt
```

2. Place datasets in either:
   - project root, or
   - `data/` folder

3. Start server:

```bash
uvicorn app.main:app --reload
```

4. API docs:
   - `http://127.0.0.1:8000/docs`

## API

### POST `/ask`

Request:

```json
{
  "question": "What does the Qur'an say about patience?"
}
```

Response:

```json
{
  "answer": "...",
  "citations": [...],
  "rejected": false
}
```

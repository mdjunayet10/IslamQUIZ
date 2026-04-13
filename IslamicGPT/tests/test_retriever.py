import unittest

from app.retriever import RetrievalItem
from app.retriever import retrieve_strict


class TestStrictRetriever(unittest.TestCase):
    def test_where_is_allah_returns_only_related(self):
        items = [
            RetrievalItem(
                source_type="aqidah",
                text="Allah is above the Throne as befits His Majesty.",
                reference="Aqidah:1",
                keywords=["Allah", "above", "throne", "السماء"],
            ),
            RetrievalItem(
                source_type="hadith",
                text="Allah is Merciful and Forgiving.",
                reference="Generic:1",
                keywords=["allah", "mercy"],
                collection="Sahih Muslim",
                number="1",
                grading="Sahih",
            ),
            RetrievalItem(
                source_type="quran",
                text="Seek help through patience and prayer.",
                reference="2:153",
                keywords=["patience", "prayer"],
            ),
            RetrievalItem(
                source_type="hadith",
                text="Whoever follows a path seeking knowledge...",
                reference="Muslim #2699",
                keywords=["knowledge"],
                collection="Sahih Muslim",
                number="2699",
                grading="Sahih",
            ),
        ]

        result = retrieve_strict("Where is Allah?", items, top_k=5, min_score=1.0)
        refs = [x.reference for x, _ in result]

        self.assertIn("Aqidah:1", refs)
        self.assertNotIn("Generic:1", refs)
        self.assertNotIn("2:153", refs)
        self.assertNotIn("Muslim #2699", refs)

    def test_definition_of_iman_returns_iman_topic(self):
        items = [
            RetrievalItem(
                source_type="hadith",
                text="Hadith Jibril: Iman is to believe in Allah, His angels, His books, His messengers, the Last Day, and divine decree.",
                reference="Muslim #8",
                keywords=["iman", "jibril", "faith"],
                collection="Sahih Muslim",
                number="8",
                grading="Sahih",
            ),
            RetrievalItem(
                source_type="quran",
                text="Indeed, with hardship will be ease.",
                reference="94:5",
                keywords=["hardship", "ease"],
            ),
        ]

        result = retrieve_strict("Definition of iman", items, top_k=5, min_score=1.0)
        refs = [x.reference for x, _ in result]

        self.assertEqual(refs, ["Muslim #8"])

    def test_unrelated_query_returns_empty(self):
        items = [
            RetrievalItem(
                source_type="quran",
                text="Seek help through patience and prayer.",
                reference="2:153",
                keywords=["patience", "prayer"],
            ),
            RetrievalItem(
                source_type="hadith",
                text="Whoever follows a path seeking knowledge...",
                reference="Muslim #2699",
                keywords=["knowledge"],
                collection="Sahih Muslim",
                number="2699",
                grading="Sahih",
            ),
        ]

        result = retrieve_strict("Quantum entanglement in physics", items, top_k=5, min_score=1.0)
        self.assertEqual(result, [])


if __name__ == "__main__":
    unittest.main()

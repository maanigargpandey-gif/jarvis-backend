import pinecone
from typing import List, Dict, Any
from core.config import settings
import hashlib
import time

class PineconeService:
    index = None
    
    @classmethod
    async def initialize(cls):
        try:
            pinecone.init(
                api_key=settings.PINECONE_API_KEY,
                environment=settings.PINECONE_ENVIRONMENT
            )
            if settings.PINECONE_INDEX_NAME not in pinecone.list_indexes():
                pinecone.create_index(
                    name=settings.PINECONE_INDEX_NAME,
                    dimension=1536,
                    metric="cosine"
                )
            cls.index = pinecone.Index(settings.PINECONE_INDEX_NAME)
            print("✅ Pinecone Memory initialized")
        except Exception as e:
            print(f"⚠️ Pinecone initialization failed: {e}")
    
    @classmethod
    async def store_memory(cls, query: str, response: str, metadata: Dict = None) -> bool:
        if not cls.index:
            return False
        try:
            memory_id = hashlib.md5(f"{query}:{time.time()}".encode()).hexdigest()
            vector = cls._text_to_vector(query)
            cls.index.upsert(vectors=[(
                memory_id,
                vector,
                {
                    "query": query,
                    "response": response,
                    "timestamp": time.time(),
                    **(metadata or {})
                }
            )])
            return True
        except Exception as e:
            print(f"Memory storage error: {e}")
            return False
    
    @classmethod
    async def search_memory(cls, query: str, top_k: int = 5) -> List[Dict]:
        if not cls.index:
            return []
        try:
            vector = cls._text_to_vector(query)
            results = cls.index.query(vector=vector, top_k=top_k, include_metadata=True)
            memories = []
            for match in results.matches:
                memories.append({
                    "score": match.score,
                    "query": match.metadata.get("query", ""),
                    "response": match.metadata.get("response", ""),
                    "timestamp": match.metadata.get("timestamp", 0)
                })
            return memories
        except Exception as e:
            print(f"Memory search error: {e}")
            return []
    
    @classmethod
    async def get_status(cls) -> str:
        if cls.index:
            try:
                stats = cls.index.describe_index_stats()
                return f"Active - {stats.total_vector_count} memories stored"
            except:
                return "Degraded"
        return "Not initialized"
    
    @staticmethod
    def _text_to_vector(text: str, dimension: int = 1536) -> List[float]:
        hash_bytes = hashlib.sha256(text.encode()).digest()
        vector = []
        for i in range(dimension):
            byte_index = i % len(hash_bytes)
            vector.append(float(hash_bytes[byte_index]) / 255.0)
        return vector
    
    @classmethod
    async def cleanup(cls):
        if cls.index:
            print("Cleaning up Pinecone connection...")
          

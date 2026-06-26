from fastapi import APIRouter, HTTPException, Depends
from pydantic import BaseModel
from typing import List, Optional
from datetime import datetime, timedelta
import hashlib
from core.dependencies import verify_creator

router = APIRouter()

class SocialPost(BaseModel):
    content: str
    platforms: List[str]
    media_urls: Optional[List[str]] = []
    hashtags: Optional[List[str]] = []
    schedule_time: Optional[str] = None
    is_story: bool = False

class HashtagRequest(BaseModel):
    topic: str
    platform: str = "instagram"
    count: int = 10

@router.post("/generate-hashtags")
async def generate_hashtags(request: HashtagRequest):
    hashtag_templates = {
        "tech": ["#TechTrends", "#AI", "#Innovation", "#FutureTech", "#DigitalTransformation"],
        "business": ["#Business", "#Entrepreneur", "#Success", "#Leadership", "#Strategy"],
        "creative": ["#Creative", "#Art", "#Design", "#Inspiration", "#ContentCreator"],
        "lifestyle": ["#Lifestyle", "#Motivation", "#Goals", "#Mindset", "#Growth"]
    }
    
    base_hashtags = []
    topic_lower = request.topic.lower()
    
    for category, tags in hashtag_templates.items():
        if category in topic_lower:
            base_hashtags.extend(tags)
    
    unique_hashtags = [
        f"#{request.topic.replace(' ', '')}",
        f"#{request.topic.replace(' ', '')}Tips",
        f"#{request.topic.replace(' ', '')}Community",
        f"#{request.platform.capitalize()}Growth",
        "#ViralContent",
        "#DigitalCreator"
    ]
    
    all_hashtags = list(set(base_hashtags + unique_hashtags))[:request.count]
    
    return {
        "status": "success",
        "hashtags": all_hashtags,
        "suggested_caption": f"🚀 {request.topic} - Level up your game!",
        "best_posting_time": "7:00 PM - 9:00 PM (Peak Engagement)",
        "engagement_prediction": "High"
    }

@router.post("/schedule-post")
async def schedule_post(post: SocialPost, creator: bool = Depends(verify_creator)):
    if not creator:
        raise HTTPException(status_code=403, detail="Creator access required")
    
    scheduled_posts = []
    for platform in post.platforms:
        post_id = hashlib.md5(
            f"{platform}:{post.content}:{datetime.now()}".encode()
        ).hexdigest()[:12]
        
        scheduled_posts.append({
            "post_id": post_id,
            "platform": platform,
            "content": post.content,
            "scheduled_for": post.schedule_time or str(datetime.now() + timedelta(hours=2)),
            "status": "scheduled"
        })
    
    return {
        "status": "success",
        "posts": scheduled_posts,
        "total_platforms": len(post.platforms),
        "message": f"Successfully scheduled {len(scheduled_posts)} posts"
    }
  

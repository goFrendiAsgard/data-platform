from typing import List, Optional
from pydantic import BaseModel
import datetime

class ContentData(BaseModel):
    title: str
    url: str
    description: str
    created_at: Optional[datetime.datetime]
    created_by: Optional[str]
    updated_at: Optional[datetime.datetime]
    updated_by: Optional[str]


class Content(ContentData):
    id: str
    class Config:
        orm_mode = True


class ContentResult(BaseModel):
    count: int
    rows: List[Content]
from typing import List, Optional
from pydantic import BaseModel
import datetime

class ViewData(BaseModel):
    content_id: str
    session_id: str
    user_id: str
    created_at: Optional[datetime.datetime]
    created_by: Optional[str]
    updated_at: Optional[datetime.datetime]
    updated_by: Optional[str]


class View(ViewData):
    id: str
    class Config:
        orm_mode = True


class ViewResult(BaseModel):
    count: int
    rows: List[View]
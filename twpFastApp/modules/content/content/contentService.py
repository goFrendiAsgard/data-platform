from typing import Optional
from schemas.content import Content, ContentData, ContentResult
from modules.content.content.repos.contentRepo import ContentRepo

class ContentService():

    def __init__(self, content_repo: ContentRepo):
        self.content_repo = content_repo

    def find(self, keyword: str, limit: int, offset: int) -> ContentResult:
        count = self.content_repo.count(keyword)
        rows = self.content_repo.find(keyword, limit, offset)
        return ContentResult(count=count, rows=rows)

    def find_by_id(self, id: str) -> Optional[Content]:
        return self.content_repo.find_by_id(id)

    def insert(self, content_data: ContentData) -> Optional[Content]:
        return self.content_repo.insert(content_data)

    def update(self, id: str, content_data: ContentData) -> Optional[Content]:
        return self.content_repo.update(id, content_data)

    def delete(self, id: str) -> Optional[Content]:
        return self.content_repo.delete(id)
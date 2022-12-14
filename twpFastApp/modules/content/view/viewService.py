from helpers.transport import MessageBus
from typing import Optional
from schemas.view import View, ViewData, ViewResult
from modules.content.view.repos.viewRepo import ViewRepo

class ViewService():

    def __init__(self, mb: MessageBus, view_repo: ViewRepo):
        self.view_repo = view_repo
        self.mb = mb

    def find(self, keyword: str, limit: int, offset: int) -> ViewResult:
        count = self.view_repo.count(keyword)
        rows = self.view_repo.find(keyword, limit, offset)
        return ViewResult(count=count, rows=rows)

    def find_by_id(self, id: str) -> Optional[View]:
        return self.view_repo.find_by_id(id)

    def insert(self, view_data: ViewData) -> Optional[View]:
        view = self.view_repo.insert(view_data)
        self.mb.publish('view_content', view.dict())
        return view

    def update(self, id: str, view_data: ViewData) -> Optional[View]:
        return self.view_repo.update(id, view_data)

    def delete(self, id: str) -> Optional[View]:
        return self.view_repo.delete(id)
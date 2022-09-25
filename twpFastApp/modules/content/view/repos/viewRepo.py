from typing import List, Mapping, Optional
from schemas.view import View, ViewData

import abc

class ViewRepo(abc.ABC):

    @abc.abstractmethod
    def find_by_id(self, id: str) -> Optional[View]:
        pass

    @abc.abstractmethod
    def find(self, keyword: str, limit: int, offset: int) -> List[View]:
        pass

    @abc.abstractmethod
    def count(self, keyword: str) -> int:
        pass

    @abc.abstractmethod
    def insert(self, view_data: ViewData) -> Optional[View]:
        pass

    @abc.abstractmethod
    def update(self, id: str, view_data: ViewData) -> Optional[View]:
        pass

    @abc.abstractmethod
    def delete(self, id: str) -> Optional[View]:
        pass
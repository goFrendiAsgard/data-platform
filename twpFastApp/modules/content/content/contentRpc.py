from typing import Any, Optional, Mapping
from helpers.transport import RPC
from schemas.content import Content, ContentData
from schemas.user import User
from modules.content.content.repos.contentRepo import ContentRepo
from modules.content.content.contentService import ContentService

def register_content_entity_rpc(rpc: RPC, content_repo: ContentRepo):

    content_service = ContentService(content_repo)

    @rpc.handle('find_content')
    def find_contents(keyword: str, limit: int, offset: int) -> Mapping[str, Any]:
        content_result = content_service.find(keyword, limit, offset)
        return content_result.dict()

    @rpc.handle('find_content_by_id')
    def find_content_by_id(id: str) -> Optional[Mapping[str, Any]]:
        content = content_service.find_by_id(id)
        return None if content is None else content.dict()

    @rpc.handle('insert_content')
    def insert_content(content_data: Mapping[str, Any], current_user_data: Mapping[str, Any]) -> Optional[Mapping[str, Any]]:
        current_user = User.parse_obj(current_user_data)
        content = ContentData.parse_obj(content_data) 
        content.created_by = current_user.id
        content.updated_by = current_user.id
        new_content = content_service.insert(content)
        return None if new_content is None else new_content.dict()

    @rpc.handle('update_content')
    def update_content(id: str, content_data: Mapping[str, Any], current_user_data: Mapping[str, Any]) -> Optional[Mapping[str, Any]]:
        current_user = User.parse_obj(current_user_data)
        content = ContentData.parse_obj(content_data) 
        content.updated_by = current_user.id
        updated_content = content_service.update(id, content)
        return None if updated_content is None else updated_content.dict()

    @rpc.handle('delete_content')
    def delete_content(id: str, current_user_data: Mapping[str, Any]) -> Optional[Mapping[str, Any]]:
        content = content_service.delete(id)
        return None if content is None else content.dict()

    print('Handle RPC for content.Content')
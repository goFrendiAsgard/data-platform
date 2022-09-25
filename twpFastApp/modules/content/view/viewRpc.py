from typing import Any, Optional, Mapping
from helpers.transport import RPC, MessageBus
from schemas.view import View, ViewData
from schemas.user import User
from modules.content.view.repos.viewRepo import ViewRepo
from modules.content.view.viewService import ViewService

def register_view_entity_rpc(rpc: RPC, mb: MessageBus, view_repo: ViewRepo):

    view_service = ViewService(mb, view_repo)

    @rpc.handle('find_view')
    def find_views(keyword: str, limit: int, offset: int) -> Mapping[str, Any]:
        view_result = view_service.find(keyword, limit, offset)
        return view_result.dict()

    @rpc.handle('find_view_by_id')
    def find_view_by_id(id: str) -> Optional[Mapping[str, Any]]:
        view = view_service.find_by_id(id)
        return None if view is None else view.dict()

    @rpc.handle('insert_view')
    def insert_view(view_data: Mapping[str, Any], current_user_data: Mapping[str, Any]) -> Optional[Mapping[str, Any]]:
        current_user = User.parse_obj(current_user_data)
        view = ViewData.parse_obj(view_data) 
        if view.user_id is None or view.user_id == '':
            view.user_id = current_user.id
        view.created_by = current_user.id
        new_view = view_service.insert(view)
        return None if new_view is None else new_view.dict()

    @rpc.handle('update_view')
    def update_view(id: str, view_data: Mapping[str, Any], current_user_data: Mapping[str, Any]) -> Optional[Mapping[str, Any]]:
        current_user = User.parse_obj(current_user_data)
        view = ViewData.parse_obj(view_data) 
        view.updated_by = current_user.id
        updated_view = view_service.update(id, view)
        return None if updated_view is None else updated_view.dict()

    @rpc.handle('delete_view')
    def delete_view(id: str, current_user_data: Mapping[str, Any]) -> Optional[Mapping[str, Any]]:
        view = view_service.delete(id)
        return None if view is None else view.dict()

    print('Handle RPC for content.View')
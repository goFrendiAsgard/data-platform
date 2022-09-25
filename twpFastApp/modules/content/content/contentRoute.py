from typing import Any, List, Mapping
from helpers.transport import MessageBus, RPC
from fastapi import Depends, FastAPI, Request, HTTPException
from fastapi.security import OAuth2
from modules.auth import AuthService
from fastapi.responses import HTMLResponse
from fastapi.templating import Jinja2Templates
from modules.ui import MenuService
from schemas.content import Content, ContentData, ContentResult
from schemas.menuContext import MenuContext
from schemas.user import User

import traceback
import sys

################################################
# -- ⚙️ API
################################################
def register_content_entity_api_route(app: FastAPI, mb: MessageBus, rpc: RPC, auth_service: AuthService):

    @app.get('/api/v1/contents/', response_model=ContentResult)
    def find_contents(keyword: str='', limit: int=100, offset: int=0, current_user:  User = Depends(auth_service.is_authorized('api:content:read'))) -> ContentResult:
        result = {}
        try:
            result = rpc.call('find_content', keyword, limit, offset)
        except:
            print(traceback.format_exc(), file=sys.stderr) 
            raise HTTPException(status_code=500, detail='Internal Server Error')
        return ContentResult.parse_obj(result)


    @app.get('/api/v1/contents/{id}', response_model=Content)
    def find_content_by_id(id: str, current_user:  User = Depends(auth_service.is_authorized('api:content:read'))) -> Content:
        content = None
        try:
            content = rpc.call('find_content_by_id', id)
        except:
            print(traceback.format_exc(), file=sys.stderr) 
            raise HTTPException(status_code=500, detail='Internal Server Error')
        if content is None:
            raise HTTPException(status_code=404, detail='Not Found')
        return Content.parse_obj(content)


    @app.post('/api/v1/contents/', response_model=Content)
    def insert_content(content_data: ContentData, current_user:  User = Depends(auth_service.is_authorized('api:content:create'))) -> Content:
        content = None
        try:
            content = rpc.call('insert_content', content_data.dict(), current_user.dict())
        except:
            print(traceback.format_exc(), file=sys.stderr) 
            raise HTTPException(status_code=500, detail='Internal Server Error')
        if content is None:
            raise HTTPException(status_code=404, detail='Not Found')
        return Content.parse_obj(content)


    @app.put('/api/v1/contents/{id}', response_model=Content)
    def update_content(id: str, content_data: ContentData, current_user:  User = Depends(auth_service.is_authorized('api:content:update'))) -> Content:
        content = None
        try:
            content = rpc.call('update_content', id, content_data.dict(), current_user.dict())
        except:
            print(traceback.format_exc(), file=sys.stderr) 
            raise HTTPException(status_code=500, detail='Internal Server Error')
        if content is None:
            raise HTTPException(status_code=404, detail='Not Found')
        return Content.parse_obj(content)


    @app.delete('/api/v1/contents/{id}')
    def delete_content(id: str, current_user:  User = Depends(auth_service.is_authorized('api:content:delete'))) -> Content:
        content = None
        try:
            content = rpc.call('delete_content', id, current_user.dict())
        except:
            print(traceback.format_exc(), file=sys.stderr) 
            raise HTTPException(status_code=500, detail='Internal Server Error')
        if content is None:
            raise HTTPException(status_code=404, detail='Not Found')
        return Content.parse_obj(content)


################################################
# -- 👓 User Interface
################################################
def register_content_entity_ui_route(app: FastAPI, mb: MessageBus, rpc: RPC, menu_service: MenuService, page_template: Jinja2Templates):

    @app.get('/content/contents', response_class=HTMLResponse)
    async def user_interface(request: Request, context: MenuContext = Depends(menu_service.authenticate('content:contents'))):
        return page_template.TemplateResponse('default_crud.html', context={
            'api_path': '/api/vi/ztp_app_crud_entities',
            'content_path': 'content/crud/contents.html',
            'request': request, 
            'context': context
        }, status_code=200)

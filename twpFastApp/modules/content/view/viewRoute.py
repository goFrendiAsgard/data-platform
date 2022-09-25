from typing import Any, List, Mapping
from helpers.transport import MessageBus, RPC
from fastapi import Depends, FastAPI, Request, HTTPException
from fastapi.security import OAuth2
from modules.auth import AuthService
from fastapi.responses import HTMLResponse
from fastapi.templating import Jinja2Templates
from modules.ui import MenuService
from schemas.view import View, ViewData, ViewResult
from schemas.menuContext import MenuContext
from schemas.user import User

import traceback
import sys

################################################
# -- ⚙️ API
################################################
def register_view_entity_api_route(app: FastAPI, mb: MessageBus, rpc: RPC, auth_service: AuthService):

    @app.get('/api/v1/views/', response_model=ViewResult)
    def find_views(keyword: str='', limit: int=100, offset: int=0, current_user:  User = Depends(auth_service.is_authorized('api:view:read'))) -> ViewResult:
        result = {}
        try:
            result = rpc.call('find_view', keyword, limit, offset)
        except:
            print(traceback.format_exc(), file=sys.stderr) 
            raise HTTPException(status_code=500, detail='Internal Server Error')
        return ViewResult.parse_obj(result)


    @app.get('/api/v1/views/{id}', response_model=View)
    def find_view_by_id(id: str, current_user:  User = Depends(auth_service.is_authorized('api:view:read'))) -> View:
        view = None
        try:
            view = rpc.call('find_view_by_id', id)
        except:
            print(traceback.format_exc(), file=sys.stderr) 
            raise HTTPException(status_code=500, detail='Internal Server Error')
        if view is None:
            raise HTTPException(status_code=404, detail='Not Found')
        return View.parse_obj(view)


    @app.post('/api/v1/views/', response_model=View)
    def insert_view(view_data: ViewData, current_user:  User = Depends(auth_service.is_authorized('api:view:create'))) -> View:
        view = None
        try:
            view = rpc.call('insert_view', view_data.dict(), current_user.dict())
        except:
            print(traceback.format_exc(), file=sys.stderr) 
            raise HTTPException(status_code=500, detail='Internal Server Error')
        if view is None:
            raise HTTPException(status_code=404, detail='Not Found')
        return View.parse_obj(view)


    @app.put('/api/v1/views/{id}', response_model=View)
    def update_view(id: str, view_data: ViewData, current_user:  User = Depends(auth_service.is_authorized('api:view:update'))) -> View:
        view = None
        try:
            view = rpc.call('update_view', id, view_data.dict(), current_user.dict())
        except:
            print(traceback.format_exc(), file=sys.stderr) 
            raise HTTPException(status_code=500, detail='Internal Server Error')
        if view is None:
            raise HTTPException(status_code=404, detail='Not Found')
        return View.parse_obj(view)


    @app.delete('/api/v1/views/{id}')
    def delete_view(id: str, current_user:  User = Depends(auth_service.is_authorized('api:view:delete'))) -> View:
        view = None
        try:
            view = rpc.call('delete_view', id, current_user.dict())
        except:
            print(traceback.format_exc(), file=sys.stderr) 
            raise HTTPException(status_code=500, detail='Internal Server Error')
        if view is None:
            raise HTTPException(status_code=404, detail='Not Found')
        return View.parse_obj(view)


################################################
# -- 👓 User Interface
################################################
def register_view_entity_ui_route(app: FastAPI, mb: MessageBus, rpc: RPC, menu_service: MenuService, page_template: Jinja2Templates):

    @app.get('/content/views', response_class=HTMLResponse)
    async def user_interface(request: Request, context: MenuContext = Depends(menu_service.authenticate('content:views'))):
        return page_template.TemplateResponse('default_crud.html', context={
            'api_path': '/api/vi/ztp_app_crud_entities',
            'content_path': 'content/crud/views.html',
            'request': request, 
            'context': context
        }, status_code=200)

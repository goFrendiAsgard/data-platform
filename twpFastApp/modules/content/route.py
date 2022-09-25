from modules.content.view.viewRoute import register_view_entity_api_route, register_view_entity_ui_route
from modules.content.content.contentRoute import register_content_entity_api_route, register_content_entity_ui_route
from typing import Mapping, List, Any
from fastapi import Depends, FastAPI, Request, HTTPException
from fastapi.responses import HTMLResponse
from fastapi.templating import Jinja2Templates
from schemas.menuContext import MenuContext
from schemas.user import User
from modules.auth import AuthService
from modules.ui import MenuService
from helpers.transport import MessageBus, RPC

import traceback
import sys


################################################
# -- ⚙️ API
################################################
def register_content_api_route(app: FastAPI, mb: MessageBus, rpc: RPC, auth_service: AuthService):

    register_view_entity_api_route(app, mb, rpc, auth_service)

    register_content_entity_api_route(app, mb, rpc, auth_service)

    print('Register content api route handler')


################################################
# -- 👓 User Interface
################################################
def register_content_ui_route(app: FastAPI, mb: MessageBus, rpc: RPC, menu_service: MenuService, page_template: Jinja2Templates):

    @app.get('/', response_class=HTMLResponse)
    async def get_index(request: Request, context: MenuContext = Depends(menu_service.authenticate('content:/index'))) -> HTMLResponse:
        '''
        Handle (get) /index
        '''
        try:
            return page_template.TemplateResponse('default_page.html', context={
                'request': request,
                'context': context,
                'content_path': 'content/index.html'
            }, status_code=200)
        except:
            print(traceback.format_exc(), file=sys.stderr) 
            return page_template.TemplateResponse('default_error.html', context={
                'request': request,
                'status_code': 500,
                'detail': 'Internal server error'
            }, status_code=500)

    register_view_entity_ui_route(app, mb, rpc, menu_service, page_template)

    register_content_entity_ui_route(app, mb, rpc, menu_service, page_template)

    print('Register content api route handler')
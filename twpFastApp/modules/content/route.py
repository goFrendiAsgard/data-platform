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

    register_content_entity_api_route(app, mb, rpc, auth_service)

    print('Register content api route handler')


################################################
# -- 👓 User Interface
################################################
def register_content_ui_route(app: FastAPI, mb: MessageBus, rpc: RPC, menu_service: MenuService, page_template: Jinja2Templates):

    register_content_entity_ui_route(app, mb, rpc, menu_service, page_template)

    print('Register content api route handler')
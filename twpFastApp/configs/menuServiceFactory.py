from modules.auth import AuthService
from helpers.transport import RPC
from schemas.authType import AuthType
from modules.ui import MenuService

def create_menu_service(rpc: RPC, auth_service: AuthService) -> MenuService:
    menu_service = MenuService(rpc, auth_service)
    menu_service.add_menu(name='account', title='Account', url='#', auth_type=AuthType.EVERYONE)
    menu_service.add_menu(name='account:login', title='Log in', url='/account/login', auth_type=AuthType.UNAUTHENTICATED, parent_name='account')
    menu_service.add_menu(name='account:logout', title='Log out', url='/account/logout', auth_type=AuthType.AUTHENTICATED, parent_name='account')
    menu_service.add_menu(name='auth', title='Security', url='#', auth_type=AuthType.EVERYONE)
    menu_service.add_menu(name='auth:roles', title='Roles', url='/auth/roles', auth_type=AuthType.AUTHORIZED, permission_name='ui:auth:role', parent_name='auth')
    menu_service.add_menu(name='auth:users', title='Users', url='/auth/users', auth_type=AuthType.AUTHORIZED, permission_name='ui:auth:user', parent_name='auth')
    menu_service.add_menu(name='content', title='Content', url='#', auth_type=AuthType.EVERYONE)
    menu_service.add_menu(name='content:contents', title='Contents', url='/content/contents', auth_type=AuthType.AUTHORIZED, permission_name='ui:content:content', parent_name='content')
    menu_service.add_menu(name='content:views', title='Views', url='/content/views', auth_type=AuthType.AUTHORIZED, permission_name='ui:content:view', parent_name='content')
    menu_service.add_menu(name='content:/index', title='Home', url='/', auth_type=AuthType.EVERYONE, parent_name='content')
    return menu_service

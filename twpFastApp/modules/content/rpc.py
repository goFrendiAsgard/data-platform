from modules.content.view.repos.viewRepo import ViewRepo
from modules.content.view.viewRpc import register_view_entity_rpc
from modules.content.content.repos.contentRepo import ContentRepo
from modules.content.content.contentRpc import register_content_entity_rpc
from typing import Mapping, List, Any
from helpers.transport import RPC, MessageBus

import traceback
import sys

def register_content_rpc_handler(rpc: RPC, mb: MessageBus, content_repo: ContentRepo, view_repo: ViewRepo):

    register_view_entity_rpc(rpc, mb, view_repo)

    register_content_entity_rpc(rpc, content_repo)

    print('Register content RPC handler')

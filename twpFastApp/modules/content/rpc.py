from modules.content.content.repos.contentRepo import ContentRepo
from modules.content.content.contentRpc import register_content_entity_rpc
from typing import Mapping, List, Any
from helpers.transport import RPC

import traceback
import sys

def register_content_rpc_handler(rpc: RPC, content_repo: ContentRepo):

    register_content_entity_rpc(rpc, content_repo)

    print('Register content RPC handler')

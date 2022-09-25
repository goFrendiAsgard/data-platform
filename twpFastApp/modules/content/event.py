from typing import Mapping, List, Any
from helpers.transport import MessageBus

import traceback
import sys

def register_content_event_handler(mb: MessageBus):

    print('Register content event handler')

import re
from http.cookies import SimpleCookie
from pathlib import Path
from typing import Any, Optional, Union
from enum import IntEnum

class CurlHttpVersion(IntEnum):
    """``CURL_HTTP_VERSION`` constants extracted from libcurl, see comments for details"""

    NONE = 0
    V1_0 = 1  # please use HTTP 1.0 in the request */
    V1_1 = 2  # please use HTTP 1.1 in the request */
    V2_0 = 3  # please use HTTP 2 in the request */
    V2TLS = 4  # use version 2 for HTTPS, version 1.1 for HTTP */
    V2_PRIOR_KNOWLEDGE = 5  # please use HTTP 2 without HTTP/1.1 Upgrade */
    V3 = 30  # Makes use of explicit HTTP/3 without fallback.

class CurlWsFlag(IntEnum):
    """``CURL_WS_FLAG`` constancs extracted from libcurl, see comments for details"""

    TEXT = 1 << 0
    BINARY = 1 << 1
    CONT = 1 << 2
    CLOSE = 1 << 3
    PING = 1 << 4
    OFFSET = 1 << 5

DEFAULT_CACERT: str
REASON_PHRASE_RE: re.Pattern[str]
STATUS_LINE_RE: re.Pattern[str]

class CurlError(Exception):
    code: int
    def __init__(self, msg: Any, code: int = 0, *args, **kwargs) -> None: ...

CURLINFO_TEXT: int
CURLINFO_HEADER_IN: int
CURLINFO_HEADER_OUT: int
CURLINFO_DATA_IN: int
CURLINFO_DATA_OUT: int
CURLINFO_SSL_DATA_IN: int
CURLINFO_SSL_DATA_OUT: int
CURL_WRITEFUNC_PAUSE: int
CURL_WRITEFUNC_ERROR: int

def debug_function(curl, type: int, data, size, clientp) -> int: ...
def buffer_callback(ptr, size, nmemb, userdata): ...
def ensure_int(s): ...
def write_callback(ptr, size, nmemb, userdata): ...
def slist_to_list(head) -> list[bytes]: ...

class Curl:
    def __init__(
        self, cacert: str = "", debug: bool = False, handle: Optional[Any] = None
    ) -> None: ...
    def debug(self) -> None: ...
    def __del__(self) -> None: ...
    def setopt(self, option: int, value: Any) -> int: ...
    def getinfo(self, option: int) -> Union[bytes, int , float , list]: ...
    def version(self) -> bytes: ...
    def impersonate(self, target: str, default_headers: bool = True) -> int: ...
    def perform(self, clear_headers: bool = True) -> None: ...
    def clean_after_perform(self, clear_headers: bool = True) -> None: ...
    def duphandle(self) -> Curl: ...
    def reset(self) -> None: ...
    def parse_cookie_headers(self, headers: list[bytes]) -> SimpleCookie: ...
    @staticmethod
    def get_reason_phrase(status_line: bytes) -> bytes: ...
    @staticmethod
    def parse_status_line(status_line: bytes) -> tuple[CurlHttpVersion, int, bytes]: ...
    def close(self) -> None: ...
    def ws_recv(self, n: int = 1024) -> tuple[bytes, Any]: ...
    def ws_send(self, payload: bytes, flags: CurlWsFlag = ...) -> int: ...
    def ws_close(self) -> None: ...

class CurlMime:
    def __init__(self, curl: Optional[Curl]  = None) -> None: ...
    def addpart(
        self,
        name: str,
        *,
        content_type: Optional[str] = None,
        filename: Optional[str] = None,
        local_path: Optional[Union[str , bytes, Path]] = None,
        data: Optional[bytes] = None
    ) -> None: ...
    @classmethod
    def from_list(cls, files: list[dict]): ...
    def attach(self, curl: Optional[Curl] = None) -> None: ...
    def close(self) -> None: ...
    def __del__(self) -> None: ...

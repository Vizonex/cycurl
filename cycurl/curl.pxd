# cython: language_level=3
# cython: cdivision=True
cdef extern from "curl/curl.h" nogil:
    ctypedef struct CURL:
        pass
    CURL *curl_easy_init()
    int curl_easy_getinfo(CURL *curl, int option, void *ret)
    int curl_easy_perform(CURL *curl)
    void curl_easy_cleanup(CURL *curl)
    void curl_easy_reset(CURL *curl)
    int curl_easy_impersonate(CURL *curl, const char *target, int default_headers)
    CURL *curl_easy_duphandle(CURL *curl)

    char *curl_version()

    # slist interfaces
    struct curl_slist:
       char *data
       curl_slist *next
    curl_slist *curl_slist_append(curl_slist *list, const char *string)
    void curl_slist_free_all(curl_slist *list)

    ctypedef size_t (*buffer_callback)(char *ptr, size_t size, size_t nmemb, void *userdata)
    ctypedef size_t (*write_callback)(char *ptr, size_t size, size_t nmemb, void *userdata)
    ctypedef int (*debug_function)(CURL *curl, int type, char *data, size_t size, void *clientp)

   # multi interfaces
    ctypedef struct CURLM:
        pass

    union _msgdata:
        void *whatever # message-specific data
        int result  # return code for transfer
    struct CURLMsg:
       int msg       # what this message means
       CURL *easy_handle # the handle it concerns
       _msgdata data
    CURLM *curl_multi_init()
    int curl_multi_cleanup(CURLM *curlm)
    int curl_multi_add_handle(CURLM *curlm, CURL *curl)
    int curl_multi_remove_handle(CURLM *curlm, CURL *curl)
    int curl_multi_socket_action(CURLM *curlm, int sockfd, int ev_bitmask, int *running_handle)
    int curl_multi_setopt(CURLM *curlm, int option, void* param)
    int curl_multi_assign(CURLM *curlm, int sockfd, void *sockptr)
    int curl_multi_perform(CURLM *curlm, int *running_handle)
    CURLMsg *curl_multi_info_read(CURLM* curlm, int *msg_in_queue)

    # multi callbacks
    ctypedef int (*socket_function)(CURL *curl, int sockfd, int what, void *clientp, void *socketp)
    ctypedef int (*timer_function)(CURLM *curlm, long timeout_ms, void *clientp)
    # ws
    struct curl_ws_frame:
      int age              # zero
      int flags            # See the CURLWS_* defines
      long long offset    # the offset of this data into the frame
      long long bytesleft # number of pending bytes left of the payload
      size_t len           # size of the current data chunk
    int curl_ws_recv(CURL *curl, void *buffer, size_t buflen,
                          size_t *recv,
                          curl_ws_frame ** metap)
    int curl_ws_send(CURL *curl, const void *buffer,
                                  size_t buflen, size_t *sent,
                                  long long framesize,
                                  unsigned int sendflags)
    curl_ws_frame *curl_ws_meta(CURL *curl)

    ctypedef struct curl_mime:
        pass
    ctypedef struct curl_mimepart:
        pass
    curl_mime *curl_mime_init(CURL *easy)  # -> form
    curl_mimepart *curl_mime_addpart(curl_mime *mime)  # -> part/field
    int curl_mime_name(curl_mimepart *part, const char *name)
    int curl_mime_data(curl_mimepart *part, const char *data, size_t datasize)
    int curl_mime_type(curl_mimepart *part, const char *mimetype)
    int curl_mime_filename(curl_mimepart *part, const char *filename)
    int curl_mime_filedata(curl_mimepart *part, const char *filename)
    void curl_mime_free(curl_mime *mime)

    # consts
    int CURL_ERROR_SIZE

    int CURLOPT_WRITEDATA
    int CURLOPT_URL
    int CURLOPT_PORT
    int CURLOPT_PROXY
    int CURLOPT_USERPWD
    int CURLOPT_PROXYUSERPWD
    int CURLOPT_RANGE
    int CURLOPT_READDATA
    int CURLOPT_ERRORBUFFER
    int CURLOPT_WRITEFUNCTION
    int CURLOPT_READFUNCTION
    int CURLOPT_TIMEOUT
    int CURLOPT_INFILESIZE
    int CURLOPT_POSTFIELDS
    int CURLOPT_REFERER
    int CURLOPT_FTPPORT
    int CURLOPT_USERAGENT
    int CURLOPT_LOW_SPEED_LIMIT
    int CURLOPT_LOW_SPEED_TIME
    int CURLOPT_RESUME_FROM
    int CURLOPT_COOKIE
    int CURLOPT_HTTPHEADER
    int CURLOPT_HTTPPOST
    int CURLOPT_SSLCERT
    int CURLOPT_KEYPASSWD
    int CURLOPT_CRLF
    int CURLOPT_QUOTE
    int CURLOPT_HEADERDATA
    int CURLOPT_COOKIEFILE
    int CURLOPT_SSLVERSION
    int CURLOPT_TIMECONDITION
    int CURLOPT_TIMEVALUE
    int CURLOPT_CUSTOMREQUEST
    int CURLOPT_STDERR
    int CURLOPT_POSTQUOTE
    int CURLOPT_OBSOLETE40
    int CURLOPT_VERBOSE
    int CURLOPT_HEADER
    int CURLOPT_NOPROGRESS
    int CURLOPT_NOBODY
    int CURLOPT_FAILONERROR
    int CURLOPT_UPLOAD
    int CURLOPT_POST
    int CURLOPT_DIRLISTONLY
    int CURLOPT_APPEND
    int CURLOPT_NETRC
    int CURLOPT_FOLLOWLOCATION
    int CURLOPT_TRANSFERTEXT
    int CURLOPT_PUT
    int CURLOPT_PROGRESSFUNCTION
    int CURLOPT_XFERINFODATA
    int CURLOPT_AUTOREFERER
    int CURLOPT_PROXYPORT
    int CURLOPT_POSTFIELDSIZE
    int CURLOPT_HTTPPROXYTUNNEL
    int CURLOPT_INTERFACE
    int CURLOPT_KRBLEVEL
    int CURLOPT_SSL_VERIFYPEER
    int CURLOPT_CAINFO
    int CURLOPT_MAXREDIRS
    int CURLOPT_FILETIME
    int CURLOPT_TELNETOPTIONS
    int CURLOPT_MAXCONNECTS
    int CURLOPT_OBSOLETE72
    int CURLOPT_FRESH_CONNECT
    int CURLOPT_FORBID_REUSE
    int CURLOPT_RANDOM_FILE
    int CURLOPT_EGDSOCKET
    int CURLOPT_CONNECTTIMEOUT
    int CURLOPT_HEADERFUNCTION
    int CURLOPT_HTTPGET
    int CURLOPT_SSL_VERIFYHOST
    int CURLOPT_COOKIEJAR
    int CURLOPT_SSL_CIPHER_LIST
    int CURLOPT_HTTP_VERSION
    int CURLOPT_FTP_USE_EPSV
    int CURLOPT_SSLCERTTYPE
    int CURLOPT_SSLKEY
    int CURLOPT_SSLKEYTYPE
    int CURLOPT_SSLENGINE
    int CURLOPT_SSLENGINE_DEFAULT
    int CURLOPT_DNS_USE_GLOBAL_CACHE
    int CURLOPT_DNS_CACHE_TIMEOUT
    int CURLOPT_PREQUOTE
    int CURLOPT_DEBUGFUNCTION
    int CURLOPT_DEBUGDATA
    int CURLOPT_COOKIESESSION
    int CURLOPT_CAPATH
    int CURLOPT_BUFFERSIZE
    int CURLOPT_NOSIGNAL
    int CURLOPT_SHARE
    int CURLOPT_PROXYTYPE
    int CURLOPT_ACCEPT_ENCODING
    int CURLOPT_PRIVATE
    int CURLOPT_HTTP200ALIASES
    int CURLOPT_UNRESTRICTED_AUTH
    int CURLOPT_FTP_USE_EPRT
    int CURLOPT_HTTPAUTH
    int CURLOPT_SSL_CTX_FUNCTION
    int CURLOPT_SSL_CTX_DATA
    int CURLOPT_FTP_CREATE_MISSING_DIRS
    int CURLOPT_PROXYAUTH
    int CURLOPT_FTP_RESPONSE_TIMEOUT
    int CURLOPT_SERVER_RESPONSE_TIMEOUT
    int CURLOPT_IPRESOLVE
    int CURLOPT_MAXFILESIZE
    int CURLOPT_INFILESIZE_LARGE
    int CURLOPT_RESUME_FROM_LARGE
    int CURLOPT_MAXFILESIZE_LARGE
    int CURLOPT_NETRC_FILE
    int CURLOPT_USE_SSL
    int CURLOPT_POSTFIELDSIZE_LARGE
    int CURLOPT_TCP_NODELAY
    int CURLOPT_FTPSSLAUTH
    int CURLOPT_IOCTLFUNCTION
    int CURLOPT_IOCTLDATA
    int CURLOPT_FTP_ACCOUNT
    int CURLOPT_COOKIELIST
    int CURLOPT_IGNORE_CONTENT_LENGTH
    int CURLOPT_FTP_SKIP_PASV_IP
    int CURLOPT_FTP_FILEMETHOD
    int CURLOPT_LOCALPORT
    int CURLOPT_LOCALPORTRANGE
    int CURLOPT_CONNECT_ONLY
    int CURLOPT_CONV_FROM_NETWORK_FUNCTION
    int CURLOPT_CONV_TO_NETWORK_FUNCTION
    int CURLOPT_CONV_FROM_UTF8_FUNCTION
    int CURLOPT_MAX_SEND_SPEED_LARGE
    int CURLOPT_MAX_RECV_SPEED_LARGE
    int CURLOPT_FTP_ALTERNATIVE_TO_USER
    int CURLOPT_SOCKOPTFUNCTION
    int CURLOPT_SOCKOPTDATA
    int CURLOPT_SSL_SESSIONID_CACHE
    int CURLOPT_SSH_AUTH_TYPES
    int CURLOPT_SSH_PUBLIC_KEYFILE
    int CURLOPT_SSH_PRIVATE_KEYFILE
    int CURLOPT_FTP_SSL_CCC
    int CURLOPT_TIMEOUT_MS
    int CURLOPT_CONNECTTIMEOUT_MS
    int CURLOPT_HTTP_TRANSFER_DECODING
    int CURLOPT_HTTP_CONTENT_DECODING
    int CURLOPT_NEW_FILE_PERMS
    int CURLOPT_NEW_DIRECTORY_PERMS
    int CURLOPT_POSTREDIR
    int CURLOPT_SSH_HOST_PUBLIC_KEY_MD5
    int CURLOPT_OPENSOCKETFUNCTION
    int CURLOPT_OPENSOCKETDATA
    int CURLOPT_COPYPOSTFIELDS
    int CURLOPT_PROXY_TRANSFER_MODE
    int CURLOPT_SEEKFUNCTION
    int CURLOPT_SEEKDATA
    int CURLOPT_CRLFILE
    int CURLOPT_ISSUERCERT
    int CURLOPT_ADDRESS_SCOPE
    int CURLOPT_CERTINFO
    int CURLOPT_USERNAME
    int CURLOPT_PASSWORD
    int CURLOPT_PROXYUSERNAME
    int CURLOPT_PROXYPASSWORD
    int CURLOPT_NOPROXY
    int CURLOPT_TFTP_BLKSIZE
    int CURLOPT_SOCKS5_GSSAPI_SERVICE
    int CURLOPT_SOCKS5_GSSAPI_NEC
    int CURLOPT_PROTOCOLS
    int CURLOPT_REDIR_PROTOCOLS
    int CURLOPT_SSH_KNOWNHOSTS
    int CURLOPT_SSH_KEYFUNCTION
    int CURLOPT_SSH_KEYDATA
    int CURLOPT_MAIL_FROM
    int CURLOPT_MAIL_RCPT
    int CURLOPT_FTP_USE_PRET
    int CURLOPT_RTSP_REQUEST
    int CURLOPT_RTSP_SESSION_ID
    int CURLOPT_RTSP_STREAM_URI
    int CURLOPT_RTSP_TRANSPORT
    int CURLOPT_RTSP_CLIENT_CSEQ
    int CURLOPT_RTSP_SERVER_CSEQ
    int CURLOPT_INTERLEAVEDATA
    int CURLOPT_INTERLEAVEFUNCTION
    int CURLOPT_WILDCARDMATCH
    int CURLOPT_CHUNK_BGN_FUNCTION
    int CURLOPT_CHUNK_END_FUNCTION
    int CURLOPT_FNMATCH_FUNCTION
    int CURLOPT_CHUNK_DATA
    int CURLOPT_FNMATCH_DATA
    int CURLOPT_RESOLVE
    int CURLOPT_TLSAUTH_USERNAME
    int CURLOPT_TLSAUTH_PASSWORD
    int CURLOPT_TLSAUTH_TYPE
    int CURLOPT_TRANSFER_ENCODING
    int CURLOPT_CLOSESOCKETFUNCTION
    int CURLOPT_CLOSESOCKETDATA
    int CURLOPT_GSSAPI_DELEGATION
    int CURLOPT_DNS_SERVERS
    int CURLOPT_ACCEPTTIMEOUT_MS
    int CURLOPT_TCP_KEEPALIVE
    int CURLOPT_TCP_KEEPIDLE
    int CURLOPT_TCP_KEEPINTVL
    int CURLOPT_SSL_OPTIONS
    int CURLOPT_MAIL_AUTH
    int CURLOPT_SASL_IR
    int CURLOPT_XFERINFOFUNCTION
    int CURLOPT_XOAUTH2_BEARER
    int CURLOPT_DNS_INTERFACE
    int CURLOPT_DNS_LOCAL_IP4
    int CURLOPT_DNS_LOCAL_IP6
    int CURLOPT_LOGIN_OPTIONS
    int CURLOPT_SSL_ENABLE_NPN
    int CURLOPT_SSL_ENABLE_ALPN
    int CURLOPT_EXPECT_100_TIMEOUT_MS
    int CURLOPT_PROXYHEADER
    int CURLOPT_HEADEROPT
    int CURLOPT_PINNEDPUBLICKEY
    int CURLOPT_UNIX_SOCKET_PATH
    int CURLOPT_SSL_VERIFYSTATUS
    int CURLOPT_SSL_FALSESTART
    int CURLOPT_PATH_AS_IS
    int CURLOPT_PROXY_SERVICE_NAME
    int CURLOPT_SERVICE_NAME
    int CURLOPT_PIPEWAIT
    int CURLOPT_DEFAULT_PROTOCOL
    int CURLOPT_STREAM_WEIGHT
    int CURLOPT_STREAM_DEPENDS
    int CURLOPT_STREAM_DEPENDS_E
    int CURLOPT_TFTP_NO_OPTIONS
    int CURLOPT_CONNECT_TO
    int CURLOPT_TCP_FASTOPEN
    int CURLOPT_KEEP_SENDING_ON_ERROR
    int CURLOPT_PROXY_CAINFO
    int CURLOPT_PROXY_CAPATH
    int CURLOPT_PROXY_SSL_VERIFYPEER
    int CURLOPT_PROXY_SSL_VERIFYHOST
    int CURLOPT_PROXY_SSLVERSION
    int CURLOPT_PROXY_TLSAUTH_USERNAME
    int CURLOPT_PROXY_TLSAUTH_PASSWORD
    int CURLOPT_PROXY_TLSAUTH_TYPE
    int CURLOPT_PROXY_SSLCERT
    int CURLOPT_PROXY_SSLCERTTYPE
    int CURLOPT_PROXY_SSLKEY
    int CURLOPT_PROXY_SSLKEYTYPE
    int CURLOPT_PROXY_KEYPASSWD
    int CURLOPT_PROXY_SSL_CIPHER_LIST
    int CURLOPT_PROXY_CRLFILE
    int CURLOPT_PROXY_SSL_OPTIONS
    int CURLOPT_PRE_PROXY
    int CURLOPT_PROXY_PINNEDPUBLICKEY
    int CURLOPT_ABSTRACT_UNIX_SOCKET
    int CURLOPT_SUPPRESS_CONNECT_HEADERS
    int CURLOPT_REQUEST_TARGET
    int CURLOPT_SOCKS5_AUTH
    int CURLOPT_SSH_COMPRESSION
    int CURLOPT_MIMEPOST
    int CURLOPT_TIMEVALUE_LARGE
    int CURLOPT_HAPPY_EYEBALLS_TIMEOUT_MS
    int CURLOPT_RESOLVER_START_FUNCTION
    int CURLOPT_RESOLVER_START_DATA
    int CURLOPT_HAPROXYPROTOCOL
    int CURLOPT_DNS_SHUFFLE_ADDRESSES
    int CURLOPT_TLS13_CIPHERS
    int CURLOPT_PROXY_TLS13_CIPHERS
    int CURLOPT_DISALLOW_USERNAME_IN_URL
    int CURLOPT_DOH_URL
    int CURLOPT_UPLOAD_BUFFERSIZE
    int CURLOPT_UPKEEP_INTERVAL_MS
    int CURLOPT_CURLU
    int CURLOPT_TRAILERFUNCTION
    int CURLOPT_TRAILERDATA
    int CURLOPT_HTTP09_ALLOWED
    int CURLOPT_ALTSVC_CTRL
    int CURLOPT_ALTSVC
    int CURLOPT_MAXAGE_CONN
    int CURLOPT_SASL_AUTHZID
    int CURLOPT_MAIL_RCPT_ALLLOWFAILS
    int CURLOPT_SSLCERT_BLOB
    int CURLOPT_SSLKEY_BLOB
    int CURLOPT_PROXY_SSLCERT_BLOB
    int CURLOPT_PROXY_SSLKEY_BLOB
    int CURLOPT_ISSUERCERT_BLOB
    int CURLOPT_PROXY_ISSUERCERT
    int CURLOPT_PROXY_ISSUERCERT_BLOB
    int CURLOPT_SSL_EC_CURVES
    int CURLOPT_HSTS_CTRL
    int CURLOPT_HSTS
    int CURLOPT_HSTSREADFUNCTION
    int CURLOPT_HSTSREADDATA
    int CURLOPT_HSTSWRITEFUNCTION
    int CURLOPT_HSTSWRITEDATA
    int CURLOPT_AWS_SIGV4
    int CURLOPT_DOH_SSL_VERIFYPEER
    int CURLOPT_DOH_SSL_VERIFYHOST
    int CURLOPT_DOH_SSL_VERIFYSTATUS
    int CURLOPT_CAINFO_BLOB
    int CURLOPT_PROXY_CAINFO_BLOB
    int CURLOPT_SSH_HOST_PUBLIC_KEY_SHA256
    int CURLOPT_PREREQFUNCTION
    int CURLOPT_PREREQDATA
    int CURLOPT_MAXLIFETIME_CONN
    int CURLOPT_MIME_OPTIONS
    int CURLOPT_SSH_HOSTKEYFUNCTION
    int CURLOPT_SSH_HOSTKEYDATA
    int CURLOPT_HTTPBASEHEADER
    int CURLOPT_SSL_SIG_HASH_ALGS
    int CURLOPT_SSL_ENABLE_ALPS
    int CURLOPT_SSL_CERT_COMPRESSION
    int CURLOPT_SSL_ENABLE_TICKET
    int CURLOPT_HTTP2_PSEUDO_HEADERS_ORDER
    int CURLOPT_HTTP2_NO_SERVER_PUSH
    int CURLOPT_SSL_PERMUTE_EXTENSIONS
    # int CURLOPT_PROTOCOLS_STR
    # int CURLOPT_REDIR_PROTOCOLS_STR
    # int CURLOPT_WS_OPTIONS
    # int CURLOPT_CA_CACHE_TIMEOUT
    # int CURLOPT_QUICK_EXIT
    # int CURLOPT_HTTPBASEHEADER
    # int CURLOPT_SSL_SIG_HASH_ALGS
    # int CURLOPT_SSL_ENABLE_ALPS
    # int CURLOPT_SSL_CERT_COMPRESSION
    # int CURLOPT_SSL_ENABLE_TICKET
    # int CURLOPT_HTTP2_PSEUDO_HEADERS_ORDER
    # int CURLOPT_HTTP2_SETTINGS
    # int CURLOPT_SSL_PERMUTE_EXTENSIONS
    # int CURLOPT_HTTP2_WINDOW_UPDATE
    # int CURLOPT_ECH


    int CURLINFO_TEXT
    int CURLINFO_HEADER_IN
    int CURLINFO_HEADER_OUT
    int CURLINFO_DATA_IN
    int CURLINFO_DATA_OUT
    int CURLINFO_SSL_DATA_IN
    int CURLINFO_SSL_DATA_OUT

    int CURLINFO_EFFECTIVE_URL
    int CURLINFO_RESPONSE_CODE
    int CURLINFO_TOTAL_TIME
    int CURLINFO_NAMELOOKUP_TIME
    int CURLINFO_CONNECT_TIME
    int CURLINFO_PRETRANSFER_TIME
    int CURLINFO_SIZE_UPLOAD
    int CURLINFO_SIZE_UPLOAD_T
    int CURLINFO_SIZE_DOWNLOAD
    int CURLINFO_SIZE_DOWNLOAD_T
    int CURLINFO_SPEED_DOWNLOAD
    int CURLINFO_SPEED_DOWNLOAD_T
    int CURLINFO_SPEED_UPLOAD
    int CURLINFO_SPEED_UPLOAD_T
    int CURLINFO_HEADER_SIZE
    int CURLINFO_REQUEST_SIZE
    int CURLINFO_SSL_VERIFYRESULT
    int CURLINFO_FILETIME
    int CURLINFO_FILETIME_T
    int CURLINFO_CONTENT_LENGTH_DOWNLOAD
    int CURLINFO_CONTENT_LENGTH_DOWNLOAD_T
    int CURLINFO_CONTENT_LENGTH_UPLOAD
    int CURLINFO_CONTENT_LENGTH_UPLOAD_T
    int CURLINFO_STARTTRANSFER_TIME
    int CURLINFO_CONTENT_TYPE
    int CURLINFO_REDIRECT_TIME
    int CURLINFO_REDIRECT_COUNT
    int CURLINFO_PRIVATE
    int CURLINFO_HTTP_CONNECTCODE
    int CURLINFO_HTTPAUTH_AVAIL
    int CURLINFO_PROXYAUTH_AVAIL
    int CURLINFO_OS_ERRNO
    int CURLINFO_NUM_CONNECTS
    int CURLINFO_SSL_ENGINES
    int CURLINFO_COOKIELIST
    int CURLINFO_LASTSOCKET
    int CURLINFO_FTP_ENTRY_PATH
    int CURLINFO_REDIRECT_URL
    int CURLINFO_PRIMARY_IP
    int CURLINFO_APPCONNECT_TIME
    int CURLINFO_CERTINFO
    int CURLINFO_CONDITION_UNMET
    int CURLINFO_RTSP_SESSION_ID
    int CURLINFO_RTSP_CLIENT_CSEQ
    int CURLINFO_RTSP_SERVER_CSEQ
    int CURLINFO_RTSP_CSEQ_RECV
    int CURLINFO_PRIMARY_PORT
    int CURLINFO_LOCAL_IP
    int CURLINFO_LOCAL_PORT
    int CURLINFO_TLS_SESSION
    int CURLINFO_ACTIVESOCKET
    int CURLINFO_TLS_SSL_PTR
    int CURLINFO_HTTP_VERSION
    int CURLINFO_PROXY_SSL_VERIFYRESULT
    int CURLINFO_PROTOCOL
    int CURLINFO_SCHEME
    int CURLINFO_TOTAL_TIME_T
    int CURLINFO_NAMELOOKUP_TIME_T
    int CURLINFO_CONNECT_TIME_T
    int CURLINFO_PRETRANSFER_TIME_T
    int CURLINFO_STARTTRANSFER_TIME_T
    int CURLINFO_REDIRECT_TIME_T
    int CURLINFO_APPCONNECT_TIME_T
    int CURLINFO_RETRY_AFTER
    int CURLINFO_EFFECTIVE_METHOD
    int CURLINFO_PROXY_ERROR
    int CURLINFO_REFERER
    int CURLINFO_CAINFO
    int CURLINFO_CAPATH
    int CURLINFO_LASTONE

    int CURLMOPT_SOCKETFUNCTION
    int CURLMOPT_SOCKETDATA
    int CURLMOPT_PIPELINING
    int CURLMOPT_TIMERFUNCTION
    int CURLMOPT_TIMERDATA
    int CURLMOPT_MAXCONNECTS
    int CURLMOPT_MAX_HOST_CONNECTIONS
    int CURLMOPT_MAX_PIPELINE_LENGTH
    int CURLMOPT_CONTENT_LENGTH_PENALTY_SIZE
    int CURLMOPT_CHUNK_LENGTH_PENALTY_SIZE
    int CURLMOPT_PIPELINING_SITE_BL
    int CURLMOPT_PIPELINING_SERVER_BL
    int CURLMOPT_MAX_TOTAL_CONNECTIONS
    int CURLMOPT_PUSHFUNCTION
    int CURLMOPT_PUSHDATA
    int CURLMOPT_MAX_CONCURRENT_STREAMS


    int CURLE_OK
    int CURLE_UNSUPPORTED_PROTOCOL
    int CURLE_FAILED_INIT
    int CURLE_URL_MALFORMAT
    int CURLE_NOT_BUILT_IN
    int CURLE_COULDNT_RESOLVE_PROXY
    int CURLE_COULDNT_RESOLVE_HOST
    int CURLE_COULDNT_CONNECT
    int CURLE_WEIRD_SERVER_REPLY
    int CURLE_REMOTE_ACCESS_DENIED
    int CURLE_FTP_ACCEPT_FAILED
    int CURLE_FTP_WEIRD_PASS_REPLY
    int CURLE_FTP_ACCEPT_TIMEOUT
    int CURLE_FTP_WEIRD_PASV_REPLY
    int CURLE_FTP_WEIRD_227_FORMAT
    int CURLE_FTP_CANT_GET_HOST
    int CURLE_HTTP2
    int CURLE_FTP_COULDNT_SET_TYPE
    int CURLE_PARTIAL_FILE
    int CURLE_FTP_COULDNT_RETR_FILE
    int CURLE_OBSOLETE20
    int CURLE_QUOTE_ERROR
    int CURLE_HTTP_RETURNED_ERROR
    int CURLE_WRITE_ERROR
    int CURLE_OBSOLETE24
    int CURLE_UPLOAD_FAILED
    int CURLE_READ_ERROR
    int CURLE_OUT_OF_MEMORY
    int CURLE_OPERATION_TIMEDOUT
    int CURLE_OBSOLETE29
    int CURLE_FTP_PORT_FAILED
    int CURLE_FTP_COULDNT_USE_REST
    int CURLE_OBSOLETE32
    int CURLE_RANGE_ERROR
    int CURLE_HTTP_POST_ERROR
    int CURLE_SSL_CONNECT_ERROR
    int CURLE_BAD_DOWNLOAD_RESUME
    int CURLE_FILE_COULDNT_READ_FILE
    int CURLE_LDAP_CANNOT_BIND
    int CURLE_LDAP_SEARCH_FAILED
    int CURLE_OBSOLETE40
    int CURLE_FUNCTION_NOT_FOUND
    int CURLE_ABORTED_BY_CALLBACK
    int CURLE_BAD_FUNCTION_ARGUMENT
    int CURLE_OBSOLETE44
    int CURLE_INTERFACE_FAILED
    int CURLE_OBSOLETE46
    int CURLE_TOO_MANY_REDIRECTS
    int CURLE_UNKNOWN_OPTION
    int CURLE_SETOPT_OPTION_SYNTAX
    int CURLE_OBSOLETE50
    int CURLE_OBSOLETE51
    int CURLE_GOT_NOTHING
    int CURLE_SSL_ENGINE_NOTFOUND
    int CURLE_SSL_ENGINE_SETFAILED
    int CURLE_SEND_ERROR
    int CURLE_RECV_ERROR
    int CURLE_OBSOLETE57
    int CURLE_SSL_CERTPROBLEM
    int CURLE_SSL_CIPHER
    int CURLE_PEER_FAILED_VERIFICATION
    int CURLE_BAD_CONTENT_ENCODING
    int CURLE_OBSOLETE62
    int CURLE_FILESIZE_EXCEEDED
    int CURLE_USE_SSL_FAILED
    int CURLE_SEND_FAIL_REWIND
    int CURLE_SSL_ENGINE_INITFAILED
    int CURLE_LOGIN_DENIED
    int CURLE_TFTP_NOTFOUND
    int CURLE_TFTP_PERM
    int CURLE_REMOTE_DISK_FULL
    int CURLE_TFTP_ILLEGAL
    int CURLE_TFTP_UNKNOWNID
    int CURLE_REMOTE_FILE_EXISTS
    int CURLE_TFTP_NOSUCHUSER
    int CURLE_CONV_FAILED
    int CURLE_OBSOLETE76
    int CURLE_SSL_CACERT_BADFILE
    int CURLE_REMOTE_FILE_NOT_FOUND
    int CURLE_SSH
    int CURLE_SSL_SHUTDOWN_FAILED
    int CURLE_AGAIN
    int CURLE_SSL_CRL_BADFILE
    int CURLE_SSL_ISSUER_ERROR
    int CURLE_FTP_PRET_FAILED
    int CURLE_RTSP_CSEQ_ERROR
    int CURLE_RTSP_SESSION_ERROR
    int CURLE_FTP_BAD_FILE_LIST
    int CURLE_CHUNK_FAILED
    int CURLE_NO_CONNECTION_AVAILABLE
    int CURLE_SSL_PINNEDPUBKEYNOTMATCH
    int CURLE_SSL_INVALIDCERTSTATUS
    int CURLE_HTTP2_STREAM
    int CURLE_RECURSIVE_API_CALL
    int CURLE_AUTH_ERROR
    int CURLE_HTTP3
    int CURLE_QUIC_CONNECT_ERROR
    int CURLE_PROXY
    int CURLE_SSL_CLIENTCERT
    int CURLE_UNRECOVERABLE_POLL

    unsigned int CURL_WRITEFUNC_PAUSE
    unsigned int CURL_WRITEFUNC_ERROR

    int CURL_POLL_NONE
    int CURL_POLL_IN
    int CURL_POLL_OUT
    int CURL_POLL_INOUT
    int CURL_POLL_REMOVE

    int CURL_SOCKET_TIMEOUT
    int CURL_SOCKET_BAD

    int CURL_CSELECT_IN
    int CURL_CSELECT_OUT
    int CURL_CSELECT_ERR

    int CURLMSG_DONE

    int CURLWS_TEXT
    int CURLWS_BINARY
    int CURLWS_CONT
    int CURLWS_CLOSE
    int CURLWS_PING
    int CURLWS_OFFSET
    int CURLWS_PONG
    int CURLWS_RAW_MODE


cdef extern from "shim.h" nogil:
    int _curl_easy_setopt(CURL * curl, int option, void * param)

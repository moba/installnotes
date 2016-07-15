# remove last octet/hextet from IP address in nginx access.log
# does not affect error log

log_format sanitized '$http_host $sanitized_remote_addr [$time_local] '
                    '"$request" $status $body_bytes_sent '
                    '"$http_referer" "$http_user_agent" '
                    '$request_time';
access_log /var/log/nginx/access.log sanitized;

server {
	set $sanitized_remote_addr $remote_addr;
	if ($remote_addr ~* (.*):(.*)) {
        set $sanitized_remote_addr $1:0;
	}
	if ($remote_addr ~* (.*)\.(.*)) {
        set $sanitized_remote_addr $1.0;
	}
	...
}

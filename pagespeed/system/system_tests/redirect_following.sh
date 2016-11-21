start_test single redirect works
# Test single redirect
URL=http://redirecting-fetch.example.com/redir_to_test/
URL+=styles/A.blue.css.pagespeed.cf.0.css
echo "$URL"
echo "http_proxy=$SECONDARY_HOSTNAME $WGET_DUMP $URL"
OUT=$(http_proxy=$SECONDARY_HOSTNAME $WGET_DUMP $URL 2>&1)
check_from "$OUT" fgrep -qi '200 OK'
check_from "$OUT" fgrep -qi 'content-type: text/css'
check_from "$OUT" fgrep -qi '.yellow{'
check_not_from "$OUT" fgrep -qi 'location:'

start_test multi redirect works
URL=http://redirecting-fetch.example.com/redir_to_test/
URL+=styles/A.1.css.pagespeed.cf.0.css
echo "$URL"
OUT=$(http_proxy=$SECONDARY_HOSTNAME $WGET_DUMP $URL 2>&1)
check_from "$OUT" fgrep -qi '200 OK'
check_from "$OUT" fgrep -qi 'content-type: text/css'
check_from "$OUT" fgrep -qi '.yellow{'
check_not_from "$OUT" fgrep -qi 'location:'

start_test disallowed redirect are not followed
URL=http://redirecting-fetch.example.com/redir_to_test/
URL+=styles/A.redirtodisallowed.css.pagespeed.cf.0.css
echo "$URL"
OUT=$(http_proxy=$SECONDARY_HOSTNAME check_not $WGET_DUMP --content-on-error $URL 2>&1)
check_from "$OUT" fgrep -qi '404 not found'

start_test max redirects is respected
URL=http://redirecting-fetch-single-only.example.com/redir_to_test/
URL+=styles/A.1.css.pagespeed.cf.0.css
echo "$URL"
OUT=$(http_proxy=$SECONDARY_HOSTNAME check_not $WGET_DUMP --content-on-error $URL 2>&1)
check_from "$OUT" fgrep -qi '404 not found'

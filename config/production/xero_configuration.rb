$xero_options = {:site => 'https://api.xero.com',
           :request_token_path => "/oauth/RequestToken",
           :access_token_path  => "/oauth/AccessToken",
           :authorize_path     => "/oauth/Authorize",
           :signature_method => 'RSA-SHA1',
           :private_key_file => File.join(File.dirname(__FILE__), '../../keys/xero.rsa')}
$xero_consumer_key = 'Y2MYZTEXMZG3MDRHNGFIZDK1MJZMYZ'
$xero_secret_key = 'V1XDBBKOKVUWQ90LXTGYRVTNNJHWVI'
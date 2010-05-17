$xero_options = {:site => 'https://api.xero.com',
           :request_token_path => "/oauth/RequestToken",
           :access_token_path  => "/oauth/AccessToken",
           :authorize_path     => "/oauth/Authorize",
           :signature_method => 'RSA-SHA1',
           :private_key_file => File.join(File.dirname(__FILE__), '../../keys/xero.rsa')}
$xero_consumer_key = 'NTA0YZDJZTM0M2JHNDQ0MMJHY2NLMT'
$xero_secret_key = 'XHHWNGJGRUDMXQKVBQIZEBGG2ROFRF'
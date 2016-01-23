require 'rubygems'
require 'bundler'

# set env
RACK_ENV = (ENV['RACK_ENV'] || 'development')
SESSION_SECRET = (ENV['SESSION_SECRET'] || 'waterpi_secret')
AWS_ACCESS_KEY = ''
AWS_SECRET_ACCESS_KEY = ''
AWS_IOT_URL = '' # should be like xxxxx.amazonaws.com
KEY_FILE_NAME = '' # .key file name under certs folder
CERT_FILE_NAME = '' # .crt file name under certs folder
CA_FILE_NAME = 'rootCA.pem' # .pem file name for rootCA.pem file

# require gems
Bundler.require(:default, RACK_ENV) if defined?(Bundler)

# set load paths
load_paths = %w(config/initializers lib models)

# load the project files
load_paths.each do |path|
  Dir[File.join(__dir__, path, '**', '*.rb')].each { |file| require file }
end

Aws.config.update({
  region: 'us-west-2',
  credentials: Aws::Credentials.new(AWS_ACCESS_KEY, AWS_SECRET_ACCESS_KEY),
})

Dynamoid.configure do |config|
  config.adapter = 'aws_sdk_v2' # This adapter establishes a connection to the DynamoDB servers using Amazon's own AWS gem.
  config.namespace = "waterpi" # To namespace tables created by Dynamoid from other tables you might have.
  config.warn_on_scan = true # Output a warning to the logger when you perform a scan rather than a query on a table.
  config.read_capacity = 5 # Read capacity for your tables
  config.write_capacity = 5 # Write capacity for your tables
  config.endpoint = 'https://dynamodb.us-east-1.amazonaws.com'
end

# mqtt client
CLIENT = MQTT::Client.connect(
  host: AWS_IOT_URL,
  port: 8883,
  ssl:  true,
  key_file: File.join(__dir__, 'certs', KEY_FILE_NAME),
  cert_file: File.join(__dir__, 'certs', CERT_FILE_NAME),
  ca_file: File.join(__dir__, 'certs', CA_FILE_NAME)
)

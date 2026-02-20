require 'openai'

OpenAI.configure do |config|
  # &. を使うことで、キーがなくてもエラー（nil）で止まらないようにします
  config.access_token = Rails.application.credentials.openai&.[](:api_key)
  config.log_errors = true
end

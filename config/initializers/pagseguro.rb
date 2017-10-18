PagSeguro.configure do |config|
  config.token       = ENV["PAG_SEGURO_TOKEN"]
  config.email       = ENV["PAG_SEGURO_EMAIL"]
  config.environment = :sandbox # ou :production. O padrão é production.
  config.encoding    = "UTF-8" # ou ISO-8859-1. O padrão é UTF-8.
end

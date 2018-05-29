class Application < Rails::Application
  config.company_email_addresses = config_for(:company_email_addresses)
end

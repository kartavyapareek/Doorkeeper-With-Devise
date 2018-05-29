module Billeasy
  class Application < Rails::Application
    config.gupshup = config_for(:gupshup)
  end
end

loader = Zeitwerk::Loader.for_gem

if Rails.env.development?
  loader.enable_reloading

  Rails.application.reloader.to_prepare do
    loader.reload
  end
end

loader.setup

module Finnhub
  class RequestError < StandardError; end
end

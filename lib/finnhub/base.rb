module Finnhub
  class Base
    class_attribute :client
    self.client = Finnhub::Client.new

    def self.get(*args, **kwargs); client.get(*args, **kwargs); end
    def      get(*args, **kwargs); client.get(*args, **kwargs); end
  end
end

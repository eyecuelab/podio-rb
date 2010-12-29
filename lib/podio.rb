require 'faraday'
require 'active_support/core_ext'

require 'podio/middleware/logger'
require 'podio/middleware/oauth2'
require 'podio/middleware/podio_api'
require 'podio/middleware/yajl_response'
require 'podio/middleware/error_response'
require 'podio/middleware/response_recorder'

module Podio
  class << self
    attr_accessor :api_key
    attr_accessor :api_secret
    attr_accessor :api_url
    attr_accessor :debug

    def configure
      yield self
      true
    end

    def client
      Thread.current[:podio_client] ||= Podio::Client.new
    end

    def client=(new_client)
      Thread.current[:podio_client] = new_client
    end

    def connection
      client.connection
    end
  end

  class OAuthToken < Struct.new(:access_token, :refresh_token, :expires_at)
    def initialize(params = {})
      self.access_token = params['access_token']
      self.refresh_token = params['refresh_token']
      self.expires_at = Time.now + params['expires_in'] if params['expires_in']
    end
  end

  autoload :Client,          'podio/client'
  autoload :Error,           'podio/error'
  autoload :ResponseWrapper, 'podio/response_wrapper'

  autoload :Organization,    'podio/areas/organization'
  autoload :Contact,         'podio/areas/contact'
  autoload :Item,            'podio/areas/item'
  autoload :Category,        'podio/areas/app_store'
  autoload :Space,           'podio/areas/space'
  autoload :Widget,          'podio/areas/widget'
end

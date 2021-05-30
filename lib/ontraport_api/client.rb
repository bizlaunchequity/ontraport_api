require 'httparty'
require_relative 'apis/campaigns'
require_relative 'apis/contacts'
require_relative 'apis/forms'
require_relative 'apis/messages'
require_relative 'apis/objects'
require_relative 'apis/products'
require_relative 'apis/sequences'
require_relative 'apis/tags'
require_relative 'apis/tasks'
require_relative 'apis/transactions'

module OntraportApi
  class Client
    include HTTParty
    base_uri 'https://api.ontraport.com/1'

    include APIs::Campaigns
    include APIs::Contacts
    include APIs::Products
    include APIs::Forms
    include APIs::Messages
    include APIs::Objects
    include APIs::Products
    include APIs::Sequences
    include APIs::Tags
    include APIs::Tasks
    include APIs::Transactions

    class InvalidAppIdOrApiKey < StandardError
      def to_s
        "APP ID and API Key must not be blank"
      end
    end

    class InvalidAPIMethodOrPath < StandardError
      def to_s
        "Invalid API Method or Path"
      end
    end

    def initialize(app_id, api_key)
      raise InvalidAppIdOrApiKey if [app_id, api_key].any? { |w| w !~ blank_regex }
      @app_id = app_id
      @api_key = api_key
    end

    def method_missing(method, *args, &block)
      if method.to_s =~ /^get_[\w]+_by_[\w]+/
        match, subject, keyword = method.to_s.match(/^get_(\w+)_by_(\w+)/).to_a

        if !respond_to?("get_#{subject}".to_sym) || [subject, keyword].any? { |w| w !~ blank_regex }
          return super
        end

        self.send("get_#{subject}", "#{keyword} = '#{args[0]}'")
      else
        super
      end
    end

    private

    def query(method, path, payload = {})
      raise InvalidAPIMethodOrPath if [method, path].any? { |w| w !~ blank_regex } || ![:get, :post, :put, :delete].include?(method)

      options = { headers: content_type_header.merge(api_credentials_headers) }
      if method == :get
        options[:query] = payload
      else
        options[:body] = payload.to_json
      end

      response = self.class.send(method, path, options)

      raise InvalidAppIdOrApiKey if response.code == 401

      OpenStruct.new(
        parsed_response: response.parsed_response['data'],
        original_response: response
      )
    rescue JSON::ParserError => e
      {
        'error'   => true,
        'message' => response.body
      }
    end

    def content_type_header
      { 'Content-Type' => 'application/json' }
    end

    def api_credentials_headers
      { 'Api-Appid' => @app_id, 'Api-Key' => @api_key }
    end

    def blank_regex
      /[^[:space:]]/
    end
  end
end

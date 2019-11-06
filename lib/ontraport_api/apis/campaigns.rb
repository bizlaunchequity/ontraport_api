module OntraportApi
  module APIs
    module Campaigns
      CAMPAIGNS_OBJECT_ID = 140
      CAMPAIGNS_API_METHODS_AND_PATHS = {
        'get_campaigns'      => [:get,   '/objects'],
        'get_campaigns_info' => [:get,   '/objects/getInfo']
      }.freeze

      def get_campaigns(conditions = {})
        conditions = { condition: conditions } if conditions.is_a? String
        query_campaigns(conditions)
      end

      def get_campaigns_info(conditions = {})
        conditions = { condition: conditions } if conditions.is_a? String
        query_campaigns(conditions)
      end

      def query_campaigns(payload = {})
        method, path = CAMPAIGNS_API_METHODS_AND_PATHS[caller[0][/`.*'/][1..-2]]
        query(method, path, payload.merge(objectID: CAMPAIGNS_OBJECT_ID))
      end
    end
  end
end

module OntraportApi
  module APIs
    module Tags
      TAGS_OBJECT_ID = 14
      TAGS_API_METHODS_AND_PATHS = {
        'get_tags'      => [:get,   '/objects'],
        'new_tag'       => [:post,  '/objects'],
        'get_tags_info' => [:get,   '/objects/getInfo']
      }

      def get_tags(conditions = {})
        conditions = { condition: conditions } if conditions.is_a? String
        query_tags(conditions)
      end

      def new_tag(tag_name)
        query_tags({ tag_name: tag_name })
      end

      def get_tags_info(conditions = {})
        conditions = { condition: conditions } if conditions.is_a? String
        query_tags(conditions)
      end

      def query_tags(payload = {})
        method, path = TAGS_API_METHODS_AND_PATHS[caller[0][/`.*'/][1..-2]]
        query(method, path, payload.merge({ objectID: TAGS_OBJECT_ID }))
      end
    end
  end
end

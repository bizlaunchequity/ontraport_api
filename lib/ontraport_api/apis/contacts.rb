module OntraportApi
  module APIs
    module Contacts
      CONTACTS_OBJECT_ID = 0
      CONTACTS_API_METHODS_AND_PATHS = {
        'get_contact'                 => [:get,     '/object'],
        'new_contact'                 => [:post,    '/objects'],
        'save_or_update_contact'      => [:post,    '/objects/saveorupdate'],
        'update_contact'              => [:put,     '/objects'],
        'add_sequences_to_contact'    => [:put,     '/objects'],
        'get_contacts'                => [:get,     '/objects'],
        'contact_fields'              => [:get,     '/objects/meta'],
        'add_tags_to_contact'         => [:put,     '/objects/tag'],
        'add_tags_to_contacts'        => [:put,     '/objects/tag'],
        'remove_tags_from_contacts'   => [:delete,  '/objects/tag'],
        'subscribe_contacts_to_campaigns'   => [:put,  '/objects/subscribe'],
        'unsubscribe_contacts_from_campaigns'   => [:delete,  '/objects/subscribe']
      }.freeze

      def get_contact(id)
        query_contacts(id: id)
      end

      def new_contact(payload = {})
        query_contacts(payload)
      end

      def save_or_update_contact(payload = {})
        query_contacts(payload)
      end

      def update_contact(id, payload = {})
        query_contacts(payload.merge(id: id))
      end

      def add_sequences_to_contact(id, sequence_ids)
        sequence_ids = convert_array_to_string(sequence_ids, '*/*')
        query_contacts(id: id, updateSequence: "*/*#{sequence_ids}*/*")
      end

      def add_tags_to_contact(id, tag_ids)
        add_tags_to_contacts(tag_ids, "id = #{id}")
      end

      def contact_fields(format = {})
        default_format = { format: 'byId' }
        format = default_format.merge(format)
        query_contacts(format)
      end

      def add_tags_to_contacts(tag_ids, conditions = {})
        conditions = { condition: conditions } if conditions.is_a? String
        default_conditions = {
          performAll: true
        }
        conditions = default_conditions.merge(conditions)

        payload = conditions.merge(
          add_list: convert_array_to_string(tag_ids)
        )
        query_contacts(payload)
      end

      def remove_tags_from_contacts(tag_ids, conditions = {})
        conditions = { condition: conditions } if conditions.is_a? String
        default_conditions = {
          performAll: true
        }
        conditions = default_conditions.merge(conditions)

        payload = conditions.merge(
          remove_list: convert_array_to_string(tag_ids)
        )
        query_contacts(payload)
      end

      def get_contacts(conditions = {})
        conditions = { condition: conditions } if conditions.is_a? String
        default_conditions = {
          performAll: true,
          sortDir: 'asc',
          searchNotes: 'true'
        }
        payload = default_conditions.merge(conditions)
        query_contacts(payload)
      end

      def subscribe_contacts_to_campaigns(campaigns_ids, contacts_ids, conditions = {})
        conditions = { condition: conditions } if conditions.is_a? String
        default_conditions = {
          performAll: true,
          sub_type: 'CAMPAIGN'
        }
        conditions = default_conditions.merge(conditions)
        payload = conditions.merge(
          add_list: convert_array_to_string(campaigns_ids),
          ids: convert_array_to_string(contacts_ids)
        )
        query_contacts(payload)
      end

      def unsubscribe_contacts_from_campaigns(campaigns_ids, contacts_ids, conditions = {})
        conditions = { condition: conditions } if conditions.is_a? String
        default_conditions = {
          performAll: true,
          sub_type: 'CAMPAIGN'
        }
        conditions = default_conditions.merge(conditions)
        payload = conditions.merge(
          remove_list: convert_array_to_string(campaigns_ids),
          ids: convert_array_to_string(contacts_ids)
        )
        query_contacts(payload)
      end

      def query_contacts(payload)
        method, path = CONTACTS_API_METHODS_AND_PATHS[caller[0][/`.*'/][1..-2]]
        query(method, path, payload.merge(objectID: CONTACTS_OBJECT_ID))
      end

      def convert_array_to_string(array, join_by = ',')
        array.is_a?(Array) ? array.join(join_by) : array
      end
    end
  end
end

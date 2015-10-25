module TrafficSpy
  class PayloadCreator
    def self.process(data)
      if source_exists?(data['id'])
        state = create_payload(data)
      else
        state = :not_registered
      end
      response(state)
    end

    def self.response(state)
      case state
      when :missing_payload
        [400, 'Missing Payload']
      when :payload_created
        [200, 'Payload Created']
      when :repeat_request
        [403, 'Already Received Request']
      when :not_registered
        [403, 'Application Not Registered']
      else
        raise 'Unexpected State'
      end
    end

    def self.create_payload(data)
      return :missing_payload if missing_payload?(data['payload'])

      data = DataSanitizer.format_payload(data)
      data = link_foreign_keys(data)

      payload = Payload.new(data) # validate each attribute exists on the model
      return :repeat_request unless payload.save
      :payload_created
    end

  private

    def self.source_exists?(id)
      Source.find_by(identifier: id)
    end

    def self.missing_payload?(payload)
      payload.nil? || payload.empty?
    end

    def self.get_source_id(identifier)
      Source.find_by(identifier: identifier).id
    end

    def self.get_url_id(url, source_id)
      Url.find_or_create_by({url: url, source_id: source_id}).id
    end

    def self.get_request_type_id(request_type)
      RequestType.find_or_create_by(request_type: request_type).id
    end

    def self.get_event_name_id(event_name)
      EventName.find_or_create_by(event_name: event_name).id
    end

    def self.link_foreign_keys(data)
      data[:source_id] = get_source_id(data[:identifier])
      data[:url_id] = get_url_id(data[:url], data[:source_id])
      data[:request_type_id] = get_request_type_id(data[:request_type])
      data[:event_name_id] = get_event_name_id(data[:event_name])
      keys = [:identifier, :url, :request_type, :event_name]
      delete_linked_data(data, keys)
    end

    def self.delete_linked_data(data, keys)
      keys.each { |k| data.delete(k) }
      data
    end
  end
end

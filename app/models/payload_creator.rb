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
      sha = Digest::SHA2.hexdigest(data['payload'])
      source_id = Source.where(identifier: data['id']).pluck('id').first
      data = DataSanitizer.format_payload(data)
      data[:source_id] = source_id
      data[:sha] = sha
      payload = Payload.new(data) # validate each attribute exists on the model
      return :repeat_request unless payload.save # if payload isn't unique
      :payload_created
    end

    def self.source_exists?(id)
      Source.find_by(identifier: id)
    end

    def self.missing_payload?(payload)
      payload.nil? || payload.empty?
    end
  end
end

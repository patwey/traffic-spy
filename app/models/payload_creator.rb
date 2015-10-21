require 'json'

module TrafficSpy
  class PayloadCreator
    def self.process(data)
      if Source.find_by(identifier: data['id']) # if the source exists
        if data['payload'].nil? || data['payload'].empty? # if the payload doesn't exist
          status = 400
          body = 'Missing Payload'

        else # if the payload exists
          data = format_data(data)
          payload = Payload.new(data) # validate each attribute exists on the model
          if payload.save # if the payload is unique
            status = 200 # for testing purposes
            body = 'Payload Created'
          else # if the payload has already been recieved
            status = 403
            body = "Already Received Request"
          end

        end

      else # if the source doesn't exist
        status = 403
        body = "Application Not Registered"
      end

      # return the status and body
      [status, body]
    end

    def self.parse_json(payload)
      JSON.parse(payload)
    end

    def self.format_data(data)
      formatted = {}
      formatted[:sha] = Digest::SHA2.hexdigest(data['payload'])
      formatted[:source_id] = Source.where(identifier: data['id']).pluck('id').first
      payload = parse_json(data['payload'])

      formatted[:url] = payload.fetch("url")
      formatted[:requested_at] = payload.fetch("requestedAt")
      formatted[:responded_in] = payload.fetch("respondedIn")
      formatted[:referred_by] = payload.fetch("referredBy")
      formatted[:request_type] = payload.fetch("requestType")
      formatted[:event_name] = payload.fetch("eventName")
      formatted[:user_agent] = payload.fetch("userAgent")
      formatted[:resolution_width] = payload.fetch("resolutionWidth")
      formatted[:resolution_height] = payload.fetch("resolutionHeight")

      formatted
    end
  end
end

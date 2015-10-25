require 'json'

module TrafficSpy
  class DataSanitizer
    def self.format_payload(data)
      result = {}
      payload = parse_json(data['payload'])

      result[:sha] = sha(data['payload'])
      result[:identifier] = data["id"]
      result[:url] = payload["url"]
      result[:requested_at] = payload["requestedAt"]
      result[:responded_in] = payload["respondedIn"]
      result[:referred_by] = payload["referredBy"]
      result[:request_type] = payload["requestType"]
      result[:user_agent] = payload["userAgent"]
      result[:resolution_width] = payload["resolutionWidth"]
      result[:resolution_height] = payload["resolutionHeight"]
      result[:event_name] = payload["eventName"]
      
      downcase_values(result)
    end

    def self.parse_json(payload)
      begin
        JSON.parse(payload)
      rescue JSON::ParserError => error_msg
        payload = error_msg.to_s.split('\'').last
        "#{payload} is not JSON"
      end
    end

    def self.format_source(data)
      result = {}

      result[:root_url] = data["rootUrl"]
      result[:identifier] = data["identifier"]

      downcase_values(result)
    end

    def self.sha(string)
      Digest::SHA2.hexdigest(string)
    end

    def self.downcase_values(data)
      data.map do |k, v|
        if v.nil? || v.class == Fixnum || k == :event_name
          [k, v]
        else
          [k, v.downcase]
        end
      end.to_h
    end
  end
end

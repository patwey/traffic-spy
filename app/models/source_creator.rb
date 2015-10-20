module TrafficSpy
  class SourceCreator
    def self.process(data)
      data = format_data(data)
      if identifier_exists?(data)
        status = 403
        body = 'Identifier already exists'
      else
        source = Source.new(data)
        if source.save
          # body['identifier'] = data[:identifier]
          body = "{'identifier':'#{source.identifier}'}"
        else
          status = 400
          body = source.errors.full_messages.join(', ')
        end
      end
      [status, body]
    end

    def self.format_data(data) # DataSanitizer?
      result = {}
      result[:root_url] = data["rootUrl"].downcase if data["rootUrl"]
      result[:identifier] = data["identifier"].downcase if data["identifier"]
      result
    end

    def self.identifier_exists?(data)
      Source.exists?(identifier: data[:identifier])
    end
  end
end

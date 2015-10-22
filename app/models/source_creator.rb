module TrafficSpy
  class SourceCreator

    def self.process(data)
      data = DataSanitizer.format_source(data)
      if identifier_exists?(data)
        state = [:identifier_exists]
      else
        state = create_source(data)
      end
      response(state)
    end

    def self.create_source(data)
      source = Source.new(data)
      if source.save
        [:source_created, source]
      else
        [:missing_attributes, source]
      end
    end

    def self.response(state)
      case state.first
      when :identifier_exists
        [403, 'Identifier already exists']
      when :source_created
        [200, "{'identifier':'#{state.last.identifier}'}"]
      when :missing_attributes
        [400, state.last.errors.full_messages.join(', ')]
      else
        raise "Unexpected State"
      end
    end

    def self.identifier_exists?(data)
      Source.exists?(identifier: data[:identifier])
    end
  end
end

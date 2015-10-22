module TrafficSpy
  class PayloadRetriever

    def self.retrieve(identifier)
      source = Source.find_by(identifier: identifier)
      return "Source doesn't exist" unless source
      Payload.where(source_id: source.id)
    end
  end
end

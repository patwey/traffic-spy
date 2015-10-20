module TrafficSpy
  class DataCreator
    def self.process(data)
      if data[:payload].nil? || data[:payload].empty?
        status = 400
        body = 'Missing Payload'
      end
      [status, body]
    end
  end
end

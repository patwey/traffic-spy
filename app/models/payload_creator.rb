module TrafficSpy
  class PayloadCreator
    def self.process(data)
      if Source.find_by(identifier: data[:id]) # if the source exists

        if data[:payload].nil? || data[:payload].empty? # if the payload doesn't exist
          status = 400
          body = 'Missing Payload'

        else # if the payload exists
          sha_key = Digest::SHA2.hexdigest(data[:payload])
          source_id = Source.where(identifier: data[:id]).pluck(:id).first
          payload = Payload.new(sha:       sha_key,
                                source_id: source_id)

          if payload.save # if the payload is unique
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
  end
end

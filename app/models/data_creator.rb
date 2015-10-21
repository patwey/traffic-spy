module TrafficSpy
  class DataCreator
    def self.process(data)
      if Source.find_by(identifier: data[:id]) # if the application is registered
        if data[:payload].nil? || data[:payload].empty?
          status = 400
          body = 'Missing Payload'
        end
      else # not registered
        status = 403
        body = "Application Not Registered"
      end
      [status, body]
    end
  end
end


# Digest::SHA2.hexdigest 'payload'

# class Shahmaker < ActiveRecord::Base
#   validates :shah, uniqueness: { scope: :digest,
#     message: "Request payload has already been recieved." }
# end
